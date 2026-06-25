/* ============================================================================
   File: 04_plsql_programs.sql
   Purpose: Demonstrates Oracle PL/SQL proficiency: stored functions,
            procedures with exception handling, triggers (row-level and
            business-rule enforcement), and a PACKAGE that bundles related
            order-management logic together.
   Run AFTER 01-03. Run each CREATE block with SQL*Plus/SQL Developer as-is
   (the trailing "/" after each PL/SQL block is required).
   ============================================================================ */

----------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------

-- fn_customer_lifetime_value: total amount spent on DELIVERED orders
CREATE OR REPLACE FUNCTION fn_customer_lifetime_value (
    p_customer_id IN customers.customer_id%TYPE
) RETURN NUMBER
IS
    v_total NUMBER := 0;
BEGIN
    SELECT NVL(SUM(total_amount), 0)
    INTO   v_total
    FROM   orders
    WHERE  customer_id = p_customer_id
    AND    status = 'DELIVERED';

    RETURN v_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END fn_customer_lifetime_value;
/

-- fn_product_avg_rating: average review rating for a product (NULL if no reviews)
CREATE OR REPLACE FUNCTION fn_product_avg_rating (
    p_product_id IN products.product_id%TYPE
) RETURN NUMBER
IS
    v_avg NUMBER;
BEGIN
    SELECT ROUND(AVG(rating), 2)
    INTO   v_avg
    FROM   reviews
    WHERE  product_id = p_product_id;

    RETURN v_avg;
END fn_product_avg_rating;
/

-- fn_loyalty_discount_pct: tiered discount based on lifetime value
-- >= 2000 -> 10%, >= 1000 -> 5%, >= 500 -> 2%, else 0%
CREATE OR REPLACE FUNCTION fn_loyalty_discount_pct (
    p_customer_id IN customers.customer_id%TYPE
) RETURN NUMBER
IS
    v_ltv NUMBER;
BEGIN
    v_ltv := fn_customer_lifetime_value(p_customer_id);

    IF v_ltv >= 2000 THEN
        RETURN 10;
    ELSIF v_ltv >= 1000 THEN
        RETURN 5;
    ELSIF v_ltv >= 500 THEN
        RETURN 2;
    ELSE
        RETURN 0;
    END IF;
END fn_loyalty_discount_pct;
/

----------------------------------------------------------------------------
-- STANDALONE PROCEDURE: cancel an order and restore stock (with exception
-- handling and an explicit transaction boundary)
----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_cancel_order (
    p_order_id IN orders.order_id%TYPE
)
IS
    v_status orders.status%TYPE;
BEGIN
    SELECT status INTO v_status FROM orders WHERE order_id = p_order_id;

    IF v_status = 'CANCELLED' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Order ' || p_order_id || ' is already cancelled.');
    END IF;

    IF v_status = 'DELIVERED' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Delivered orders cannot be cancelled.');
    END IF;

    -- Restore stock for every line item on this order
    FOR item IN (SELECT product_id, quantity FROM order_items WHERE order_id = p_order_id) LOOP
        UPDATE products
        SET    stock_quantity = stock_quantity + item.quantity
        WHERE  product_id = item.product_id;
    END LOOP;

    UPDATE orders SET status = 'CANCELLED' WHERE order_id = p_order_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Order ' || p_order_id || ' cancelled and stock restored.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'Order ' || p_order_id || ' does not exist.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END sp_cancel_order;
/

----------------------------------------------------------------------------
-- TRIGGERS
----------------------------------------------------------------------------

-- TRG1: before inserting an order item, make sure enough stock exists
CREATE OR REPLACE TRIGGER trg_check_stock_before_order
BEFORE INSERT ON order_items
FOR EACH ROW
DECLARE
    v_available NUMBER;
BEGIN
    SELECT stock_quantity INTO v_available
    FROM   products
    WHERE  product_id = :NEW.product_id;

    IF v_available < :NEW.quantity THEN
        RAISE_APPLICATION_ERROR(-20010,
            'Insufficient stock for product ' || :NEW.product_id ||
            ' (available: ' || v_available || ', requested: ' || :NEW.quantity || ')');
    END IF;
END;
/

-- TRG2: after an order item is inserted, decrement stock and write an audit row
CREATE OR REPLACE TRIGGER trg_update_stock_after_order
AFTER INSERT ON order_items
FOR EACH ROW
DECLARE
    v_old_qty products.stock_quantity%TYPE;
BEGIN
    SELECT stock_quantity INTO v_old_qty FROM products WHERE product_id = :NEW.product_id;

    UPDATE products
    SET    stock_quantity = stock_quantity - :NEW.quantity
    WHERE  product_id = :NEW.product_id;

    INSERT INTO inventory_log (product_id, old_quantity, new_quantity, change_qty, reason)
    VALUES (:NEW.product_id, v_old_qty, v_old_qty - :NEW.quantity, -:NEW.quantity, 'Order placed');
END;
/

-- TRG3: keep orders.total_amount in sync whenever line items change
CREATE OR REPLACE TRIGGER trg_update_order_total
AFTER INSERT OR UPDATE OR DELETE ON order_items
DECLARE
    v_order_id orders.order_id%TYPE;
