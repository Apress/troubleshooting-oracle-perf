SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: px_dop1.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows the impact of the initialization parameter
REM               parallel_min_percent.
REM Notes.......: -
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

CREATE TABLE t (id NUMBER NOT NULL, pad VARCHAR2(1000));

INSERT INTO t
SELECT rownum, rpad('*',100,'*')
FROM dual
CONNECT BY level <= 100000;

COMMIT;

execute dbms_stats.gather_table_stats(ownname => user, tabname => 't')

PAUSE

REM
REM The parameter parallel_max_servers should be set to 40
REM (in 9i it is not possible to change this parameter dynamically)
REM

show parameter parallel_max_servers
ALTER SYSTEM SET parallel_max_servers = 40;

PAUSE

REM
REM Shows the impact of the initialization parameter parallel_min_percent
REM

ALTER TABLE t PARALLEL 50;

PAUSE

ALTER SESSION SET parallel_min_percent = 80;

SELECT count(pad) FROM t;

PAUSE

ALTER SESSION SET parallel_min_percent = 81;

SELECT count(pad) FROM t;

PAUSE

SELECT sn.name, ms.value
FROM v$mystat ms NATURAL JOIN v$statname sn
WHERE sn.name like 'Parallel operations%';

SELECT name, value
FROM v$sysstat
WHERE name like 'Parallel operations%';

PAUSE

REM
REM Cleanup
REM

DROP TABLE t;
PURGE TABLE t;
