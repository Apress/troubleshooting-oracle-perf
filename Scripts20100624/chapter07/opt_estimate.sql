SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: opt_estimate.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows how it is possible to enhance the 
REM               cardinality estimations performed by the query optimizer with
REM               a SQL profile.
REM Notes.......: This script requires Oracle Database 10g or never.
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM 24.06.2010 Uncommented 11g query
REM ***************************************************************************

SET TERMOUT ON
SET FEEDBACK OFF
SET VERIFY OFF
SET SCAN ON
SET LONG 1000000
SET PAGESIZE 100
SET LINESIZE 150

COLUMN report FORMAT A100

@../connect.sql

SET ECHO ON

REM
REM Setup test environment
REM

REM @@ch.sql

DROP TABLE t PURGE;

CREATE TABLE t (rid, dummy, CONSTRAINT t_pk PRIMARY KEY (rid)) AS 
SELECT rowid rid, 0
FROM ch 
WHERE language = 'R';

BEGIN
  dbms_stats.gather_table_stats(
    ownname => user,
    tabname => 'T',
    estimate_percent => 1,
    method_opt => 'FOR ALL COLUMNS SIZE 1',
    cascade => TRUE
  );
END;
/

PAUSE

REM
REM Show that the query optimizer does a wrong estimations...
REM

EXPLAIN PLAN FOR
SELECT DISTINCT ch.dummy, t.dummy
FROM ch, t
WHERE language = 'R' AND state = 'GR'
AND ch.rowid = t.rid;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM let tune it...
REM

VARIABLE g_task_name VARCHAR2(30)
BEGIN
  :g_task_name := dbms_sqltune.create_tuning_task(
                    sql_text => q'[SELECT DISTINCT ch.dummy, t.dummy FROM ch, t WHERE language = 'R' AND state = 'GR' AND ch.rowid = t.rid]',
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
                      name => 'opt_estimate',
                      category => 'TEST'
                    );
   /* The following call works as of 10.2 only
   dbms_sqltune.accept_sql_profile(
     task_name => :g_task_name, 
     name => 'opt_estimate',
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

REM The following query doesn't work in 11g

SELECT attr_val
FROM sys.sqlprof$ p, sys.sqlprof$attr a
WHERE p.sp_name = 'opt_estimate'
AND p.signature = a.signature
AND p.category = a.category;

REM In 11g the following query can be used to have the same information

SELECT extractValue(value(h),'.') AS hint
FROM sys.sqlobj$data od, sys.sqlobj$ so,
table(xmlsequence(extract(xmltype(od.comp_data),'/outline_data/hint'))) h
WHERE so.name = 'opt_estimate'
AND so.signature = od.signature
AND so.category = od.category
AND so.obj_type = od.obj_type
AND so.plan_id = od.plan_id;

PAUSE

REM
REM Test the SQL profile
REM

ALTER SESSION SET statistics_level = ALL;

ALTER SESSION SET sqltune_category = DEFAULT;

SET TERMOUT OFF

SELECT DISTINCT ch.dummy, t.dummy
FROM ch, t
WHERE language = 'R' AND state = 'GR'
AND ch.rowid = t.rid;

SET TERMOUT ON

SELECT * FROM table(dbms_xplan.display_cursor(null,null,'runstats_last'));

PAUSE

ALTER SESSION SET sqltune_category = TEST;

SET TERMOUT OFF

SELECT DISTINCT ch.dummy, t.dummy
FROM ch, t
WHERE language = 'R' AND state = 'GR'
AND ch.rowid = t.rid;

SET TERMOUT ON

SELECT * FROM table(dbms_xplan.display_cursor(null,null,'runstats_last'));

PAUSE

REM
REM Cleanup
REM

BEGIN
  dbms_sqltune.drop_tuning_task(:g_task_name);
  dbms_sqltune.drop_sql_profile(name=>'opt_estimate');
END;
/

DROP TABLE t PURGE;
