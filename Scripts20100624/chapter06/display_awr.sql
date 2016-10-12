SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: display_awr.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows examples of how to use the function
REM               display_awr in the package dbms_xplan.
REM Notes.......: This script works as of Oracle Database 10g only.
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM 24.06.2010 Improved query that displays AWR content
REM ***************************************************************************

SET TERMOUT ON
SET FEEDBACK OFF
SET VERIFY OFF
SET SCAN ON
SET LONG 40

@../connect.sql

SET SERVEROUTPUT ON
SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;

CREATE TABLE t 
AS
SELECT rownum AS n, lpad('*',1000,'*') AS pad  
FROM dual 
CONNECT BY level <= 100000;

execute dbms_stats.gather_table_stats(user, 't')

PAUSE

REM
REM Create 3 AWR snapshots
REM

DECLARE
  l_count PLS_INTEGER;
BEGIN
  dbms_output.put_line('Snap id 1: '||dbms_workload_repository.create_snapshot('ALL'));

  FOR i IN 1..10 
  LOOP
    SELECT count(n) INTO l_count
    FROM t;
  END LOOP;

  dbms_output.put_line('Snap id 2: '||dbms_workload_repository.create_snapshot('ALL'));
  
  EXECUTE IMMEDIATE 'CREATE INDEX i ON t (n)';

  FOR i IN 1..10 
  LOOP
    SELECT count(n) INTO l_count
    FROM t;
  END LOOP;
  
  dbms_output.put_line('Snap id 3: '||dbms_workload_repository.create_snapshot('ALL'));
END;
/

PAUSE

REM
REM Display execution plans
REM

SELECT sql_id, plan_hash_value
FROM dba_hist_sqlstat
WHERE snap_id BETWEEN &begin AND &end
AND executions_delta = 10
AND parsing_schema_name = user
ORDER BY sql_id;

PAUSE

SELECT * FROM table(dbms_xplan.display_awr('&sql_id',NULL,NULL,'basic'));

PAUSE

SELECT * FROM table(dbms_xplan.display_awr('&sql_id',&plan_hash_value,NULL,'basic'));

PAUSE

REM
REM Cleanup
REM

DROP TABLE t;
PURGE TABLE t;

execute dbms_workload_repository.drop_snapshot_range(&low_snap_id, &high_snap_id)
