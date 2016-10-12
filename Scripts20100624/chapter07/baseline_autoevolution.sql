SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: baseline_autoevolution.sql
REM Author......: Christian Antognini
REM Date........: March 2009
REM Description.: This script shows that the SQL tuning advisor can 
REM               automatically evolve a SQL plan baseline
REM Notes.......: This script requires Oracle Database 11g.
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
SET LONG 100000 
SET PAGESIZE 100
SET LINESIZE 100

COLUMN plan_table_output FORMAT A80
COLUMN sql_text FORMAT A45
COLUMN sql_handle FORMAT A25

@../connect.sql

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t PURGE;

CREATE TABLE t (id, n, pad, CONSTRAINT t_pk PRIMARY KEY (id))
AS 
WITH
  t1000 AS (SELECT 1
            FROM dual
            CONNECT BY level <= 1000)
SELECT rownum, mod(rownum,12345), rpad('*',500,'*')
FROM t1000, t1000;

BEGIN
  dbms_stats.gather_table_stats(
    ownname => user, 
    tabname => 't', 
    estimate_percent => dbms_stats.auto_sample_size, 
    method_opt => 'for all columns size 254',
    cascade => TRUE
  );
END;
/

PAUSE

REM
REM Create a baseline (the query is executed twice because 
REM the first time it is not added to the baseline)
REM

ALTER SESSION SET optimizer_capture_sql_plan_baselines = TRUE;

SELECT count(pad) FROM t WHERE n = 42;

SELECT count(pad) FROM t WHERE n = 42;

ALTER SESSION SET optimizer_capture_sql_plan_baselines = FALSE;

PAUSE

SELECT sql_handle, sql_text, enabled, accepted FROM dba_sql_plan_baselines;

PAUSE

REM
REM Display the execution plan stored in the baseline
REM

EXPLAIN PLAN FOR SELECT count(pad) FROM t WHERE n = 42;

SELECT * FROM table(dbms_xplan.display(NULL, NULL, 'basic'));

PAUSE

REM
REM Create an index to avoid the full table scan
REM

CREATE INDEX i ON t (n);

PAUSE

REM
REM The index is not used because the baseline is used
REM

EXPLAIN PLAN FOR SELECT count(pad) FROM t WHERE n = 42;

SELECT * FROM table(dbms_xplan.display(NULL, NULL, 'basic note'));

PAUSE

REM
REM Execute the query... then the query optimizer notice that
REM another execution plan could be used to process the query
REM

SELECT count(pad) FROM t WHERE n = 42;

PAUSE

REM
REM The new execution plan is added to the baseline but not accepted
REM

SELECT sql_handle, sql_text, enabled, accepted FROM dba_sql_plan_baselines;

PAUSE

REM
REM Execute the query many times (this is necessary to make sure that it will 
REM be considered by the SQL Tuning Advisor) and then create a snapshot
REM

DECLARE
  l_count PLS_INTEGER;
BEGIN
  FOR i IN 1..25
  LOOP
    SELECT count(pad) INTO l_count
    FROM t
    WHERE n = 42;
  END LOOP;
  dbms_workload_repository.create_snapshot;
END;
/

PAUSE

REM
REM Manually start the SQL Tuning Advisor
REM

REM As SYS run the following PL/SQL block

REM DECLARE
REM   l_args dbms_advisor.argList;
REM BEGIN
REM   l_args := dbms_advisor.argList('ACCEPT_SQL_PROFILES', 'TRUE');
REM   dbms_sqltune.execute_tuning_task(
REM     task_name        => 'SYS_AUTO_SQL_TUNING_TASK',
REM     execution_params => l_args
REM   );
REM END;
REM /

PAUSE

REM
REM Both execution plans are now accepted
REM

SELECT sql_handle, sql_text, enabled, accepted FROM dba_sql_plan_baselines;

PAUSE

EXPLAIN PLAN FOR SELECT count(pad) FROM t WHERE n = 42;

SELECT * FROM table(dbms_xplan.display(NULL, NULL, 'basic note'));

PAUSE

REM
REM Cleanup
REM

REM Remove the baseline and the SQL profile

DECLARE
  ret PLS_INTEGER;
BEGIN
  FOR c IN (SELECT DISTINCT sql_handle 
            FROM dba_sql_plan_baselines 
            WHERE creator = user
            AND created > systimestamp - to_dsinterval('0 00:15:00'))
  LOOP
    ret := dbms_spm.drop_sql_plan_baseline(c.sql_handle);
  END LOOP;
  FOR c IN (SELECT name
            FROM dba_sql_profiles
            WHERE created > systimestamp - to_dsinterval('0 00:15:00'))
  LOOP
    dbms_sqltune.drop_sql_profile(c.name);
  END LOOP;
END;
/

DROP TABLE t PURGE;
