SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: dpi_performance.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script is used to compare direct-path inserts with 
REM               conventional inserts. It was used to generate Figure 11-10
REM               and Figure 11-11.
REM Notes.......: Even if minimal logging is not used, a database running in
REM               noarchivelog mode doesn't generate redo for direct inserts.
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

CREATE TABLE t (id NUMBER, pad VARCHAR2(1000));

REM ALTER TABLE t ADD CONSTRAINT t_pk PRIMARY KEY (id);

PAUSE

REM
REM Conventional path
REM

@../connect.sql

TRUNCATE TABLE t;

ALTER TABLE t LOGGING;

INSERT INTO t
WITH
  t AS (SELECT /*+ materialize */ 1
        FROM dual
        CONNECT BY level <= 1000)
SELECT rownum AS id, rpad('*',1000,'*') AS pad
FROM t, t;

SELECT t.used_ublk, t.used_urec
FROM v$transaction t, v$session s
WHERE t.addr = s.taddr
AND s.audsid = userenv('sessionid');

SELECT value
FROM v$mystat NATURAL JOIN v$statname
WHERE name = 'redo size';

PAUSE

REM
REM Direct path
REM

@../connect.sql

TRUNCATE TABLE t;

ALTER TABLE t LOGGING;

INSERT /*+ append */ INTO t
WITH
  t AS (SELECT /*+ materialize */ 1
        FROM dual
        CONNECT BY level <= 1000)
SELECT rownum AS id, rpad('*',1000,'*') AS pad
FROM t, t;

SELECT t.used_ublk, t.used_urec
FROM v$transaction t, v$session s
WHERE t.addr = s.taddr
AND s.audsid = userenv('sessionid');

SELECT value
FROM v$mystat NATURAL JOIN v$statname
WHERE name = 'redo size';

PAUSE

REM
REM Direct path + nologging
REM

@../connect.sql

TRUNCATE TABLE t;

ALTER TABLE t NOLOGGING;

INSERT /*+ append */ INTO t
WITH
  t AS (SELECT /*+ materialize */ 1
        FROM dual
        CONNECT BY level <= 1000)
SELECT rownum AS id, rpad('*',1000,'*') AS pad
FROM t, t;

SELECT t.used_ublk, t.used_urec
FROM v$transaction t, v$session s
WHERE t.addr = s.taddr
AND s.audsid = userenv('sessionid');

SELECT value
FROM v$mystat NATURAL JOIN v$statname
WHERE name = 'redo size';

PAUSE

REM
REM Cleanup
REM

DROP TABLE t;
PURGE TABLE t;
