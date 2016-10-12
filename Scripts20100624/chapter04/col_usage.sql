SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: col_usage.sql
REM Author......: Christian Antognini
REM Date........: March 2009
REM Description.: This script shows how to retrieve information about the
REM               column usage history from the data dictionary.
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
SET NUMWIDTH 6

COLUMN name FORMAT A13
COLUMN timestamp FORMAT A9

@../connect.sql

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;

CREATE TABLE t
AS
SELECT rownum AS id,
       round(dbms_random.normal*1000) AS val1,
       100+round(ln(rownum/3.25+2)) AS val2,
       100+round(ln(rownum/3.25+2)) AS val3,
       dbms_random.string('p',250) AS pad
FROM dual
CONNECT BY level <= 1000
ORDER BY dbms_random.value;

execute dbms_stats.gather_table_stats(user, 'T')

PAUSE

REM
REM Run some queries with different kind of predicates
REM

SELECT count(*) FROM t WHERE id = 1;
SELECT count(*) FROM t t1, t t2 WHERE t1.id = t2.id;
SELECT count(*) FROM t WHERE val1 = 1;
SELECT count(*) FROM t WHERE val3 = 1;
SELECT count(*) FROM t t1, t t2 WHERE t1.val3 = t2.val3;
SELECT count(*) FROM t WHERE pad BETWEEN 'A' AND 'B';

PAUSE

REM
REM Flush column usage information
REM

execute dbms_stats.flush_database_monitoring_info

PAUSE

REM
REM Show column usage information for table T
REM

SELECT c.name, cu.timestamp,
       cu.equality_preds AS equality, cu.equijoin_preds AS equijoin,
       cu.nonequijoin_preds AS noneequijoin, cu.range_preds AS range, 
       cu.like_preds AS "LIKE", cu.null_preds AS "NULL"
FROM sys.col$ c, sys.col_usage$ cu, sys.obj$ o, sys.user$ u
WHERE c.obj# = cu.obj# (+)
AND c.intcol# = cu.intcol# (+)
AND c.obj# = o.obj#
AND o.owner# = u.user#
AND o.name = 'T'
AND u.name = user
ORDER BY c.col#;

PAUSE

REM
REM Cleanup
REM

DROP TABLE t;
PURGE TABLE t;
