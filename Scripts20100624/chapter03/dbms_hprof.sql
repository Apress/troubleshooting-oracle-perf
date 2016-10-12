SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: dbms_hprof.sql
REM Author......: Christian Antognini
REM Date........: June 2010
REM Description.: This script shows how to profile a PL/SQL procedure and how
REM               to display the generated information.
REM Notes.......: This script calls two scripts:
REM               - perfect_triangles.sql to create the procedure used for the
REM                 test.
REM               - ?/rdbms/admin/dbmshptab.sql to create the table used by
REM                 the profiler to store the gathered data.
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

COLUMN runid NEW_VALUE runid
COLUMN total_ms FORMAT 9,999,990 HEADING "TOTAL [ms]"
COLUMN total_percent FORMAT 990.0 HEADING "TOT%"
COLUMN function_ms FORMAT 9,999,990 HEADING "FUNCTION [ms]"
COLUMN function_percent FORMAT 990.0 HEADING "FCT%"
COLUMN descendants_ms FORMAT 9,999,990 HEADING "DESCENDANTS [ms]"
COLUMN descendants_percent FORMAT 990.0 HEADING "DESC%"
COLUMN calls FORMAT 9,999,990 HEADING "CALLS"
COLUMN calls_percent FORMAT 990.0 HEADING "CAL%"
COLUMN function_name FORMAT A70 HEADING "FUNCTION NAME"
COLUMN module_name FORMAT A30
COLUMN namespace_name FORMAT A15

SET ECHO ON

REM
REM Setup test environment
REM

@@perfect_triangles.sql

CREATE DIRECTORY plshprof_dir AS '&directory_path';

PAUSE

REM
REM Install the profiler tables
REM

@?/rdbms/admin/dbmshptab.sql

PAUSE

REM
REM Enable the profiler
REM

BEGIN
  dbms_hprof.start_profiling(location => 'PLSHPROF_DIR',
                             filename => 'test.trc');
END;
/

PAUSE

REM
REM Execute the procedure perfect_triangles
REM

SET TIMING ON
DECLARE
  l_count INTEGER;
BEGIN
  perfect_triangles(1000);
  SELECT count(*) INTO l_count
  FROM all_objects;
END;
/
SET TIMING OFF

PAUSE

REM
REM Stop the profiler
REM

BEGIN
  dbms_hprof.stop_profiling;
END;
/

PAUSE

REM
REM Load profiling data into output tables
REM

SELECT dbms_hprof.analyze(location => 'PLSHPROF_DIR',
                          filename => 'test.trc') AS runid
FROM dual;

PAUSE

REM
REM Display the information gathered by the profiler
REM

REM Namespaces

SELECT sum(c.function_elapsed_time)/1000 AS total_ms,
       sum(c.function_elapsed_time)*100/t.total AS total_percent,
       sum(c.calls) AS calls,
       sum(c.calls)*100/t.tcalls AS calls_percent,
       c.namespace AS namespace_name
FROM dbmshp_function_info c,
     (SELECT max(subtree_elapsed_time) AS total, 
             sum(calls) AS tcalls
      FROM dbmshp_function_info
      WHERE  runid = &runid) t
WHERE c.runid = &runid
GROUP BY c.namespace, t.total, t.tcalls
ORDER BY total_ms DESC;

PAUSE

REM Modules

SELECT sum(c.function_elapsed_time)/1000 AS total_ms,
       sum(c.function_elapsed_time)*100/t.total AS total_percent,
       sum(c.calls) AS calls,
       sum(c.calls)*100/t.tcalls AS calls_percent,
       nullif(c.owner || '.' || c.module, '.') AS module_name
FROM dbmshp_function_info c,
     (SELECT max(subtree_elapsed_time) AS total, 
             sum(calls) AS tcalls 
      FROM dbmshp_function_info 
      WHERE  runid = &runid) t
WHERE c.runid = &runid
GROUP BY c.owner, c.module, t.total, t.tcalls
ORDER BY total_ms DESC;

PAUSE

REM Call hierarchy

SELECT lpad(' ', (level-1) * 2) || nullif(c.owner || '.', '.') ||
       CASE WHEN c.module = c.function THEN c.function ELSE nullif(c.module || '.', '.') || c.function END AS function_name,
       pc.subtree_elapsed_time/1000 AS total_ms, 
       pc.function_elapsed_time/1000 AS function_ms,
       pc.calls AS calls
FROM dbmshp_parent_child_info pc, 
     dbmshp_function_info p, 
     dbmshp_function_info c
START WITH pc.runid = &runid
AND p.runid = pc.runid
AND c.runid = pc.runid
AND pc.childsymid = c.symbolid
AND pc.parentsymid = p.symbolid
AND p.symbolid = 1
CONNECT BY pc.runid = prior pc.runid
AND p.runid = pc.runid 
AND c.runid = pc.runid
AND pc.childsymid = c.symbolid 
AND pc.parentsymid = p.symbolid
AND prior pc.childsymid = pc.parentsymid
ORDER SIBLINGS BY total_ms DESC;

PAUSE

REM Functions

SELECT c.subtree_elapsed_time/1000 AS total_ms,
       c.subtree_elapsed_time*100/t.total AS total_percent,
       c.function_elapsed_time/1000 AS function_ms,
       c.function_elapsed_time*100/t.total AS function_percent,
       (c.subtree_elapsed_time-c.function_elapsed_time)/1000 AS descendants_ms,
       (c.subtree_elapsed_time-c.function_elapsed_time)*100/t.total AS descendants_percent,
       c.calls AS calls,
       c.calls*100/t.tcalls AS calls_percent,
       nullif(c.owner || '.', '.') ||
         CASE WHEN c.module = c.function THEN c.function ELSE nullif(c.module || '.', '.') || c.function END ||
         CASE WHEN c.line# = 0 THEN '' ELSE ' (line '||c.line#||')' END AS function_name
FROM dbmshp_function_info c,
     (SELECT max(subtree_elapsed_time) AS total, 
             sum(calls) AS tcalls
      FROM dbmshp_function_info
      WHERE runid = &runid) t
WHERE c.runid = &runid
ORDER BY total_ms DESC;

PAUSE

REM
REM Cleanup
REM

DROP PROCEDURE perfect_triangles;

DROP DIRECTORY plshprof_dir;

UNDEFINE runid
