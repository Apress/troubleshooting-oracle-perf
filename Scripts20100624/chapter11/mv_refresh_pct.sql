SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: mv_refresh_pct.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows how fast refreshes based on partition 
REM               change tracking work.
REM Notes.......: The sample schema SH is required. The script only works as of
REM               Oracle Database 10g Release 2.
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

COLUMN capability_name FORMAT A29
COLUMN possible FORMAT A8
COLUMN related_text FORMAT A12
COLUMN msgtxt FORMAT A31
COLUMN related_text FORMAT A13

@../connect.sql

SET ECHO ON

REM
REM Setup test environment
REM

CREATE SYNONYM mv_capabilities_table FOR sh.mv_capabilities_table;

ALTER SESSION SET current_schema = SH;

CREATE TABLE mv_capabilities_table (
  statement_id         VARCHAR(30),
  mvowner              VARCHAR(30),
  mvname               VARCHAR(30),
  capability_name      VARCHAR(30),
  possible             CHARACTER(1),
  related_text         VARCHAR(2000),
  related_num          NUMBER,
  msgno                INTEGER,
  msgtxt               VARCHAR(2000),
  seq                  NUMBER
);

GRANT ALL ON mv_capabilities_table TO public;

DROP MATERIALIZED VIEW sales_mv;

DROP MATERIALIZED VIEW LOG ON sales;
DROP MATERIALIZED VIEW LOG ON customers;
DROP MATERIALIZED VIEW LOG ON products;

PAUSE

REM
REM Create materialized views and materialized view logs
REM

CREATE MATERIALIZED VIEW LOG ON sales WITH ROWID, SEQUENCE
(cust_id, prod_id, quantity_sold, amount_sold) INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON customers WITH ROWID, SEQUENCE
(cust_id, country_id) INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON products WITH ROWID, SEQUENCE
(prod_id, prod_category) INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW sales_mv
REFRESH FORCE ON DEMAND
AS
SELECT p.prod_category, c.country_id,
       sum(quantity_sold) AS quantity_sold,
       sum(amount_sold) AS amount_sold,
       count(*) AS count_star,
       count(quantity_sold) AS count_quantity_sold,
       count(amount_sold) AS count_amount_sold
FROM sales s, customers c, products p
WHERE s.cust_id = c.cust_id
AND s.prod_id = p.prod_id
GROUP BY p.prod_category, c.country_id;

PAUSE

REM
REM Display refresh capabilities (notice that fast refresh is "available")
REM

DELETE mv_capabilities_table 
WHERE statement_id = '42';

execute dbms_mview.explain_mview(mv => 'sales_mv', stmt_id => '42')

SELECT capability_name, possible, msgtxt, related_text
FROM mv_capabilities_table
WHERE statement_id = '42'
AND capability_name LIKE 'REFRESH_FAST_AFTER%'
ORDER BY seq;

PAUSE

REM
REM Show that fast refresh is not possible after a modification
REM of the partititions
REM

ALTER TABLE sales ADD PARTITION SALES_q1_2004 
VALUES LESS THAN (to_date('01.04.2004','DD.MM.YYYY'));

ALTER TABLE sales DROP PARTITION SALES_q1_2004;

execute dbms_mview.refresh(list => 'sh.sales_mv', method => 'f')

PAUSE

REM
REM Display refresh capabilities related to PCT refresh
REM

SELECT capability_name, possible, msgtxt, related_text
FROM mv_capabilities_table
WHERE statement_id = '42'
AND capability_name IN ('PCT_TABLE','REFRESH_FAST_PCT')
ORDER BY seq;

PAUSE

REM
REM Recreate materialized view to support PCT refresh
REM

DROP MATERIALIZED VIEW sales_mv;

CREATE MATERIALIZED VIEW sales_mv
REFRESH FORCE ON DEMAND
AS
SELECT p.prod_category, c.country_id,
       sum(quantity_sold) AS quantity_sold,
       sum(amount_sold) AS amount_sold,
       count(*) AS count_star,
       count(quantity_sold) AS count_quantity_sold,
       count(amount_sold) AS count_amount_sold,
       dbms_mview.pmarker(s.rowid) AS pmarker
FROM sales s, customers c, products p
WHERE s.cust_id = c.cust_id
AND s.prod_id = p.prod_id
GROUP BY p.prod_category, c.country_id, dbms_mview.pmarker(s.rowid);

PAUSE

REM
REM Test PCT refresh
REM

ALTER TABLE sales ADD PARTITION SALES_q1_2004 
VALUES LESS THAN (to_date('01.04.2004','DD.MM.YYYY'));

ALTER TABLE sales DROP PARTITION SALES_q1_2004;

execute dbms_mview.refresh(list => 'sh.sales_mv', method => 'f')

PAUSE

REM
REM Cleanup
REM

DROP MATERIALIZED VIEW sales_mv;

DROP MATERIALIZED VIEW LOG ON sales;
DROP MATERIALIZED VIEW LOG ON customers;
DROP MATERIALIZED VIEW LOG ON products;

DROP TABLE mv_capabilities_table;

@../connect.sql

DROP SYNONYM mv_capabilities_table;
