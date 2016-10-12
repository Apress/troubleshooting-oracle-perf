SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: star_transformation.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script provides several examples of star transformation.
REM Notes.......: The sample schema SH is required.
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM
REM ***************************************************************************

SET TERMOUT ON
SET FEEDBACK OFF
SET VERIFY OFF
SET SCAN ON

@../connect.sql

SET ECHO ON

REM
REM This script requires the sample schema SH
REM

ALTER SESSION SET current_schema = SH;

PAUSE

REM
REM No temporary tables
REM

ALTER SESSION SET star_transformation_enabled = temp_disable;

EXPLAIN PLAN FOR
SELECT /*+ star_transformation */ c.cust_state_province, t.fiscal_month_name, sum(s.amount_sold) AS amount_sold
FROM sales s, customers c, times t, products p
WHERE s.cust_id = c.cust_id
AND s.time_id = t.time_id
AND s.prod_id = p.prod_id
AND c.cust_year_of_birth BETWEEN 1970 AND 1979
AND p.prod_subcategory = 'Cameras'
GROUP BY c.cust_state_province, t.fiscal_month_name
ORDER BY c.cust_state_province, sum(s.amount_sold) DESC;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM With temporary tables
REM

ALTER SESSION SET star_transformation_enabled = TRUE;

EXPLAIN PLAN FOR
SELECT /*+ star_transformation */ c.cust_state_province, t.fiscal_month_name, sum(s.amount_sold) AS amount_sold
FROM sales s, customers c, times t, products p
WHERE s.cust_id = c.cust_id
AND s.time_id = t.time_id
AND s.prod_id = p.prod_id
AND c.cust_year_of_birth BETWEEN 1970 AND 1979
AND p.prod_subcategory = 'Cameras'
GROUP BY c.cust_state_province, t.fiscal_month_name
ORDER BY c.cust_state_province, sum(s.amount_sold) DESC;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM With bitmap-join indexes
REM

ALTER TABLE customers MODIFY CONSTRAINT customers_pk VALIDATE;

CREATE BITMAP INDEX sales_cust_year_of_birth_bix ON sales (c.cust_year_of_birth)
FROM sales s, customers c
WHERE s.cust_id = c.cust_id
LOCAL;

ALTER TABLE products MODIFY CONSTRAINT products_pk VALIDATE;

CREATE BITMAP INDEX sales_prod_subcategory_bix ON sales (p.prod_subcategory)
FROM sales s, products p
WHERE s.prod_id = p.prod_id
LOCAL;

PAUSE

EXPLAIN PLAN FOR
SELECT /*+ star_transformation index(s sales_cust_year_of_birth_bix) index(s sales_prod_subcategory_bix) */ 
       c.cust_state_province, t.fiscal_month_name, sum(s.amount_sold) AS amount_sold
FROM sales s, customers c, times t, products p
WHERE s.cust_id = c.cust_id
AND s.time_id = t.time_id
AND s.prod_id = p.prod_id
AND c.cust_year_of_birth BETWEEN 1970 AND 1979
AND p.prod_subcategory = 'Cameras'
GROUP BY c.cust_state_province, t.fiscal_month_name
ORDER BY c.cust_state_province, sum(s.amount_sold) DESC;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Cleanup
REM

DROP INDEX sales_cust_year_of_birth_bix;
DROP INDEX sales_prod_subcategory_bix;
