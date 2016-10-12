SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: result_cache_query.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows an example of a query that takes advantage
REM               of the server result cache.
REM Notes.......: The sample schema SH and Oracle Database 11g are required.
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
REM Setup test environment
REM

execute dbms_result_cache.flush

ALTER SESSION SET current_schema = SH;

ALTER SESSION SET statistics_level = ALL;

PAUSE

REM
REM Run test queries
REM

REM First execution

SELECT /*+ result_cache */
       p.prod_category, c.country_id,
       sum(s.quantity_sold) AS quantity_sold,
       sum(s.amount_sold) AS amount_sold
FROM sales s, customers c, products p
WHERE s.cust_id = c.cust_id
AND s.prod_id = p.prod_id
GROUP BY p.prod_category, c.country_id
ORDER BY p.prod_category, c.country_id;

SELECT * FROM table(dbms_xplan.display_cursor(NULL, NULL, 'allstats last'));

PAUSE

REM Second execution

SELECT /*+ result_cache */
       p.prod_category, c.country_id,
       sum(s.quantity_sold) AS quantity_sold,
       sum(s.amount_sold) AS amount_sold
FROM sales s, customers c, products p
WHERE s.cust_id = c.cust_id
AND s.prod_id = p.prod_id
GROUP BY p.prod_category, c.country_id
ORDER BY p.prod_category, c.country_id;

SELECT * FROM table(dbms_xplan.display_cursor(NULL, NULL, 'allstats last'));

PAUSE

REM Third execution

SELECT /*+ result_cache */
       p.prod_category, c.country_id,
       sum(s.quantity_sold) AS quantity_sold,
       sum(s.amount_sold) AS amount_sold
FROM sales s, customers c, products p
WHERE s.cust_id = c.cust_id
AND s.prod_id = p.prod_id
GROUP BY p.prod_category, c.country_id
ORDER BY p.prod_category, c.country_id;

SELECT * FROM table(dbms_xplan.display_cursor(NULL, NULL, 'allstats last'));
