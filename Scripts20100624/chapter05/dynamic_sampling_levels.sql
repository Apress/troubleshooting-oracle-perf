SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: dynamic_sampling_levels.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows examples of queries taking advantage of
REM               dynamic sampling, for levels going from 1 to 4.
REM Notes.......: To recognize whether dynamic sampling is used, this script 
REM               makes use of the package dbms_xplan. In fact, as of Oracle
REM               Database 10gR2, it shows the following note when dynamic
REM               sampling is used: "dynamic sampling used for this statement".
REM               Therefore, this script only works when executed in 10gR2/11g.
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM 08.03.2009 Fixed typo in header
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

DROP TABLE t_noidx;
DROP TABLE t_idx;

CREATE TABLE t_noidx (id, n1, n2, pad) AS
SELECT rownum, rownum, round(dbms_random.value(1,100)), dbms_random.string('p',1000)
FROM dual
CONNECT BY level <= 500;

CREATE TABLE t_idx (id PRIMARY KEY, n1, n2, pad) AS
SELECT *
FROM t_noidx;

VARIABLE id NUMBER
exec :id := 19;

ALTER SESSION SET events '10046 trace name context forever, level 4';

PAUSE

REM
REM no statistics, dynamic_sampling = 1
REM
REM dynamic sampling is only used for the query referencing the tables without indexes
REM

EXPLAIN PLAN FOR 
SELECT /*+ dynamic_sampling(1) */ * 
FROM t_noidx t1, t_noidx t2 
WHERE t1.id = t2.id AND t1.id < 19;

SELECT * FROM table(dbms_xplan.display(NULL, NULL, 'basic note'));

EXPLAIN PLAN FOR 
SELECT /*+ dynamic_sampling(1) */ * 
FROM t_idx t1, t_idx t2 
WHERE t1.id = t2.id AND t1.id < 19;

SELECT * FROM table(dbms_xplan.display(NULL, NULL, 'basic note'));

PAUSE

REM
REM no statistics, dynamic_sampling = 2
REM
REM dynamic sampling is used for both queries
REM

EXPLAIN PLAN FOR 
SELECT /*+ dynamic_sampling(2) */ * 
FROM t_noidx t1, t_noidx t2 
WHERE t1.id = t2.id AND t1.id < 19;

SELECT * FROM table(dbms_xplan.display(NULL, NULL, 'basic note'));

EXPLAIN PLAN FOR 
SELECT /*+ dynamic_sampling(2) */ * 
FROM t_idx t1, t_idx t2 
WHERE t1.id = t2.id AND t1.id < 19;

SELECT * FROM table(dbms_xplan.display(NULL, NULL, 'basic note'));

PAUSE

REM same as before but with a bind variable

EXPLAIN PLAN FOR 
SELECT /*+ dynamic_sampling(2) */ * 
FROM t_noidx t1, t_noidx t2 
WHERE t1.id = t2.id AND t1.id < :id;

SELECT * FROM table(dbms_xplan.display(NULL, NULL, 'basic note'));

EXPLAIN PLAN FOR 
SELECT /*+ dynamic_sampling(2) */ * 
FROM t_idx t1, t_idx t2 
WHERE t1.id = t2.id AND t1.id < :id;

SELECT * FROM table(dbms_xplan.display(NULL, NULL, 'basic note'));

PAUSE

REM
REM statistics, dynamic_sampling = 3
REM
REM dynamic sampling is used only for the query with a predicate based on a function
REM

BEGIN
  dbms_stats.gather_table_stats(ownname=>user,
                                tabname=>'t_noidx',
                                method_opt=>'for all columns size 1');
  dbms_stats.gather_table_stats(ownname=>user,
                                tabname=>'t_idx',
                                method_opt=>'for all columns size 1',
                                cascade=>true);
END;
/

PAUSE

EXPLAIN PLAN FOR 
SELECT /*+ dynamic_sampling(3) */ * 
FROM t_idx 
WHERE id = 19;

SELECT * FROM table(dbms_xplan.display(NULL, NULL, 'basic note'));

EXPLAIN PLAN FOR 
SELECT /*+ dynamic_sampling(3) */ * 
FROM t_idx 
WHERE round(id) = 19;

SELECT * FROM table(dbms_xplan.display(NULL, NULL, 'basic note'));

PAUSE

REM
REM statistics, dynamic_sampling = 4
REM
REM dynamic sampling is used because two columns are referenced in the where clause
REM

EXPLAIN PLAN FOR 
SELECT /*+ dynamic_sampling(3) */ * 
FROM t_idx 
WHERE id < 19 AND n1 < 19;

SELECT * FROM table(dbms_xplan.display(NULL, NULL, 'basic note'));

EXPLAIN PLAN FOR 
SELECT /*+ dynamic_sampling(4) */ * 
FROM t_idx 
WHERE id < 19 AND n1 < 19;

SELECT * FROM table(dbms_xplan.display(NULL, NULL, 'basic note'));

PAUSE

REM
REM Cleanup
REM

ALTER SESSION SET events '10046 trace name context off';

DROP TABLE t_noidx;
DROP TABLE t_idx;

PURGE TABLE t_noidx;
PURGE TABLE t_idx;
