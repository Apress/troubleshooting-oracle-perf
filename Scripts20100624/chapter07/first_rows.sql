SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: first_rows.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows how it is possible to switch the optimizer
REM               mode from all_rows to first_rows with a SQL profile.
REM Notes.......: This script requires Oracle Database 10g. The Oracle Database
REM               11g SQL tuning advisor does not propose a SQL profile.
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
SET LONG 1000000
SET PAGESIZE 100
SET LINESIZE 100

COLUMN report FORMAT A100
COLUMN executions FORMAT 999999999
COLUMN fetches FORMAT 999999999
COLUMN plan_table_output FORMAT A100

@../connect.sql

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t PURGE;

BEGIN
  dbms_sqltune.drop_sql_profile(name=>'first_rows');
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE t (id, pad, CONSTRAINT t_pk PRIMARY KEY (id)) AS
SELECT rownum, lpad('*',100,'*')
FROM dual
CONNECT BY level <= 10000
ORDER BY mod(rownum,23);

BEGIN
  dbms_stats.gather_table_stats(
    ownname => user,
    tabname => 'T',
    estimate_percent => 100,
    method_opt => 'FOR ALL COLUMNS SIZE 1',
    cascade => TRUE
  );
END;
/

PAUSE

REM
REM Compare execution plan between ALL_ROWS and FIRST_ROWS_10
REM

EXPLAIN PLAN FOR
SELECT /*+ all_rows */ * FROM t ORDER BY id;

SELECT * FROM table(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT /*+ first_rows(10) */ * FROM t ORDER BY id;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Set optimizer mode
REM

ALTER SESSION SET optimizer_mode = all_rows;

PAUSE

REM
REM Execute the test statement 10 times, each time fetch only few rows
REM

DECLARE
  CURSOR c IS SELECT * FROM t ORDER BY id;
  l t%ROWTYPE;
BEGIN
  FOR j IN 1..10 LOOP
    OPEN c;
    FOR i IN 1..j LOOP
      FETCH c INTO l;
    END LOOP;
    CLOSE c;
  END LOOP;
END;
/

PAUSE

REM
REM Let tune it...
REM

COLUMN sql_id NEW_VALUE g_sql_id

SELECT sql_id, executions, fetches, end_of_fetch_count 
FROM v$sql 
WHERE sql_text = 'SELECT * FROM T ORDER BY ID';

VARIABLE g_task_name VARCHAR2(30)

BEGIN
  :g_task_name := dbms_sqltune.create_tuning_task(
                    sql_id => '&g_sql_id',
                    scope => 'COMPREHENSIVE',
                    time_limit => 42
                  );
  dbms_sqltune.execute_tuning_task(:g_task_name);
END;
/

PAUSE

SELECT dbms_sqltune.report_tuning_task(:g_task_name) report FROM dual;

PAUSE

VARIABLE g_sql_profile VARCHAR2(30)

BEGIN
  :g_sql_profile := dbms_sqltune.accept_sql_profile(
                      task_name => :g_task_name, 
                      name => 'first_rows',
                      category => 'TEST'
                    );
   /* The following call works as of 10.2 only
   dbms_sqltune.accept_sql_profile(
     task_name => :g_task_name, 
     name => 'first_rows',
     category => 'TEST',
     force_match => TRUE,
     replace => TRUE
   );
   */
END;
/

PAUSE

REM
REM Display SQL profile hints
REM

SELECT attr_val
FROM sys.sqlprof$ p, sys.sqlprof$attr a
WHERE p.sp_name = 'first_rows'
AND p.signature = a.signature
AND p.category = a.category;

PAUSE

REM
REM Test the SQL profile
REM

ALTER SESSION SET sqltune_category = DEFAULT;

EXPLAIN PLAN FOR
SELECT * FROM t ORDER BY id;

SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER SESSION SET sqltune_category = TEST;

EXPLAIN PLAN FOR
SELECT * FROM t ORDER BY id;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Cleanup
REM

BEGIN
  dbms_sqltune.drop_tuning_task(:g_task_name);
  dbms_sqltune.drop_sql_profile(name=>'first_rows');
END;
/

DROP TABLE t PURGE;
