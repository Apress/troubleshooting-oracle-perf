SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: baseline_from_sqlarea3.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows how to tune an application without changing
REM               its code. A SQL plan baseline is used for that purpose.
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
SET LINESIZE 100

COLUMN plan_table_output FORMAT A100
COLUMN sql_text FORMAT A30
COLUMN sql_handle FORMAT A30

@../connect.sql

SET ECHO ON

REM
REM Cleanup
REM

DROP TABLE t PURGE;

CREATE TABLE t (id, n, pad, CONSTRAINT t_pk PRIMARY KEY (id))
AS 
SELECT rownum, rownum, rpad('*',500,'*')
FROM dual
CONNECT BY level <= 1000;

BEGIN
  dbms_stats.gather_table_stats(
    ownname => user, 
    tabname => 't', 
    estimate_percent => 100, 
    method_opt => 'for all columns size 254',
    cascade => TRUE
  );
END;
/

PAUSE

REM
REM SQL tuning with SQL plan baseline
REM

SELECT /*+ full(t) */ count(pad) FROM t WHERE n = 42;

SELECT * FROM table(dbms_xplan.display_cursor);

PAUSE

CREATE INDEX i ON t (n);

SELECT /*+ index(t) */ count(pad) FROM t WHERE n = 42;

SELECT * FROM table(dbms_xplan.display_cursor);

PAUSE

ALTER SESSION SET optimizer_capture_sql_plan_baselines = TRUE;
SELECT /*+ full(t) */ count(pad) FROM t WHERE n = 42;
SELECT /*+ full(t) */ count(pad) FROM t WHERE n = 42;
ALTER SESSION SET optimizer_capture_sql_plan_baselines = FALSE;

PAUSE

REM Execute twice because sometimes one is "not enough" :-(

SELECT /*+ full(t) */ count(pad) FROM t WHERE n = 42;

SELECT * FROM table(dbms_xplan.display_cursor);

SELECT /*+ full(t) */ count(pad) FROM t WHERE n = 42;

SELECT * FROM table(dbms_xplan.display_cursor);

PAUSE

SELECT sql_handle, plan_name
FROM dba_sql_plan_baselines
WHERE creator = user
AND created > systimestamp - to_dsinterval('0 00:15:00');

SET SERVEROUTPUT ON

DECLARE
  ret PLS_INTEGER;
BEGIN 
  ret := dbms_spm.load_plans_from_cursor_cache(
           sql_id          => '&sql_id_index_scan',
           plan_hash_value => '&plan_hash_value_index_scan',
           sql_handle      => '&sql_handle'
         );
  dbms_output.put_line(ret || ' SQL plan baseline(s) created');
  ret := dbms_spm.drop_sql_plan_baseline(
           sql_handle => '&sql_handle',
           plan_name  => '&plan_name'
         );
  dbms_output.put_line(ret || ' SQL plan baseline(s) dropped');
END;
/

SET SERVEROUTPUT OFF

SELECT sql_handle, sql_text, enabled, accepted
FROM dba_sql_plan_baselines
WHERE creator = user
AND created > systimestamp - to_dsinterval('0 00:15:00');

PAUSE

REM Execute twice because sometimes one is "not enough" :-(

SELECT /*+ full(t) */ count(pad) FROM t WHERE n = 42;

SELECT * FROM table(dbms_xplan.display_cursor);

SELECT /*+ full(t) */ count(pad) FROM t WHERE n = 42;

SELECT * FROM table(dbms_xplan.display_cursor);

PAUSE

REM
REM Cleanup
REM

REM remove all baselines created in the last 15 minutes

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
END;
/

DROP TABLE t PURGE;
