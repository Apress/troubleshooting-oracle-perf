SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: sharable_cursors.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows examples of parent and child cursors that
REM               cannot be shared.
REM Notes.......: This script works as of 10g only. The 9i version is named
REM               sharable_cursors_9i.sql.
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM 08.03.2009 Added note about sharable_cursors_9i.sql + Fixed comment
REM 24.06.2010 Added SET SERVEROUTPUT OFF in the initialization part
REM ***************************************************************************

SET TERMOUT ON
SET FEEDBACK OFF
SET VERIFY OFF
SET SCAN ON
SET SERVEROUTPUT OFF

@../connect.sql

COLUMN sql_text FORMAT A33
COLUMN optimizer_mode FORMAT A14
COLUMN optimizer_mode_mismatch FORMAT A23
COLUMN optimizer_mismatch FORMAT A18

COLUMN sql_id NEW_VALUE sql_id

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

SELECT sql_id, sql_text, executions
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

SELECT sql_id, child_number, sql_text, optimizer_mode, plan_hash_value
FROM v$sql
WHERE sql_id = (SELECT prev_sql_id
                FROM v$session
                WHERE sid = sys_context('userenv','sid'));

PAUSE

SELECT *
FROM v$sql_shared_cursor
WHERE sql_id = '&sql_id';

PAUSE

REM this query works as of 10.2 only

SELECT child_number, optimizer_mode_mismatch
FROM v$sql_shared_cursor
WHERE sql_id = '&sql_id';

REM this query works in 10.1 only

SELECT child_number, optimizer_mismatch
FROM v$sql_shared_cursor
WHERE sql_id = '&sql_id';

PAUSE

REM
REM Cleanup
REM

UNDEFINE sql_id

DROP TABLE t;
PURGE TABLE t;
