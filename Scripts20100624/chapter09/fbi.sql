SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: fbi.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows an example of a function-based index.
REM Notes.......: -
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM 10.06.2009 To avoid index joins set _index_join_enabled to FALSE
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

CREATE TABLE t (
  id NUMBER,
  c1 VARCHAR2(20),
  CONSTRAINT t_pk PRIMARY KEY (id)
);

BEGIN
  dbms_stats.gather_table_stats(
    ownname          => user,
    tabname          => 'T',
    estimate_percent => 100,
    method_opt       => 'for all columns size skewonly',
    cascade          => TRUE
  );
END;
/

ALTER SESSION SET "_index_join_enabled" = FALSE;

SET AUTOTRACE TRACEONLY EXPLAIN

PAUSE

REM
REM "Regular" index
REM

CREATE INDEX i_c1 ON t (c1);

SELECT * FROM t WHERE upper(c1) = 'SELDON';

PAUSE

REM
REM "Regular" index with constraint
REM

ALTER TABLE t MODIFY (c1 NOT NULL);

ALTER TABLE t ADD CONSTRAINT t_c1_upper CHECK (c1 = upper(c1));

SELECT * FROM t WHERE upper(c1) = 'SELDON';

ALTER TABLE t DROP CONSTRAINT t_c1_upper;

PAUSE

REM
REM Function-based index
REM

CREATE INDEX i_c1_upper ON t (upper(c1));

SELECT * FROM t WHERE upper(c1) = 'SELDON';

DROP INDEX i_c1_upper;

PAUSE

REM
REM Bitmap function-based index
REM

CREATE BITMAP INDEX i_c1_upper ON t (upper(c1));

SELECT * FROM t WHERE upper(c1) = 'SELDON';

DROP INDEX i_c1_upper;

PAUSE

REM
REM The following SQL statements works as of Oracle Database 11g only
REM

PAUSE

REM
REM Index based on a virtual column
REM

ALTER TABLE t ADD (c1_upper AS (upper(c1)));

CREATE INDEX i_c1_upper ON t (c1_upper);

SELECT * FROM t WHERE c1_upper = 'SELDON';

DROP INDEX i_c1_upper;

PAUSE

REM
REM Bitmap index based on a virtual column
REM

ALTER TABLE t ADD (c1_upper AS (upper(c1)));

CREATE BITMAP INDEX i_c1_upper ON t (c1_upper);

SELECT * FROM t WHERE c1_upper = 'SELDON';

DROP INDEX i_c1_upper;

PAUSE

REM
REM Cleanup
REM

SET AUTOTRACE OFF

DROP TABLE t;
PURGE TABLE t;
