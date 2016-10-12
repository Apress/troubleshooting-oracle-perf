SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: index_full_scan.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows examples of full index scans.
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
  n1 NUMBER, 
  n2 NUMBER, 
  pad VARCHAR2(4000),
  CONSTRAINT t_pk PRIMARY KEY (id)
);

execute dbms_random.seed(0)

INSERT INTO t
SELECT rownum AS id,
       1+mod(rownum,251) AS n1,
       1+mod(rownum,251) AS n2,
       dbms_random.string('p',255) AS pad
FROM dual
CONNECT BY level <= 10000
ORDER BY dbms_random.value;

CREATE INDEX t_n1_i ON t (n1);

CREATE BITMAP INDEX t_n2_i ON t (n2);

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

SET AUTOTRACE TRACE

PAUSE

REM
REM B-tree
REM

SELECT /*+ index(t t_n1_i) */ n1 FROM t WHERE n1 IS NOT NULL;

PAUSE

SELECT /*+ index_ffs(t t_n1_i) */ n1 FROM t WHERE n1 IS NOT NULL;

PAUSE

SELECT /*+ index(t t_n1_i) */ n1 FROM t WHERE n1 IS NOT NULL ORDER BY n1;

PAUSE

SELECT /*+ index(t t_n1_i) */ n1 FROM t WHERE n1 IS NOT NULL ORDER BY n1 DESC;

PAUSE

SELECT /*+ index_asc(t t_n1_i) */ n1 FROM t WHERE n1 IS NOT NULL ORDER BY n1 DESC;

PAUSE

SELECT /*+ index_desc(t t_n1_i) */ n1 FROM t WHERE n1 IS NOT NULL ORDER BY n1 DESC;

PAUSE

SELECT /*+ index(t t_n1_i) */ count(n1) FROM t;

PAUSE

SELECT /*+ index_ffs(t t_n1_i) */ count(n1) FROM t;

PAUSE

REM
REM bitmap
REM

SELECT /*+ index(t t_n2_i) */ n2 FROM t WHERE n2 IS NOT NULL;

PAUSE

SELECT /*+ index_ffs(t t_n2_i) */ n2 FROM t WHERE n2 IS NOT NULL;

PAUSE

SELECT /*+ index(t t_n2_i) */ n2 FROM t WHERE n2 IS NOT NULL ORDER BY n2;

PAUSE

SELECT /*+ index_ffs(t t_n2_i) */ count(n2) FROM t;

PAUSE

REM
REM Cleanup
REM

SET AUTOTRACE OFF

DROP TABLE t;
PURGE TABLE t;
