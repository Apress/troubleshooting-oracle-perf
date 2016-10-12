SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: pruning_hash.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows several examples of partition pruning
REM               applied to a hash-partitioned table.
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

COLUMN partition_name FORMAT A14

COLUMN id_plus_exp FORMAT 990 HEADING i NOPRINT
COLUMN parent_id_plus_exp FORMAT 990 HEADING p NOPRINT
COLUMN plan_plus_exp FORMAT A80 TRUNC
COLUMN object_node_plus_exp FORMAT A8
COLUMN other_tag_plus_exp FORMAT A29
COLUMN other_plus_exp FORMAT A44

@../connect.sql

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;

CREATE TABLE t (
  id NUMBER,
  d1 DATE,
  --d1 DATE NOT NULL,
  n1 NUMBER,
  --n1 NUMBER NOT NULL,
  n2 NUMBER,
  n3 NUMBER,
  pad VARCHAR2(4000),
  CONSTRAINT t_pk PRIMARY KEY (id)
)
PARTITION BY HASH (n1, d1) PARTITIONS 32;

PAUSE

execute dbms_random.seed(0)

INSERT INTO t 
SELECT rownum AS id,
       trunc(to_date('2007-01-01','yyyy-mm-dd')+rownum/27.4) AS d1,
       1+mod(rownum,4) AS n1,
       255+mod(trunc(dbms_random.normal*1000),255) AS n2,
       round(4515+dbms_random.normal*1234) AS n3,
       dbms_random.string('p',255) AS pad
FROM dual
CONNECT BY level <= 10000
ORDER BY dbms_random.value;

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

SELECT partition_name, partition_position, num_rows
FROM user_tab_partitions
WHERE table_name = 'T'
ORDER BY partition_position;

PAUSE

DROP TABLE tx;

CREATE TABLE tx AS SELECT * FROM t;

ALTER TABLE tx ADD CONSTRAINT tx_pk PRIMARY KEY (id);

BEGIN
  dbms_stats.gather_table_stats(
    ownname          => user,
    tabname          => 'TX'
  );
END;
/

PAUSE

SET AUTOTRACE TRACEONLY EXPLAIN

REM
REM SINGLE
REM

SELECT * FROM t WHERE n1 = 3 AND d1 = to_date('2007-07-19','yyyy-mm-dd');

PAUSE

VARIABLE n1 NUMBER
EXECUTE :n1 := 3
VARIABLE d1 VARCHAR2(10)
EXECUTE :d1 := '2007-07-19'

SELECT * FROM t WHERE n1 = :n1 AND d1 = to_date(:d1,'yyyy-mm-dd');

PAUSE

SELECT * FROM t WHERE n1 IN (3) AND d1 IN (to_date('2007-07-19','yyyy-mm-dd'));

PAUSE

REM
REM INLIST
REM

SELECT * FROM t WHERE n1 IN (1,3) AND d1 = to_date('2008-07-19','yyyy-mm-dd');

PAUSE

REM
REM ALL
REM

SELECT * FROM t WHERE n1 = 3;

PAUSE

SELECT * FROM t WHERE n1 IS NULL;

PAUSE

SELECT * FROM t WHERE n1 = 3 AND d1 BETWEEN to_date('2007-03-06','yyyy-mm-dd') AND to_date('2007-07-19','yyyy-mm-dd');

PAUSE

SELECT * FROM t WHERE n1 = 3 AND d1 < to_date('2007-07-19','yyyy-mm-dd');

PAUSE

SELECT * FROM t WHERE n1 != 3 AND d1 != to_date('2007-07-19','yyyy-mm-dd');

PAUSE

SELECT * FROM t WHERE to_char(n1,'S9') = '+3' AND to_char(d1,'yyyy-mm-dd') = '2007-07-19';

PAUSE

SELECT * FROM t WHERE n1 + 1 = 4 AND to_char(d1,'yyyy-mm-dd') = '2007-07-19';

PAUSE

REM
REM OR condition
REM

SELECT * FROM t WHERE n1 = 3 OR d1 = to_date('2007-03-06','yyyy-mm-dd');

PAUSE

REM
REM Subquery and join-filter pruning
REM (join-filter pruning is available as of Oracle Database 11g)
REM

REM Without subquery and join-filter pruning

ALTER SESSION SET "_subquery_pruning_enabled" = FALSE;
ALTER SESSION SET "_bloom_pruning_enabled" = FALSE;

PAUSE

SELECT /*+ leading(tx) use_nl(t) */ * FROM tx, t WHERE tx.d1 = t.d1 AND tx.n1 = t.n1 AND tx.id = 19;

PAUSE

SELECT /*+ leading(tx) use_hash(t) */ * FROM tx, t WHERE tx.d1 = t.d1 AND tx.n1 = t.n1 AND tx.id = 19;

PAUSE

SELECT /*+ leading(tx) use_merge(t) */ * FROM tx, t WHERE tx.d1 = t.d1 AND tx.n1 = t.n1 AND tx.id = 19;

PAUSE

REM With subquery pruning

ALTER SESSION SET "_bloom_pruning_enabled" = FALSE;
ALTER SESSION SET "_subquery_pruning_enabled" = TRUE;
ALTER SESSION SET "_subquery_pruning_cost_factor"=1;
ALTER SESSION SET "_subquery_pruning_reduction"=100;

PAUSE

SELECT /*+ leading(tx) use_hash(t) */ * FROM tx, t WHERE tx.d1 = t.d1 AND tx.n1 = t.n1 AND tx.id = 19;

PAUSE

SELECT /*+ leading(tx) use_merge(t) */ * FROM tx, t WHERE tx.d1 = t.d1 AND tx.n1 = t.n1 AND tx.id = 19;

PAUSE

REM Trace recursive query

SET AUTOTRACE OFF
ALTER SESSION SET sql_trace = TRUE;

SELECT /*+ leading(tx) use_hash(t) */ * FROM tx, t WHERE tx.d1 = t.d1 AND tx.n1 = t.n1 AND tx.id = 19;

ALTER SESSION SET sql_trace = FALSE;
SET AUTOTRACE TRACEONLY EXPLAIN

PAUSE

REM With join-filter pruning

ALTER SESSION SET "_subquery_pruning_enabled" = FALSE;
ALTER SESSION SET "_bloom_pruning_enabled" = TRUE;

PAUSE

SELECT /*+ leading(tx) use_hash(t) */ * FROM tx, t WHERE tx.d1 = t.d1 AND tx.n1 = t.n1 AND tx.id = 19;

PAUSE

SELECT /*+ leading(tx) use_merge(t) */ * FROM tx, t WHERE tx.d1 = t.d1 AND tx.n1 = t.n1 AND tx.id = 19;

PAUSE

REM
REM Cleanup 
REM

SET AUTOTRACE OFF

DROP TABLE t;
PURGE TABLE t;

DROP TABLE tx;
PURGE TABLE tx;
