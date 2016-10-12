SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: block_prefetching.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows block prefetching for data and index blocks.
REM Notes.......: No control over the utilization of block prefetching is
REM               available. Sometimes it works, sometimes not (in general, 
REM               recent versions use it more frequently). Sometimes an 
REM               instance bounce may also help...
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
SET LINESIZE 150
SET PAGESIZE 1000

COLUMN segment_name FORMAT A30
COLUMN name FORMAT A30

@../connect.sql

SET ECHO ON

REM
REM Setup test environment
REM

ALTER SESSION SET db_file_multiblock_read_count = 8;

DROP TABLE a;
DROP TABLE b;

CREATE TABLE a AS SELECT rownum a1, rownum a2 FROM all_objects WHERE rownum <= 10;
INSERT /*+ append */ INTO a SELECT a1+10, a2+10 FROM a;
COMMIT;
INSERT /*+ append */ INTO a SELECT a1+20, a2+20 FROM a WHERE a1 < 11;
COMMIT;

CREATE TABLE b AS SELECT rownum b1, rownum b2 FROM a WHERE rownum <= 10;
INSERT /*+ append */ INTO b SELECT b1+10, b2+10 FROM b;
COMMIT;
INSERT /*+ append */ INTO b SELECT b1+20, b2+20 FROM b WHERE b1 < 11;
COMMIT;

CREATE INDEX a1_i on a(a1);
CREATE UNIQUE INDEX a2_i on a(a2);
CREATE INDEX b1_i on b(b1);
CREATE UNIQUE INDEX b2_i on b(b2);

BEGIN
  dbms_stats.gather_table_stats(
    ownname=>user, 
    tabname=>'a', 
    cascade=>true);
  dbms_stats.gather_table_stats(
    ownname=>user, 
    tabname=>'b', 
    cascade=>true
  );
END;
/

PAUSE

REM
REM Display execution plan
REM

EXPLAIN PLAN FOR
SELECT /*+ ordered use_nl(b) index(a) index(b) no_nlj_prefetch(b) */ a.*, b.* 
FROM a, b 
WHERE a.a1 = b.b2 AND a.a1 > 0;

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Flush buffer cache
REM

ALTER SYSTEM SET EVENTS 'IMMEDIATE TRACE NAME FLUSH_CACHE';

PAUSE

REM
REM Trace the execution of the query and display execution statistics
REM

@../connect.sql

ALTER SESSION SET EVENTS '10046 TRACE NAME CONTEXT FOREVER, LEVEL 8';

SELECT /*+ ordered use_nl(b) index(a) index(b) no_nlj_prefetch(b) */ a.*, b.* 
FROM a, b 
WHERE a.a1 = b.b2 AND a.a1 > 0;

ALTER SESSION SET EVENTS '10046 TRACE NAME CONTEXT OFF';

SELECT name, value 
FROM v$mystat NATURAL JOIN v$statname 
WHERE name IN ('physical reads','physical reads cache prefetch');

PAUSE

REM Display the name of the trace file (only works in 11g)

SELECT value FROM v$diag_info WHERE name = 'Default Trace File';

REM Check the physical reads
REM (when prefetching is used 'db file scattered read' are seen)

REM grep "db file" <trace file>

PAUSE

REM
REM Cleanup
REM

DROP TABLE a;
PURGE TABLE a;

DROP TABLE b;
PURGE TABLE b;
