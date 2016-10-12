SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: optimizer_index_caching.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows the working and drawbacks of the
REM               initialization parameter optimizer_index_caching.
REM Notes.......: -
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

DROP TABLE t;

CREATE TABLE t (id, col1, col2)
PCTFREE 80 PCTUSED 20
AS 
SELECT rownum, mod(floor(rownum/2),1000), rpad('-',50,'-')
FROM dual
CONNECT BY level <= 10000;

CREATE INDEX i1 ON t (col1);

BEGIN
 dbms_stats.gather_table_stats(
   ownname=>user, 
   tabname=>'T',
   cascade=>TRUE);
END;
/

REM set parameters to let the demo work on different releases

ALTER SESSION SET "_optimizer_cost_model" = IO;

PAUSE

REM
REM test an index range scan with OPTIMIZER_INDEX_CACHING=0
REM

ALTER SESSION SET OPTIMIZER_INDEX_CACHING=0;

EXPLAIN PLAN FOR 
SELECT * FROM t WHERE col1 = 11;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM test an index range scan with OPTIMIZER_INDEX_CACHING=100
REM

ALTER SESSION SET OPTIMIZER_INDEX_CACHING=100;

EXPLAIN PLAN FOR 
SELECT * FROM t WHERE col1 = 11;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM test a NL join with OPTIMIZER_INDEX_CACHING=0
REM

ALTER SESSION SET OPTIMIZER_INDEX_CACHING=0;

EXPLAIN PLAN FOR 
SELECT /*+ use_nl(t1 t2) */ * FROM t t1, t t2 WHERE t1.id = t2.col1;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM test a NL join with OPTIMIZER_INDEX_CACHING=100
REM

ALTER SESSION SET OPTIMIZER_INDEX_CACHING=100;

EXPLAIN PLAN FOR
SELECT /*+ use_nl(t1 t2) */ * FROM t t1, t t2 WHERE t1.id = t2.col1;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM test an indexed inlist iterator with OPTIMIZER_INDEX_CACHING=0
REM

ALTER SESSION SET OPTIMIZER_INDEX_CACHING=0;

EXPLAIN PLAN FOR 
SELECT /*+ index(t) */ * FROM t WHERE col1 IN (1,2,3,4,5,6,7,8,9,10);

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM test an indexed inlist iterator with OPTIMIZER_INDEX_CACHING=100
REM

ALTER SESSION SET OPTIMIZER_INDEX_CACHING=100;

EXPLAIN PLAN FOR 
SELECT /*+ index(t) */ * FROM t WHERE col1 IN (1,2,3,4,5,6,7,8,9,10);

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM cleanup
REM

DROP TABLE t;
PURGE TABLE t;
