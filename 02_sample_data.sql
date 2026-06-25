/* ============================================================================
   File: 02_sample_data.sql
   Purpose: Populates the schema with realistic sample data for an
            e-commerce store (10 customers, 17 products, 18 orders, etc.)
   Run AFTER 01_schema_ddl.sql
   ============================================================================ */

-- 1. CUSTOMERS
INSERT INTO customers (customer_id, first_name, last_name, email, phone, registration_date, status) VALUES (1, 'Ayesha', 'Khan', 'ayesha.khan@example.com', '+92-300-1112233', DATE '2024-01-15', 'ACTIVE');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, registration_date, status) VALUES (2, 'Bilal', 'Ahmed', 'bilal.ahmed@example.com', '+92-301-2223344', DATE '2024-02-02', 'ACTIVE');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, registration_date, status) VALUES (3, 'Sara', 'Malik', 'sara.malik@example.com', '+92-302-3334455', DATE '2024-02-20', 'ACTIVE');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, registration_date, status) VALUES (4, 'Usman', 'Tariq', 'usman.tariq@example.com', '+92-303-4445566', DATE '2024-03-05', 'ACTIVE');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, registration_date, status) VALUES (5, 'Hira', 'Javed', 'hira.javed@example.com', '+92-304-5556677', DATE '2024-03-18', 'ACTIVE');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, registration_date, status) VALUES (6, 'Omar', 'Farooq', 'omar.farooq@example.com', '+92-305-6667788', DATE '2024-04-01', 'ACTIVE');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, registration_date, status) VALUES (7, 'Zainab', 'Riaz', 'zainab.riaz@example.com', '+92-306-7778899', DATE '2024-04-22', 'INACTIVE');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, registration_date, status) VALUES (8, 'Hamza', 'Sheikh', 'hamza.sheikh@example.com', '+92-307-8889900', DATE '2024-05-10', 'ACTIVE');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, registration_date, status) VALUES (9, 'Mahnoor', 'Aslam', 'mahnoor.aslam@example.com', '+92-308-9990011', DATE '2024-05-29', 'ACTIVE');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, registration_date, status) VALUES (10, 'Faisal', 'Iqbal', 'faisal.iqbal@example.com', '+92-309-0001122', DATE '2024-06-14', 'ACTIVE');

-- 2. CUSTOMER_ADDRESSES
INSERT INTO customer_addresses (address_id, customer_id, address_type, address_line1, address_line2, city, state_province, postal_code, country) VALUES (1, 1, 'SHIPPING', '12 Mall Road', NULL, 'Lahore', 'Punjab', '54000', 'Pakistan');
INSERT INTO customer_addresses (address_id, customer_id, address_type, address_line1, address_line2, city, state_province, postal_code, country) VALUES (2, 1, 'BILLING', '12 Mall Road', NULL, 'Lahore', 'Punjab', '54000', 'Pakistan');
INSERT INTO customer_addresses (address_id, customer_id, address_type, address_line1, address_line2, city, state_province, postal_code, country) VALUES (3, 2, 'SHIPPING', '45 Clifton Block 4', NULL, 'Karachi', 'Sindh', '75600', 'Pakistan');
INSERT INTO customer_addresses (address_id, customer_id, address_type, address_line1, address_line2, city, state_province, postal_code, country) VALUES (4, 3, 'SHIPPING', '8 F-7 Markaz', NULL, 'Islamabad', 'ICT', '44000', 'Pakistan');
INSERT INTO customer_addresses (address_id, customer_id, address_type, address_line1, address_line2, city, state_province, postal_code, country) VALUES (5, 4, 'SHIPPING', '21 Cantt Bazar', NULL, 'Lahore', 'Punjab', '54810', 'Pakistan');
INSERT INTO customer_addresses (address_id, customer_id, address_type, address_line1, address_line2, city, state_province, postal_code, country) VALUES (6, 5, 'SHIPPING', '3 Gulberg III', NULL, 'Lahore', 'Punjab', '54660', 'Pakistan');
INSERT INTO customer_addresses (address_id, customer_id, address_type, address_line1, address_line2, city, state_province, postal_code, country) VALUES (7, 6, 'SHIPPING', '17 DHA Phase 5', 'Suite 2', 'Karachi', 'Sindh', '75500', 'Pakistan');
INSERT INTO customer_addresses (address_id, customer_id, address_type, address_line1, address_line2, city, state_province, postal_code, country) VALUES (8, 7, 'SHIPPING', '9 Saddar', '', 'Rawalpindi', 'Punjab', '46000', 'Pakistan');
INSERT INTO customer_addresses (address_id, customer_id, address_type, address_line1, address_line2, city, state_province, postal_code, country) VALUES (9, 8, 'SHIPPING', '55 Model Town', NULL, 'Lahore', 'Punjab', '54700', 'Pakistan');
INSERT INTO customer_addresses (address_id, customer_id, address_type, address_line1, address_line2, city, state_province, postal_code, country) VALUES (10, 9, 'SHIPPING', '30 Johar Town', NULL, 'Lahore', 'Punjab', '54782', 'Pakistan');
INSERT INTO customer_addresses (address_id, customer_id, address_type, address_line1, address_line2, city, state_province, postal_code, country) VALUES (11, 10, 'SHIPPING', '14 G-9', '', 'Islamabad', 'ICT', '44080', 'Pakistan');

