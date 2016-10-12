SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: data_compression.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows that the performance of I/O bound
REM               processing might be improved thanks to data compression.
REM Notes.......: -
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM 24.06.2010 Changed CTAS to avoid ORA-30009
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

CREATE TABLE t NOCOMPRESS AS
WITH
  t AS (SELECT /*+ materialize */ rownum AS n
        FROM dual
        CONNECT BY level <= 10000)
SELECT rownum AS n, rpad(' ',500,mod(rownum,15)) AS pad
FROM t, t
WHERE rownum <= 2000000;

execute dbms_stats.gather_table_stats(ownname=>user, tabname=>'t')

SELECT table_name, blocks FROM user_tables WHERE table_name = 'T';

PAUSE

REM
REM Run test with uncompressed table
REM

SELECT value FROM v$mystat NATURAL JOIN v$statname WHERE name = 'CPU used by this session';

SET TIMING ON
SELECT count(n) FROM t;
SELECT count(n) FROM t;
SELECT count(n) FROM t;
SELECT count(n) FROM t;
SELECT count(n) FROM t;
SET TIMING OFF

SELECT value FROM v$mystat NATURAL JOIN v$statname WHERE name = 'CPU used by this session';

PAUSE

REM
REM Compress table
REM

ALTER TABLE t MOVE COMPRESS;

execute dbms_stats.gather_table_stats(ownname=>user, tabname=>'t')

SELECT table_name, blocks FROM user_tables WHERE table_name = 'T';

PAUSE

REM
REM Run test with compressed table
REM

SELECT value FROM v$mystat NATURAL JOIN v$statname WHERE name = 'CPU used by this session';

SET TIMING ON
SELECT count(n) FROM t;
SELECT count(n) FROM t;
SELECT count(n) FROM t;
SELECT count(n) FROM t;
SELECT count(n) FROM t;
SET TIMING OFF

SELECT value FROM v$mystat NATURAL JOIN v$statname WHERE name = 'CPU used by this session';

PAUSE

REM
REM Cleanup
REM

DROP TABLE t;
PURGE TABLE t;
