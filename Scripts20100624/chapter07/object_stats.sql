SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: object_stats.sql
REM Author......: Christian Antognini
REM Date........: May 2009
REM Description.: This script shows how it is possible to provide object
REM               statistics to the query optimizer with a SQL profile.
REM Notes.......: This script requires the sample schema SH.
REM               This script requires Oracle Database 10g or newer. However,
REM               in 10.2.0.4 the SQL Tuning Advisor no longer proposes a SQL 
REM               profile and, therefore, the script no longer shows what it
REM               is expected to show.
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
SET ECHO ON

COLUMN report FORMAT A100

CONNECT sh/&password@&service

REM
REM Setup test environment (notice that no statistics are gathered!)
REM

DROP MATERIALIZED VIEW sh.amount_sold_mv;

CREATE MATERIALIZED VIEW sh.amount_sold_mv
ENABLE QUERY REWRITE
AS
SELECT time_id, sum(s.amount_sold) AS sumsld
FROM sh.sales s
GROUP BY s.time_id
/

PAUSE

@../connect.sql

REM
REM Run the test query, since no statistics are available the query 
REM optimizer uses dynamic sampling
REM 

EXPLAIN PLAN FOR
SELECT calendar_year, sum(amount_sold) AS sumamt
FROM sh.times t, sh.sales s
WHERE t.time_id = s.time_id
GROUP BY calendar_year;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Let tune it...
REM

VARIABLE g_task_name VARCHAR2(30)
BEGIN
  :g_task_name := dbms_sqltune.create_tuning_task(
                    sql_text => 'SELECT calendar_year, sum(amount_sold) AS sumamt FROM sh.times t, sh.sales s WHERE t.time_id=s.time_id GROUP BY calendar_year',
                    scope => 'COMPREHENSIVE',
                    time_limit => 42
                  );
  dbms_sqltune.execute_tuning_task(:g_task_name);
END;
/

PAUSE

SELECT dbms_sqltune.report_tuning_task(:g_task_name) report FROM dual;

PAUSE

REM
REM Accept SQL profile
REM

VARIABLE g_sql_profile VARCHAR2(30)

BEGIN
  :g_sql_profile := dbms_sqltune.accept_sql_profile(
                      task_name => :g_task_name, 
                      name => 'object_stats.sql',
                      category => 'TEST'
                    );
END;
/

PAUSE

REM
REM Display SQL profile hints
REM

REM The following query only works in 10g

SELECT attr_val
FROM sys.sqlprof$ p, sys.sqlprof$attr a
WHERE p.sp_name = 'object_stats.sql'
AND p.signature = a.signature
AND p.category = a.category;

REM The following query only works in 11g

SELECT extractValue(value(h),'.') AS hint
FROM sys.sqlobj$data od, sys.sqlobj$ so,
     table(xmlsequence(extract(xmltype(od.comp_data),'/outline_data/hint'))) h
WHERE so.name = 'object_stats.sql'
AND so.signature = od.signature
AND so.category = od.category
AND so.obj_type = od.obj_type
AND so.plan_id = od.plan_id;

PAUSE

REM
REM Test the SQL profile
REM

ALTER SESSION SET sqltune_category = DEFAULT;

EXPLAIN PLAN FOR
SELECT calendar_year, sum(amount_sold) AS sumamt
FROM sh.times t, sh.sales s
WHERE t.time_id = s.time_id
GROUP BY calendar_year;

SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER SESSION SET sqltune_category = TEST;

EXPLAIN PLAN FOR
SELECT calendar_year, sum(amount_sold) AS sumamt
FROM sh.times t, sh.sales s
WHERE t.time_id = s.time_id
GROUP BY calendar_year;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Cleanup
REM

BEGIN
  dbms_sqltune.drop_tuning_task(:g_task_name);
  dbms_sqltune.drop_sql_profile(name=>'object_stats.sql');
END;
/

DROP MATERIALIZED VIEW sh.amount_sold_mv;
