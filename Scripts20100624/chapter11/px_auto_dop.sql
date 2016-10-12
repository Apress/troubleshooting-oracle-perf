SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: px_auto_dop.sql
REM Author......: Christian Antognini
REM Date........: June 2010
REM Description.: This script shows how and when the query optimizer 
REM               automatically selects the DOP for a query.
REM Notes.......: This script works as of Oracle Database 11g Release 2 only.
REM               To successfully reproduce the expected behavior system
REM               statistics are deleted.
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

execute dbms_stats.delete_system_stats

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;

CREATE TABLE t
AS
SELECT rownum AS id, rpad('*',100,'*') AS pad
FROM dual
CONNECT BY level <= 1000;

DECLARE
  l_num_rows INTEGER;
  l_blocks INTEGER;
BEGIN
  dbms_stats.gather_table_stats(
    ownname => user, 
    tabname => 't'
  );
  
  SELECT num_rows, blocks
  INTO l_num_rows, l_blocks
  FROM user_tables
  WHERE table_name = 'T';
  
  dbms_stats.set_table_stats(
    ownname => user,
    tabname => 't',
    numrows => l_num_rows*1000,
    numblks => l_blocks*1000
  );
END;
/

PAUSE

REM
REM parallel_degree_policy = manual
REM

ALTER SESSION SET parallel_degree_policy = manual;

PAUSE

ALTER TABLE t NOPARALLEL;
EXPLAIN PLAN FOR SELECT * FROM t;
SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER TABLE t PARALLEL 2;
EXPLAIN PLAN FOR SELECT * FROM t;
SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER TABLE t PARALLEL;
EXPLAIN PLAN FOR SELECT * FROM t;
SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM parallel_degree_policy = limited
REM

ALTER SESSION SET parallel_degree_policy = limited;

PAUSE

ALTER TABLE t NOPARALLEL;
EXPLAIN PLAN FOR SELECT * FROM t;
SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER TABLE t PARALLEL 2;
EXPLAIN PLAN FOR SELECT * FROM t;
SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER TABLE t PARALLEL;
EXPLAIN PLAN FOR SELECT * FROM t;
SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM parallel_degree_policy = auto
REM

ALTER SESSION SET parallel_degree_policy = auto;
ALTER SESSION SET parallel_min_time_threshold = auto;

PAUSE

ALTER TABLE t NOPARALLEL;
EXPLAIN PLAN FOR SELECT * FROM t;
SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER TABLE t PARALLEL 2;
EXPLAIN PLAN FOR SELECT * FROM t;
SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER TABLE t PARALLEL;
EXPLAIN PLAN FOR SELECT * FROM t;
SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Increase parallel_min_time_threshold
REM

ALTER SESSION SET parallel_min_time_threshold = 600;

PAUSE

ALTER TABLE t PARALLEL;
EXPLAIN PLAN FOR SELECT * FROM t;
SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER SESSION SET parallel_min_time_threshold = 30;

PAUSE

ALTER TABLE t PARALLEL;
EXPLAIN PLAN FOR SELECT * FROM t;
SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Increase table size
REM

DECLARE
  l_num_rows INTEGER;
  l_blocks INTEGER;
BEGIN
  SELECT num_rows, blocks
  INTO l_num_rows, l_blocks
  FROM user_tables
  WHERE table_name = 'T';
  
  dbms_stats.set_table_stats(
    ownname => user,
    tabname => 't',
    numrows => l_num_rows*10,
    numblks => l_blocks*10
  );
END;
/

PAUSE

ALTER TABLE t PARALLEL;
EXPLAIN PLAN FOR SELECT * FROM t;
SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Cleanup
REM

DROP TABLE t;