BEGIN
    v_order_id := NVL(:NEW.order_id, :OLD.order_id);

    UPDATE orders
    SET    total_amount = (
               SELECT NVL(SUM(quantity * unit_price), 0)
               FROM   order_items
               WHERE  order_id = v_order_id
           )
    WHERE  order_id = v_order_id;
END;
/

-- TRG4: enforce a business rule - a customer may only review a product
-- they have actually purchased in a DELIVERED order
CREATE OR REPLACE TRIGGER trg_review_must_be_purchase
BEFORE INSERT ON reviews
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO   v_count
    FROM   orders o
    JOIN   order_items oi ON oi.order_id = o.order_id
    WHERE  o.customer_id = :NEW.customer_id
    AND    oi.product_id = :NEW.product_id
    AND    o.status = 'DELIVERED';

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20020,
            'Customer ' || :NEW.customer_id ||
            ' cannot review product ' || :NEW.product_id ||
            ' without a delivered order containing it.');
    END IF;
END;
/

----------------------------------------------------------------------------
-- PACKAGE: pkg_order_mgmt - groups the full order lifecycle into one
-- cohesive, reusable API (spec + body), a hallmark of well-structured PL/SQL
----------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE pkg_order_mgmt AS
    -- Creates a new PENDING order header and returns its id
    FUNCTION create_order (
        p_customer_id IN orders.customer_id%TYPE,
        p_address_id  IN orders.shipping_address_id%TYPE,
        p_employee_id IN orders.employee_id%TYPE DEFAULT NULL
    ) RETURN orders.order_id%TYPE;

    -- Adds a line item to an existing order (stock checks handled by triggers)
    PROCEDURE add_item (
        p_order_id   IN order_items.order_id%TYPE,
        p_product_id IN order_items.product_id%TYPE,
        p_quantity   IN order_items.quantity%TYPE
    );

    -- Moves an order from PENDING to PROCESSING once payment is confirmed
    PROCEDURE confirm_payment (
        p_order_id IN payments.order_id%TYPE,
        p_amount   IN payments.amount%TYPE,
        p_method   IN payments.payment_method%TYPE
    );
END pkg_order_mgmt;
/

CREATE OR REPLACE PACKAGE BODY pkg_order_mgmt AS

    FUNCTION create_order (
        p_customer_id IN orders.customer_id%TYPE,
        p_address_id  IN orders.shipping_address_id%TYPE,
        p_employee_id IN orders.employee_id%TYPE DEFAULT NULL
    ) RETURN orders.order_id%TYPE
    IS
        v_order_id orders.order_id%TYPE;
    BEGIN
        INSERT INTO orders (customer_id, employee_id, shipping_address_id, status, total_amount)
        VALUES (p_customer_id, p_employee_id, p_address_id, 'PENDING', 0)
        RETURNING order_id INTO v_order_id;

        RETURN v_order_id;
    END create_order;

    PROCEDURE add_item (
        p_order_id   IN order_items.order_id%TYPE,
        p_product_id IN order_items.product_id%TYPE,
        p_quantity   IN order_items.quantity%TYPE
    )
    IS
        v_price products.unit_price%TYPE;
    BEGIN
        SELECT unit_price INTO v_price FROM products WHERE product_id = p_product_id;

        INSERT INTO order_items (order_id, product_id, quantity, unit_price)
        VALUES (p_order_id, p_product_id, p_quantity, v_price);
        -- trg_check_stock_before_order, trg_update_stock_after_order, and
        -- trg_update_order_total all fire automatically here.
    END add_item;

    PROCEDURE confirm_payment (
        p_order_id IN payments.order_id%TYPE,
        p_amount   IN payments.amount%TYPE,
        p_method   IN payments.payment_method%TYPE
    )
    IS
        v_total orders.total_amount%TYPE;
    BEGIN
        SELECT total_amount INTO v_total FROM orders WHERE order_id = p_order_id;

        INSERT INTO payments (order_id, amount, payment_method, payment_status)
        VALUES (p_order_id, p_amount, p_method,
                CASE WHEN p_amount >= v_total THEN 'COMPLETED' ELSE 'PENDING' END);

        IF p_amount >= v_total THEN
            UPDATE orders SET status = 'PROCESSING' WHERE order_id = p_order_id;
        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END confirm_payment;

END pkg_order_mgmt;
/

----------------------------------------------------------------------------
-- EXAMPLE USAGE (uncomment to test in SQL Developer / SQL*Plus)
----------------------------------------------------------------------------
/*
DECLARE
    v_new_order_id NUMBER;
BEGIN
    v_new_order_id := pkg_order_mgmt.create_order(p_customer_id => 1, p_address_id => 1, p_employee_id => 2);
    pkg_order_mgmt.add_item(v_new_order_id, p_product_id => 6, p_quantity => 1);
    pkg_order_mgmt.confirm_payment(v_new_order_id, p_amount => 129.99, p_method => 'CREDIT_CARD');
    DBMS_OUTPUT.PUT_LINE('Created and paid order: ' || v_new_order_id);
END;
/

SELECT fn_customer_lifetime_value(1) FROM dual;
SELECT fn_loyalty_discount_pct(1)    FROM dual;
EXEC sp_cancel_order(16);
*/
