SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: outline_with_rewrite.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script tests whether a stored outline is able to
REM               overwrite the setting of the initialization parameter
REM               query_rewrite_enabled.
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

COLUMN category FORMAT A8
COLUMN sql_text FORMAT A22
COLUMN timestamp FORMAT A32

@../connect.sql

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;

DROP MATERIALIZED VIEW mv;

CREATE TABLE t AS 
SELECT rownum AS n, rpad('*',100,'*') AS pad
FROM dual
CONNECT BY level <= 1000;

exec dbms_stats.gather_table_stats(user, 't')

CREATE MATERIALIZED VIEW mv
ENABLE QUERY REWRITE
AS
SELECT count(*) FROM t;

exec dbms_stats.gather_table_stats(user, 'mv')

PAUSE

REM
REM Create outline and display its content
REM

ALTER SESSION SET query_rewrite_enabled = TRUE;

CREATE OR REPLACE OUTLINE outline_with_rewrite
FOR CATEGORY test 
ON SELECT count(*) from t;

SELECT category, sql_text, signature
FROM user_outlines
WHERE name = 'OUTLINE_WITH_REWRITE';

SELECT hint 
FROM user_outline_hints 
WHERE name = 'OUTLINE_WITH_REWRITE';

PAUSE

ALTER SESSION SET use_stored_outlines = test;

EXPLAIN PLAN FOR
SELECT count(*) FROM t;

SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER SESSION SET query_rewrite_enabled = FALSE;

EXPLAIN PLAN FOR
SELECT count(*) FROM t;

SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER SESSION SET use_stored_outlines = default;

EXPLAIN PLAN FOR
SELECT count(*) FROM t;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Cleanup
REM

DROP OUTLINE outline_with_rewrite;

DROP TABLE t;
PURGE TABLE t;
