SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: outline_with_star.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script tests whether a stored outline is able to
REM               overwrite the setting of the initialization parameter
REM               star_transformation_enabled.
REM Notes.......: This script requires the sample schema SH.
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

COLUMN category FORMAT A8
COLUMN sql_text FORMAT A22
COLUMN timestamp FORMAT A32

@../connect.sql

SET ECHO ON

REM
REM Setup test environment
REM

DROP OUTLINE outline_with_star;

ALTER SESSION SET current_schema = SH;
ALTER SESSION SET star_transformation_enabled = temp_disable;
ALTER SESSION SET "_always_star_transformation" = TRUE;

PAUSE

REM
REM Display execution plan of test query
REM

EXPLAIN PLAN FOR
SELECT c.cust_state_province, t.fiscal_month_name, sum(s.amount_sold) AS amount_sold
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
REM Create outline and display its content
REM

CREATE OR REPLACE OUTLINE outline_with_star
FOR CATEGORY test 
ON SELECT c.cust_state_province, t.fiscal_month_name, sum(s.amount_sold) AS amount_sold
FROM sales s, customers c, times t, products p
WHERE s.cust_id = c.cust_id
AND s.time_id = t.time_id
AND s.prod_id = p.prod_id
AND c.cust_year_of_birth BETWEEN 1970 AND 1979
AND p.prod_subcategory = 'Cameras'
GROUP BY c.cust_state_province, t.fiscal_month_name
ORDER BY c.cust_state_province, sum(s.amount_sold) DESC;

SELECT category, sql_text, signature
FROM dba_outlines
WHERE name = 'OUTLINE_WITH_STAR';

SELECT hint 
FROM dba_outline_hints 
WHERE name = 'OUTLINE_WITH_STAR';

PAUSE

REM
REM Test outline
REM

ALTER SESSION SET use_stored_outlines = test;

EXPLAIN PLAN FOR
SELECT c.cust_state_province, t.fiscal_month_name, sum(s.amount_sold) AS amount_sold
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

ALTER SESSION SET star_transformation_enabled = false;

EXPLAIN PLAN FOR
SELECT c.cust_state_province, t.fiscal_month_name, sum(s.amount_sold) AS amount_sold
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

ALTER SESSION SET use_stored_outlines = default;

EXPLAIN PLAN FOR
SELECT c.cust_state_province, t.fiscal_month_name, sum(s.amount_sold) AS amount_sold
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

DROP OUTLINE outline_with_star;