-- 3. CATEGORIES
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (1, 'Electronics', NULL);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (2, 'Laptops', 1);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (3, 'Smartphones', 1);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (4, 'Home & Kitchen', NULL);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (5, 'Cookware', 4);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (6, 'Fashion', NULL);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (7, 'Men''s Clothing', 6);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (8, 'Women''s Clothing', 6);

-- 4. SUPPLIERS
INSERT INTO suppliers (supplier_id, supplier_name, contact_email, phone, country) VALUES (1, 'TechSource Pvt Ltd', 'sales@techsource.example', '+92-42-111222', 'Pakistan');
INSERT INTO suppliers (supplier_id, supplier_name, contact_email, phone, country) VALUES (2, 'Global Gadgets Co', 'info@globalgadgets.example', '+86-21-333444', 'China');
INSERT INTO suppliers (supplier_id, supplier_name, contact_email, phone, country) VALUES (3, 'HomeStyle Traders', 'contact@homestyle.example', '+92-21-555666', 'Pakistan');
INSERT INTO suppliers (supplier_id, supplier_name, contact_email, phone, country) VALUES (4, 'FashionHub Imports', 'hello@fashionhub.example', '+971-4-777888', 'UAE');

-- 5. PRODUCTS
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (1, 'UltraBook Pro 14', 2, 1, 1299.99, 25, DATE '2024-01-05', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (2, 'GameMaster Laptop 16', 2, 2, 1899.5, 12, DATE '2024-01-10', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (3, 'BudgetBook 13', 2, 1, 549.0, 40, DATE '2024-02-01', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (4, 'SmartPhone X12', 3, 2, 899.0, 60, DATE '2024-01-15', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (5, 'SmartPhone Lite', 3, 2, 399.0, 80, DATE '2024-01-20', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (6, 'NoiseCancel Earbuds', 1, 2, 129.99, 150, DATE '2024-02-10', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (7, '4K Streaming Box', 1, 1, 79.99, 100, DATE '2024-02-15', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (8, 'NonStick Pan Set', 5, 3, 59.99, 70, DATE '2024-01-25', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (9, 'Stainless Cutlery Set', 5, 3, 89.5, 45, DATE '2024-02-05', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (10, 'Espresso Machine', 4, 3, 249.0, 20, DATE '2024-03-01', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (11, 'Men''s Casual Shirt', 7, 4, 29.99, 200, DATE '2024-01-12', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (12, 'Men''s Denim Jacket', 7, 4, 69.99, 90, DATE '2024-02-20', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (13, 'Women''s Summer Dress', 8, 4, 49.99, 110, DATE '2024-02-25', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (14, 'Women''s Handbag', 8, 4, 79.99, 75, DATE '2024-03-10', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (15, 'Wireless Mouse', 1, 1, 19.99, 300, DATE '2024-01-08', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (16, 'Mechanical Keyboard', 1, 1, 89.99, 85, DATE '2024-01-30', 'Y');
INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, stock_quantity, created_date, is_active) VALUES (17, 'Discontinued Tablet', 1, 2, 199.0, 0, DATE '2023-11-01', 'N');

-- 6. EMPLOYEES
INSERT INTO employees (employee_id, first_name, last_name, hire_date, salary, department, manager_id) VALUES (1, 'Ali', 'Raza', DATE '2022-01-10', 250000, 'Sales', NULL);
INSERT INTO employees (employee_id, first_name, last_name, hire_date, salary, department, manager_id) VALUES (2, 'Nadia', 'Sheikh', DATE '2022-03-15', 180000, 'Sales', 1);
INSERT INTO employees (employee_id, first_name, last_name, hire_date, salary, department, manager_id) VALUES (3, 'Tariq', 'Mahmood', DATE '2022-06-01', 175000, 'Sales', 1);
INSERT INTO employees (employee_id, first_name, last_name, hire_date, salary, department, manager_id) VALUES (4, 'Saba', 'Yousaf', DATE '2023-01-20', 160000, 'Support', 1);

-- 7. ORDERS  (total_amount is also recalculated automatically by the
--             trg_update_order_total trigger in script 04 whenever items change)
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (1, 1, 2, 1, DATE '2024-03-01', 'DELIVERED', 1339.97);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (2, 2, 2, 3, DATE '2024-03-03', 'DELIVERED', 1028.99);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (3, 1, 2, 1, DATE '2024-03-15', 'DELIVERED', 179.96);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (4, 3, 3, 4, DATE '2024-03-20', 'DELIVERED', 798.0);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (5, 4, 3, 5, DATE '2024-04-02', 'DELIVERED', 1899.5);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (6, 5, NULL, 6, DATE '2024-04-05', 'SHIPPED', 149.49);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (7, 2, 2, 3, DATE '2024-04-10', 'DELIVERED', 179.97);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (8, 6, 3, 7, DATE '2024-04-18', 'PROCESSING', 549.0);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (9, 1, 2, 1, DATE '2024-04-22', 'DELIVERED', 339.97);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (10, 8, NULL, 9, DATE '2024-05-01', 'DELIVERED', 69.99);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (11, 9, 4, 10, DATE '2024-05-06', 'CANCELLED', 899.0);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (12, 3, 3, 4, DATE '2024-05-12', 'DELIVERED', 249.0);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (13, 10, NULL, 11, DATE '2024-05-20', 'SHIPPED', 1299.99);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (14, 5, NULL, 6, DATE '2024-05-25', 'DELIVERED', 528.99);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (15, 1, 2, 1, DATE '2024-06-02', 'DELIVERED', 179.98);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (16, 4, 3, 5, DATE '2024-06-08', 'PENDING', 59.98);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (17, 8, NULL, 9, DATE '2024-06-12', 'DELIVERED', 89.5);
INSERT INTO orders (order_id, customer_id, employee_id, shipping_address_id, order_date, status, total_amount) VALUES (18, 2, 2, 3, DATE '2024-06-15', 'DELIVERED', 918.99);

-- 8. ORDER_ITEMS
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (1, 1, 1, 1, 1299.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (2, 1, 15, 2, 19.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (3, 2, 4, 1, 899.0);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (4, 2, 6, 1, 129.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (5, 3, 16, 1, 89.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (6, 3, 11, 3, 29.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (7, 4, 5, 2, 399.0);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (8, 5, 2, 1, 1899.5);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (9, 6, 8, 1, 59.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (10, 6, 9, 1, 89.5);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (11, 7, 13, 2, 49.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (12, 7, 14, 1, 79.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (13, 8, 3, 1, 549.0);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (14, 9, 7, 1, 79.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (15, 9, 6, 2, 129.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (16, 10, 12, 1, 69.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (17, 11, 4, 1, 899.0);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (18, 12, 10, 1, 249.0);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (19, 13, 1, 1, 1299.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (20, 14, 5, 1, 399.0);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (21, 14, 6, 1, 129.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (22, 15, 16, 2, 89.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (23, 16, 11, 2, 29.99);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (24, 17, 9, 1, 89.5);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (25, 18, 4, 1, 899.0);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (26, 18, 15, 1, 19.99);

-- 9. PAYMENTS
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (1, 1, DATE '2024-03-01', 1339.97, 'CREDIT_CARD', 'COMPLETED');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (2, 2, DATE '2024-03-03', 1028.99, 'CREDIT_CARD', 'COMPLETED');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (3, 3, DATE '2024-03-15', 179.96, 'DEBIT_CARD', 'COMPLETED');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (4, 4, DATE '2024-03-20', 798.0, 'PAYPAL', 'COMPLETED');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (5, 5, DATE '2024-04-02', 1899.5, 'CREDIT_CARD', 'COMPLETED');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (6, 6, DATE '2024-04-05', 149.49, 'COD', 'PENDING');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (7, 7, DATE '2024-04-10', 179.97, 'CREDIT_CARD', 'COMPLETED');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (8, 8, DATE '2024-04-18', 549.0, 'BANK_TRANSFER', 'COMPLETED');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (9, 9, DATE '2024-04-22', 339.97, 'CREDIT_CARD', 'COMPLETED');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (10, 10, DATE '2024-05-01', 69.99, 'DEBIT_CARD', 'COMPLETED');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (11, 12, DATE '2024-05-12', 249.0, 'PAYPAL', 'COMPLETED');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (12, 13, DATE '2024-05-20', 1299.99, 'CREDIT_CARD', 'COMPLETED');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (13, 14, DATE '2024-05-25', 528.99, 'CREDIT_CARD', 'COMPLETED');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (14, 15, DATE '2024-06-02', 179.98, 'DEBIT_CARD', 'COMPLETED');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (15, 16, DATE '2024-06-08', 59.98, 'COD', 'PENDING');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (16, 17, DATE '2024-06-12', 89.5, 'CREDIT_CARD', 'COMPLETED');
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, payment_status) VALUES (17, 18, DATE '2024-06-15', 918.99, 'CREDIT_CARD', 'COMPLETED');

-- 10. REVIEWS
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (1, 1, 1, 5, 'Excellent build quality and battery life.', DATE '2024-03-10');
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (2, 15, 1, 4, 'Smooth and responsive.', DATE '2024-03-10');
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (3, 4, 2, 4, 'Great phone for the price.', DATE '2024-03-08');
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (4, 6, 2, 5, 'Amazing noise cancellation.', DATE '2024-03-09');
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (5, 16, 1, 5, 'Best keyboard I''ve used.', DATE '2024-04-25');
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (6, 11, 1, 3, 'Decent shirt, runs a bit small.', DATE '2024-04-26');
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (7, 5, 4, 4, 'Good value smartphone.', DATE '2024-03-25');
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (8, 2, 4, 5, 'Perfect for gaming on the go.', DATE '2024-04-08');
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (9, 8, 5, 4, 'Non-stick coating works great.', DATE '2024-04-08');
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (10, 9, 5, 3, 'Cutlery is fine but a bit flimsy.', DATE '2024-04-09');
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (11, 13, 2, 5, 'Beautiful dress, true to size.', DATE '2024-04-15');
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (12, 14, 2, 4, 'Lovely handbag, good material.', DATE '2024-04-15');
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (13, 3, 6, 3, 'Adequate for browsing and email.', DATE '2024-04-20');
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (14, 7, 8, 4, 'Works well, easy setup.', DATE '2024-04-24');
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_comment, review_date) VALUES (15, 6, 8, 5, 'Worth every penny.', DATE '2024-04-24');

-- 11. INVENTORY_LOG (one seeded audit record; triggers populate the rest at runtime)
INSERT INTO inventory_log (log_id, product_id, old_quantity, new_quantity, change_qty, change_date, reason) VALUES (1, 17, 80, 17, -63, DATE '2024-02-15', 'Stock correction after audit');

-- Re-sync IDENTITY sequences to MAX(id)+1 since we inserted explicit ids
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE customers MODIFY customer_id GENERATED BY DEFAULT AS IDENTITY (START WITH ' || (SELECT NVL(MAX(customer_id),0)+1 FROM customers) || ')';
  EXECUTE IMMEDIATE 'ALTER TABLE customer_addresses MODIFY address_id GENERATED BY DEFAULT AS IDENTITY (START WITH ' || (SELECT NVL(MAX(address_id),0)+1 FROM customer_addresses) || ')';
  EXECUTE IMMEDIATE 'ALTER TABLE categories MODIFY category_id GENERATED BY DEFAULT AS IDENTITY (START WITH ' || (SELECT NVL(MAX(category_id),0)+1 FROM categories) || ')';
  EXECUTE IMMEDIATE 'ALTER TABLE suppliers MODIFY supplier_id GENERATED BY DEFAULT AS IDENTITY (START WITH ' || (SELECT NVL(MAX(supplier_id),0)+1 FROM suppliers) || ')';
  EXECUTE IMMEDIATE 'ALTER TABLE products MODIFY product_id GENERATED BY DEFAULT AS IDENTITY (START WITH ' || (SELECT NVL(MAX(product_id),0)+1 FROM products) || ')';
  EXECUTE IMMEDIATE 'ALTER TABLE employees MODIFY employee_id GENERATED BY DEFAULT AS IDENTITY (START WITH ' || (SELECT NVL(MAX(employee_id),0)+1 FROM employees) || ')';
  EXECUTE IMMEDIATE 'ALTER TABLE orders MODIFY order_id GENERATED BY DEFAULT AS IDENTITY (START WITH ' || (SELECT NVL(MAX(order_id),0)+1 FROM orders) || ')';
  EXECUTE IMMEDIATE 'ALTER TABLE order_items MODIFY order_item_id GENERATED BY DEFAULT AS IDENTITY (START WITH ' || (SELECT NVL(MAX(order_item_id),0)+1 FROM order_items) || ')';
  EXECUTE IMMEDIATE 'ALTER TABLE payments MODIFY payment_id GENERATED BY DEFAULT AS IDENTITY (START WITH ' || (SELECT NVL(MAX(payment_id),0)+1 FROM payments) || ')';
  EXECUTE IMMEDIATE 'ALTER TABLE reviews MODIFY review_id GENERATED BY DEFAULT AS IDENTITY (START WITH ' || (SELECT NVL(MAX(review_id),0)+1 FROM reviews) || ')';
  EXECUTE IMMEDIATE 'ALTER TABLE inventory_log MODIFY log_id GENERATED BY DEFAULT AS IDENTITY (START WITH ' || (SELECT NVL(MAX(log_id),0)+1 FROM inventory_log) || ')';
END;
/

COMMIT;