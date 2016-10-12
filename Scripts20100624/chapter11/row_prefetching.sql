SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: row_prefetching.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: These scripts provide examples of implementing row
REM               prefetching with PL/SQL.
REM Notes.......: The "Cursor FOR loops" part of this script requires Oracle
REM               Database 10g or 11g.
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

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;

CREATE TABLE t
AS
SELECT rownum AS id, rpad('*',100,'*') AS pad
FROM dual
CONNECT BY level <= 100000;

execute dbms_stats.gather_table_stats(ownname => user, tabname => 'T')

ALTER SESSION SET sql_trace = TRUE;

PAUSE

REM
REM Cursor FOR loops
REM

ALTER SESSION SET plsql_optimize_level = 2;

BEGIN
  FOR c IN (SELECT * FROM t)
  LOOP
    -- process data
    NULL;
  END LOOP;
END;
/

PAUSE

ALTER SESSION SET plsql_optimize_level = 1;

BEGIN
  FOR c IN (SELECT * FROM t)
  LOOP
    -- process data
    NULL;
  END LOOP;
END;
/

PAUSE

REM
REM Bulk collect
REM

DECLARE
  TYPE t_t IS TABLE OF t%ROWTYPE;
  l_t t_t;
BEGIN
  SELECT * BULK COLLECT INTO l_t
  FROM t;
  FOR i IN l_t.FIRST..l_t.LAST
  LOOP
    -- process data
    NULL;
  END LOOP;
END;
/

PAUSE

DECLARE
  CURSOR c IS SELECT * FROM t;
  TYPE t_t IS TABLE OF t%ROWTYPE;
  l_t t_t;
BEGIN
  OPEN c;
  LOOP
    FETCH c BULK COLLECT INTO l_t LIMIT 100;
    EXIT WHEN l_t.COUNT = 0;
    FOR i IN l_t.FIRST..l_t.LAST
    LOOP
      -- process data
      NULL;
    END LOOP;
  END LOOP;
  CLOSE c;
END;
/

PAUSE

REM
REM Check the generated trace file for detailed information about the
REM executions. E.g. the following command may be used:
REM  tkprof <trace file> <output file> sys=no aggregate=no
REM

PAUSE

REM
REM Cleanup
REM

ALTER SESSION SET sql_trace = FALSE;

DROP TABLE t;
PURGE TABLE t;
