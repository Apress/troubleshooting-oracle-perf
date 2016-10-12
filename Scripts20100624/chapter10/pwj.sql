SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: pwj.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script provides several examples of partition-wise joins.
REM Notes.......: -
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM 24.06.2010 Disabled join-filter pruning
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

PAUSE

DROP TABLE t1p PURGE;
DROP TABLE t2p PURGE;

CREATE TABLE t1p 
PARTITION BY HASH (id) PARTITIONS 4 
AS 
SELECT rownum AS id, dbms_random.string('p',50) AS pad 
FROM t4, t2;

CREATE TABLE t2p 
PARTITION BY HASH (id) PARTITIONS 4 
AS 
SELECT rownum AS id, dbms_random.string('p',50) AS pad 
FROM t4, t2;

BEGIN
  dbms_stats.gather_table_stats(user,'t1p');
  dbms_stats.gather_table_stats(user,'t2p');
END;
/

ALTER SESSION SET "_bloom_pruning_enabled" = FALSE;

PAUSE

SET AUTOTRACE TRACEONLY EXPLAIN

REM
REM No PWJ
REM

ALTER SESSION SET "_full_pwise_join_enabled" = FALSE;
ALTER SESSION DISABLE PARALLEL QUERY;

PAUSE

SELECT * FROM t1p, t2p WHERE t1p.id = t2p.id;

PAUSE

SELECT /*+ leading(t1p) use_hash(t2p) */ * FROM t1p, t2p WHERE t1p.id = t2p.id;
SELECT /*+ leading(t1p) use_merge(t2p) */ * FROM t1p, t2p WHERE t1p.id = t2p.id;
SELECT /*+ leading(t1p) use_nl(t2p) */ * FROM t1p, t2p WHERE t1p.id = t2p.id;

PAUSE

REM
REM Serial full PWJ
REM

ALTER SESSION SET "_full_pwise_join_enabled" = TRUE;
ALTER SESSION DISABLE PARALLEL QUERY;

PAUSE

SELECT * FROM t1p, t2p WHERE t1p.id = t2p.id;

PAUSE

SELECT /*+ leading(t1p) use_hash(t2p) */ * FROM t1p, t2p WHERE t1p.id = t2p.id;
SELECT /*+ leading(t1p) use_merge(t2p) */ * FROM t1p, t2p WHERE t1p.id = t2p.id;
SELECT /*+ leading(t1p) use_nl(t2p) */ * FROM t1p, t2p WHERE t1p.id = t2p.id;

PAUSE

REM
REM Parallel full PWJ
REM

ALTER SESSION SET "_full_pwise_join_enabled" = TRUE;
ALTER SESSION FORCE PARALLEL QUERY PARALLEL 4;

PAUSE

SELECT * FROM t1p, t2p WHERE t1p.id = t2p.id;

PAUSE

SELECT /*+ leading(t1p) use_hash(t2p) */ * FROM t1p, t2p WHERE t1p.id = t2p.id;
SELECT /*+ leading(t1p) use_merge(t2p) */ * FROM t1p, t2p WHERE t1p.id = t2p.id;
SELECT /*+ leading(t1p) use_nl(t2p) */ * FROM t1p, t2p WHERE t1p.id = t2p.id;

PAUSE

SELECT /*+ ordered use_hash(t2p) pq_distribute(t2p none none) */ * FROM t1p, t2p WHERE t1p.id = t2p.id;

PAUSE

REM
REM No partial PWJ
REM

ALTER SESSION SET "_partial_pwise_join_enabled" = FALSE;
ALTER SESSION DISABLE PARALLEL QUERY;

PAUSE

SELECT * FROM t1p, t4 WHERE t1p.id = t4.id;

PAUSE

SELECT /*+ leading(t1p) use_hash(t4) */ * FROM t1p, t4 WHERE t1p.id = t4.id;
SELECT /*+ leading(t1p) use_merge(t4) */ * FROM t1p, t4 WHERE t1p.id = t4.id;
SELECT /*+ leading(t1p) use_nl(t4) */ * FROM t1p, t4 WHERE t1p.id = t4.id;

PAUSE

REM
REM Parallel partial PWJ
REM

ALTER SESSION SET "_partial_pwise_join_enabled" = TRUE;
ALTER SESSION FORCE PARALLEL QUERY PARALLEL 4;

PAUSE

SELECT * FROM t1p, t4 WHERE t1p.id = t4.id;

PAUSE

ALTER SESSION SET "_partial_pwise_join_enabled" = TRUE;
ALTER SESSION FORCE PARALLEL QUERY PARALLEL 8;
SELECT * FROM t1p, t4 WHERE t1p.id = t4.id;

PAUSE

SELECT /*+ leading(t1p) use_hash(t4) */ * FROM t1p, t4 WHERE t1p.id = t4.id;
SELECT /*+ leading(t1p) use_merge(t4) */ * FROM t1p, t4 WHERE t1p.id = t4.id;
SELECT /*+ leading(t1p) use_nl(t4) */ * FROM t1p, t4 WHERE t1p.id = t4.id;

PAUSE

SELECT /*+ ordered use_hash(t2p) pq_distribute(t2p none partition) */ * FROM t1p, t2p WHERE t1p.id = t2p.id;

PAUSE

REM
REM Cleanup
REM

SET AUTOTRACE OFF

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
