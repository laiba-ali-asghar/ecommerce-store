# E-Commerce Database Project (Oracle SQL & PL/SQL)

## Run order
1. 01_schema_ddl.sql          - creates all 11 tables (PKs, FKs, constraints)
2. 02_sample_data.sql         - loads sample data
3. 03_complex_queries.sql     - 15 analytical queries (joins, subqueries, window functions, CONNECT BY, CTE, PIVOT)
4. 04_plsql_programs.sql      - functions, procedure, triggers, package
5. 05_performance_tuning.sql  - indexes, partitioning, materialized view, execution plan examples

## Requirements
Oracle Database 12c Release 1 or later (IDENTITY columns, FETCH FIRST clause).
Tested syntax against Oracle 19c/21c/23ai. Run via Oracle SQL Developer, SQL*Plus,
or the free sandbox at https://livesql.oracle.com if you don't have a local Oracle instance.

## Files
- ecommerce_erd.png - Entity-Relationship Diagram

See the accompanying Word report (Ecommerce_Oracle_Project_Report.docx) for full
documentation: schema design rationale, normalization decisions, query walkthroughs
with sample output, and explanations of every PL/SQL and performance-tuning component.
