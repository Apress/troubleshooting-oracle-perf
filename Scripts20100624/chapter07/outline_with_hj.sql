SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: outline_with_hj.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script tests whether a stored outline is able to overwrite
REM               the setting of the initialization parameter hash_join_enabled.
REM Notes.......: -
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM 24.06.2010 Script compatible with 10g/11g (set "_hash_join_enabled")
REM ***************************************************************************

SET TERMOUT ON
SET FEEDBACK OFF
SET VERIFY OFF
SET SCAN ON

COLUMN category FORMAT A8
COLUMN sql_text FORMAT A49
COLUMN timestamp FORMAT A32

@../connect.sql

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;

CREATE TABLE t AS 
SELECT rownum AS n, rpad('*',100,'*') AS pad
FROM dual
CONNECT BY level <= 1000;

execute dbms_stats.gather_table_stats(user, 't')

PAUSE

REM
REM Create outline and display its content
REM

ALTER /* for 9i */ SESSION SET hash_join_enabled = TRUE;
ALTER /* for 10g/11g */ SESSION SET "_hash_join_enabled" = TRUE;

CREATE OR REPLACE OUTLINE outline_with_hj
FOR CATEGORY test 
ON SELECT count(*) FROM t t1, t t2 WHERE t1.n = t2.n;

SELECT category, sql_text, signature
FROM user_outlines
WHERE name = 'OUTLINE_WITH_HJ';

SELECT hint 
FROM user_outline_hints 
WHERE name = 'OUTLINE_WITH_HJ';

PAUSE

REM
REM Test outline
REM

ALTER SESSION SET use_stored_outlines = test;

EXPLAIN PLAN FOR
SELECT count(*) FROM t t1, t t2 WHERE t1.n = t2.n;

SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER /* for 9i */ SESSION SET hash_join_enabled = FALSE;
ALTER /* for 10g/11g */ SESSION SET "_hash_join_enabled" = FALSE;

EXPLAIN PLAN FOR
SELECT count(*) FROM t t1, t t2 WHERE t1.n = t2.n;

SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER SESSION SET use_stored_outlines = default;

EXPLAIN PLAN FOR
SELECT count(*) FROM t t1, t t2 WHERE t1.n = t2.n;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Cleanup
REM

DROP OUTLINE outline_with_hj;

DROP TABLE t;
PURGE TABLE t;
