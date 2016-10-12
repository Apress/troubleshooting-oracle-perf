SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: sharable_cursors_9i.sql
REM Author......: Christian Antognini
REM Date........: March 2009
REM Description.: This script shows examples of parent and child cursors that
REM               cannot be shared.
REM Notes.......: This script was written for 9iR2. As of 10g use the script
REM               sharable_cursors.sql instead.
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

COLUMN sql_text FORMAT A33
COLUMN optimizer_mode FORMAT A14
COLUMN optimizer_mismatch FORMAT A18

COLUMN address NEW_VALUE address

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;

CREATE TABLE t 
AS
SELECT rownum AS n, rpad('*',100,'*') AS pad 
FROM dual
CONNECT BY level <= 1000;

execute dbms_stats.gather_table_stats(ownname=>user, tabname=>'t')

PAUSE

REM
REM The following SQL statements have three different parent cursors. This is
REM because only two of them have the same text.
REM

SELECT * FROM t WHERE n = 1234;

select * from t where n = 1234;

SELECT  *  FROM  t  WHERE  n=1234;

SELECT * FROM t WHERE n = 1234;

SELECT address, hash_value, sql_text, executions
FROM v$sqlarea
WHERE sql_text LIKE '%1234';

PAUSE

REM
REM The following SQL statements have the same parent cursors because the
REM text of the two SQL statements is equal. However, they have two child
REM cursors because the execution environment is not the same.
REM

ALTER SESSION SET optimizer_mode = all_rows;

SELECT count(*) FROM t;

ALTER SESSION SET optimizer_mode = first_rows_10;

SELECT count(*) FROM t;

SELECT address, child_number, sql_text, optimizer_mode, plan_hash_value
FROM v$sql
WHERE sql_text = 'SELECT count(*) FROM t';

PAUSE

COLUMN address CLEAR

SELECT *
FROM v$sql_shared_cursor
WHERE kglhdpar = '&address';

PAUSE

SELECT optimizer_mismatch
FROM v$sql_shared_cursor
WHERE kglhdpar = '&address';

PAUSE

REM
REM Cleanup
REM

UNDEFINE address

DROP TABLE t;
