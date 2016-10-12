SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: join_elimination.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script provides an example of join elimination.
REM Notes.......: At least Oracle Database 10g Release 2 is required to run
REM               this script.
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

DROP VIEW v;

CREATE VIEW v AS
SELECT t1.id AS t1_id, t1.n AS t1_n, t2.id AS t2_id, t2.n AS t2_n
FROM t1, t2
WHERE t1.id = t2.t1_id;

PAUSE

REM
REM Run test
REM

EXPLAIN PLAN FOR SELECT * FROM v;

SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER TABLE t2 ENABLE CONSTRAINT t2_t1_fk;

EXPLAIN PLAN FOR SELECT t2_id, t2_n FROM v;

SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER TABLE t2 DISABLE CONSTRAINT t2_t1_fk;

EXPLAIN PLAN FOR SELECT t2_id, t2_n FROM v;

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
DROP VIEW v;
