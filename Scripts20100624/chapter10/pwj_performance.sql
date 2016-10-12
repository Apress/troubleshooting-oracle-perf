SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: pwj_performance.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script is used to compare the performance of different
REM               partition-wise joins. It was used to generate the figures
REM               found in Figure 10-15.
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

@@create_tx.sql

DROP TABLE t1p;
DROP TABLE t2p;

CREATE TABLE t1p PARTITION BY HASH (id) PARTITIONS 4 AS SELECT rownum AS id FROM t4, t2;
CREATE TABLE t2p PARTITION BY HASH (id) PARTITIONS 4 AS SELECT rownum AS id FROM t4, t3;

ALTER TABLE t1p PARALLEL 4;
ALTER TABLE t2p PARALLEL 4;

BEGIN
  dbms_stats.gather_table_stats(user,'t1p');
  dbms_stats.gather_table_stats(user,'t2p');
END;
/

PAUSE

REM
REM Serial without PWJ
REM

ALTER SYSTEM FLUSH BUFFER_CACHE;
@../connect.sql
set serveroutput on
ALTER SESSION SET workarea_size_policy = manual;
ALTER SESSION SET hash_area_size = 104857600;
ALTER SESSION DISABLE PARALLEL QUERY;

ALTER SESSION SET "_full_pwise_join_enabled" = FALSE;
SET TIMING ON
SELECT /*+ ordered use_hash(t2p) pq_distribute(t2p none none) */ count(*) FROM t1p, t2p WHERE t1p.id = t2p.id;
SET TIMING OFF

PAUSE

REM
REM Serial with PWJ
REM

ALTER SYSTEM FLUSH BUFFER_CACHE;
@../connect.sql
set serveroutput on
ALTER SESSION SET workarea_size_policy = manual;
ALTER SESSION SET hash_area_size = 104857600;
ALTER SESSION DISABLE PARALLEL QUERY;

ALTER SESSION SET "_full_pwise_join_enabled" = TRUE;
SET TIMING ON
SELECT /*+ ordered use_hash(t2p) pq_distribute(t2p none none) */ count(*) FROM t1p, t2p WHERE t1p.id = t2p.id;
SET TIMING OFF

PAUSE

REM
REM Parallel without PWJ
REM

ALTER SYSTEM FLUSH BUFFER_CACHE;
@../connect.sql
set serveroutput on
ALTER SESSION SET workarea_size_policy = manual;
ALTER SESSION SET hash_area_size = 104857600;
ALTER SESSION ENABLE PARALLEL QUERY;

ALTER SESSION SET "_full_pwise_join_enabled" = FALSE;
SET TIMING ON
SELECT /*+ ordered use_hash(t2p) pq_distribute(t2p none none) */ count(*) FROM t1p, t2p WHERE t1p.id = t2p.id;
SET TIMING OFF

PAUSE

REM
REM Parallel with PWJ
REM

ALTER SYSTEM FLUSH BUFFER_CACHE;
@../connect.sql
set serveroutput on
ALTER SESSION SET workarea_size_policy = manual;
ALTER SESSION SET hash_area_size = 104857600;
ALTER SESSION ENABLE PARALLEL QUERY;

ALTER SESSION SET "_full_pwise_join_enabled" = TRUE;
SET TIMING ON
SELECT /*+ ordered use_hash(t2p) pq_distribute(t2p none none) */ count(*) FROM t1p, t2p WHERE t1p.id = t2p.id;
SET TIMING OFF

PAUSE

REM
REM Cleanup
REM

DROP TABLE t4;
PURGE TABLE t4;
DROP TABLE t3;
PURGE TABLE t3;
DROP TABLE t2;
PURGE TABLE t2;
DROP TABLE t1;
PURGE TABLE t1;

DROP TABLE t1p;
PURGE TABLE t1p;
DROP TABLE t2p;
PURGE TABLE t2p;
