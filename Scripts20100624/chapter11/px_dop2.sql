SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: px_dop2.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows that hints do not force the query optimizer
REM               to use parallel processing. They simply override the default
REM               degree of parallelism.
REM Notes.......: This script reproduces the expected behavior as of Oracle
REM               Database 10g only.
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

COLUMN statement_id FORMAT A13
COLUMN cost FORMAT 9999

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;

CREATE TABLE t
AS
SELECT rownum AS id, rpad('*',100,'*') AS pad
FROM dual
CONNECT BY level <= 100000;

CREATE INDEX i ON t (id);

execute dbms_stats.gather_table_stats(ownname => user, tabname => 't')

DELETE plan_table;

PAUSE

REM
REM Display the cost of a full table scan with different DOPs
REM

EXPLAIN PLAN SET STATEMENT_ID 'dop1' FOR
SELECT /*+ full(t) parallel(t 1) */ * FROM t WHERE id > 90000; 

EXPLAIN PLAN SET STATEMENT_ID 'dop2' FOR
SELECT /*+ full(t) parallel(t 2) */ * FROM t WHERE id > 90000; 

EXPLAIN PLAN SET STATEMENT_ID 'dop3' FOR
SELECT /*+ full(t) parallel(t 3) */ * FROM t WHERE id > 90000; 

EXPLAIN PLAN SET STATEMENT_ID 'dop4' FOR
SELECT /*+ full(t) parallel(t 4) */ * FROM t WHERE id > 90000; 

SELECT statement_id, cost
FROM plan_table
WHERE id = 0
ORDER BY statement_id;

PAUSE

REM
REM The query optimizer should choose between an index scan and
REM a full table scan depending on the DOP
REM

REM This one should use a serial index scan

EXPLAIN PLAN SET STATEMENT_ID 'dop1' FOR SELECT * FROM t WHERE id > 90000; 
SELECT * FROM table(dbms_xplan.display);

PAUSE

REM This one should use a serial index scan

EXPLAIN PLAN SET STATEMENT_ID 'dop1' FOR SELECT /*+ parallel(t 2) */ * FROM t WHERE id > 90000; 
SELECT * FROM table(dbms_xplan.display);

PAUSE

REM This one should use a parallel full table scan

EXPLAIN PLAN SET STATEMENT_ID 'dop1' FOR SELECT /*+ parallel(t 3) */ * FROM t WHERE id > 90000; 
SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Cleanup
REM

DROP TABLE t;
