SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: subquery_unnesting.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script provides several examples of subquery unnesting.
REM Notes.......: The unnesting of the anti join in this scripts works as of 
REM               Oracle Database 10g only.
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM 24.06.2010 Cover many more cases
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

REM
REM Semi join
REM

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE EXISTS (SELECT /*+ no_unnest */ 1 
              FROM t1
              WHERE t1.id = t2.t1_id
              AND t1.pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE EXISTS (SELECT 1 
              FROM t1
              WHERE t1.id = t2.t1_id
              AND t1.pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE t1_id IN (SELECT /*+ no_unnest */ id
                FROM t1
                WHERE pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE t1_id IN (SELECT id 
                FROM t1
                WHERE pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE t1_id IN (SELECT /*+ no_unnest */ id
                FROM t1
                WHERE t1.n = t2.n
                AND t1.pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE t1_id IN (SELECT id 
                FROM t1
                WHERE t1.n = t2.n
                AND t1.pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Anti join
REM

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE NOT EXISTS (SELECT /*+ no_unnest */ 1 
                  FROM t1
                  WHERE t1.id = t2.t1_id
                  AND t1.pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE NOT EXISTS (SELECT 1 
                  FROM t1
                  WHERE t1.id = t2.t1_id
                  AND t1.pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE t1_id NOT IN (SELECT /*+ no_unnest */ id
                    FROM t1
                    WHERE pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE t1_id NOT IN (SELECT id
                    FROM t1
                    WHERE pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE t1_id NOT IN (SELECT /*+ no_unnest */ t1.id
                    FROM t1
                    WHERE t1.n = t2.n
                    AND t1.pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE t1_id NOT IN (SELECT t1.id
                    FROM t1
                    WHERE t1.n = t2.n
                    AND t1.pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Exceptions - Subquery references ROWNUM
REM

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE EXISTS (SELECT 1
              FROM t1
              WHERE t1.id = t2.t1_id
              AND t1.pad IS NOT NULL
              AND rownum <= 10);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE NOT EXISTS (SELECT 1
                  FROM t1
                  WHERE t1.id = t2.t1_id
                  AND t1.pad IS NOT NULL
                  AND rownum <= 10);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE t1_id IN (SELECT id
                FROM t1
                WHERE t1.n = t2.n
                AND t1.pad IS NOT NULL
                AND rownum <= 10);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE t1_id NOT IN (SELECT id
                    FROM t1
                    WHERE t1.n = t2.n
                    AND t1.pad IS NOT NULL
                    AND rownum <= 10);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE t1_id NOT IN (SELECT id
                    FROM t1
                    WHERE pad IS NOT NULL
                    AND rownum <= 10);

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM But this one works...

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE t1_id IN (SELECT id
                FROM t1
                WHERE pad IS NOT NULL
                AND rownum <= 10);

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Exceptions - Uncorrelated EXISTS or NOT EXISTS
REM

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE EXISTS (SELECT 1
              FROM t1
              WHERE pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE NOT EXISTS (SELECT 1
                  FROM t1
                  WHERE pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Exceptions - Hierarchical subquery
REM

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE EXISTS (SELECT 1
              FROM t1
              START WITH t1.id = t2.t1_id
              CONNECT BY id = PRIOR n+1
              AND t1.pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE t1_id IN (SELECT t1.id
                FROM t1
                START WITH t1.id = t2.t1_id
                CONNECT BY id = PRIOR n+1
                AND t1.pad IS NOT NULL);

SELECT * FROM table(dbms_xplan.display);


PAUSE

REM
REM Exceptions - Subquery contains aggregation
REM

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE EXISTS (SELECT id
              FROM t1
              WHERE t1.id = t2.t1_id
              AND t1.pad IS NOT NULL
              GROUP BY id
              HAVING count(*) > 1);

SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Exceptions - Subquery contains set operator (unnesting is performed as of 11.2 only)
REM

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE EXISTS (SELECT 1
              FROM t1
              WHERE t1.id = t2.t1_id
              AND t1.pad IS NOT NULL
              UNION ALL
              SELECT 1
              FROM t1
              WHERE t1.id = t2.t1_id
              AND t1.pad IS NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE EXISTS (SELECT 1
              FROM t1
              WHERE t1.id = t2.t1_id
              AND t1.pad IS NOT NULL
              UNION
              SELECT 1
              FROM t1
              WHERE t1.id = t2.t1_id
              AND t1.pad IS NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE EXISTS (SELECT 1
              FROM t1
              WHERE t1.id = t2.t1_id
              AND t1.pad IS NOT NULL
              MINUS
              SELECT 1
              FROM t1
              WHERE t1.id = t2.t1_id
              AND t1.pad IS NULL);

SELECT * FROM table(dbms_xplan.display);

PAUSE

EXPLAIN PLAN FOR
SELECT *
FROM t2
WHERE EXISTS (SELECT 1
              FROM t1
              WHERE t1.id = t2.t1_id
              AND t1.pad IS NOT NULL
              INTERSECT
              SELECT 1
              FROM t1
              WHERE t1.id = t2.t1_id
              AND t1.pad IS NULL);

SELECT * FROM table(dbms_xplan.display);

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
