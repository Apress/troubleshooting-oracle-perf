SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: outline_with_ffs.sql
REM Author......: Christian Antognini
REM Date........: May 2009
REM Description.: This script tests whether a stored outline is able to
REM               overwrite the setting of the initialization parameter
REM               optimizer_features_enable.
REM Notes.......: The initialization parameter optimizer_features_enable is
REM               static up to Oracle9i. For this reason, this script requires  
REM               Oracle Database 10g or newer.
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

CREATE TABLE t AS 
SELECT rownum AS n, rpad('*',4000,'*') AS pad
FROM dual
CONNECT BY level <= 1000;

ALTER TABLE t MODIFY (n NUMBER NOT NULL);

execute dbms_stats.gather_table_stats(user, 't')

CREATE INDEX i ON t(n);

PAUSE

REM
REM Create outline and display its content
REM

CREATE OR REPLACE OUTLINE outline_with_ffs
FOR CATEGORY test 
ON SELECT count(n) from t;

SELECT category, sql_text, signature
FROM user_outlines
WHERE name = 'OUTLINE_WITH_FFS';

SELECT hint 
FROM user_outline_hints 
WHERE name = 'OUTLINE_WITH_FFS';

PAUSE

REM
REM Test outline
REM

ALTER SESSION SET use_stored_outlines = test;

EXPLAIN PLAN FOR
SELECT count(n) FROM t;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Set the initialization parameter optimizer_features_enable
REM to a value that disables index-fast-full scans
REM

ALTER SESSION SET optimizer_features_enable = '8.0.0';

PAUSE

REM
REM Without stored outline no index-fast-full scan is performed
REM

ALTER SESSION SET use_stored_outlines = default;

EXPLAIN PLAN FOR
SELECT count(n) FROM t;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM With stored outline an index-fast-full scan is performed;
REM in other words, the outline overwrites the setting of the
REM initialization parameter optimizer_features_enable
REM

ALTER SESSION SET use_stored_outlines = test;

EXPLAIN PLAN FOR
SELECT count(n) FROM t;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Cleanup
REM

DROP OUTLINE outline_with_ffs;

DROP TABLE t;
PURGE TABLE t;
