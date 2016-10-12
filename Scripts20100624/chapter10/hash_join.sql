SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: hash_join.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script provides several examples of hash joins.
REM Notes.......: At least Oracle Database 10g is required to run this script.
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM 24.06.2010 Fixed typo in description
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

@@create_tx.sql

PAUSE

REM
REM 2-table joins
REM

DROP INDEX t1_n;

EXPLAIN PLAN FOR
SELECT /*+ leading(t1) use_hash(t2) */ *
FROM t1, t2
WHERE t1.id = t2.t1_id
AND t1.n = 19;

SELECT * FROM table(dbms_xplan.display);

PAUSE

CREATE INDEX t1_n ON t1 (n);

EXPLAIN PLAN FOR
SELECT /*+ leading(t1) use_hash(t2) */ *
FROM t1, t2
WHERE t1.id = t2.t1_id
AND t1.n = 19;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM 4-table joins
REM

DROP INDEX t1_n;

EXPLAIN PLAN FOR
SELECT /*+ leading(t1 t2 t3) use_hash(t2 t3 t4) */ t1.*, t2.*, t3.*, t4.*
FROM t1, t2, t3, t4
WHERE t1.id = t2.t1_id 
AND t2.id = t3.t2_id 
AND t3.id = t4.t3_id 
AND t1.n = 19;

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT /*+ leading(t3 t4 t2) use_hash(t1 t2 t4) */ t1.*, t2.*, t3.*, t4.*
FROM t1, t2, t3, t4
WHERE t1.id = t2.t1_id 
AND t2.id = t3.t2_id 
AND t3.id = t4.t3_id 
AND t1.n = 19;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM index joins
REM

CREATE INDEX t4_n ON t4 (n);

EXPLAIN PLAN FOR
SELECT /*+ index_join(t4 t4_n t4_pk) */ id, n
FROM t4 
WHERE id BETWEEN 10 AND 20 
AND n < 100;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Cleanup
REM

DROP TABLE t4;
PURGE TABLE t4;
DROP TABLE t3;
PURGE TABLE t3;
DROP TABLE t2;
PURGE TABLE t2;
DROP TABLE t1;
PURGE TABLE t1;
