SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************ http://top.antognini.ch **************************
REM ***************************************************************************
REM
REM File name...: bind_variables_peeking.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows the pros and cons of bind variable peeking.
REM Notes.......: This script works with 11g only. However, the first part,
REM               works in 10g as well. The problem is that "extended cursor
REM               sharing", which is shown in the second part, is only
REM               available in 11g.
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

VARIABLE id NUMBER

COLUMN is_bind_sensitive FORMAT A17
COLUMN is_bind_aware FORMAT A13
COLUMN is_shareable FORMAT A12
COLUMN peeked FORMAT A6
COLUMN predicate FORMAT A9 TRUNC

COLUMN sql_id NEW_VALUE sql_id

SET ECHO ON

REM
REM Setup test environment
REM

ALTER SYSTEM FLUSH SHARED_POOL;

DROP TABLE t;

CREATE TABLE t 
AS 
SELECT rownum AS id, rpad('*',100,'*') AS pad 
FROM dual
CONNECT BY level <= 1000;

ALTER TABLE t ADD CONSTRAINT t_pk PRIMARY KEY (id);

BEGIN
  dbms_stats.gather_table_stats(
    ownname          => user, 
    tabname          => 't', 
    estimate_percent => 100, 
    method_opt       => 'for all columns size 1'
  );
END;
/

SELECT count(id), count(DISTINCT id), min(id), max(id) FROM t;

PAUSE

REM
REM Without bind variables different execution plans are used if the value
REM used in the WHERE clause change. This is because the query optimizer
REM recognize the different selectivity of the two predicates.
REM

SELECT count(pad) FROM t WHERE id < 990;

SELECT * FROM table(dbms_xplan.display_cursor(NULL, NULL, 'basic'));

PAUSE

SELECT count(pad) FROM t WHERE id < 10;

SELECT * FROM table(dbms_xplan.display_cursor(NULL, NULL, 'basic'));

PAUSE

REM
REM With bind variables the same execution plan is used. Depending on the 
REM peeked value (10 or 990), a full table scan or an index range scan is used.
REM

EXECUTE :id := 990;

SELECT count(pad) FROM t WHERE id < :id;

SELECT * FROM table(dbms_xplan.display_cursor(NULL, NULL, 'basic'));

PAUSE

EXECUTE :id := 10;

SELECT count(pad) FROM t WHERE id < :id;

SELECT * FROM table(dbms_xplan.display_cursor(NULL, NULL, 'basic'));

PAUSE

ALTER SYSTEM FLUSH SHARED_POOL;

PAUSE

EXECUTE :id := 10;

SELECT count(pad) FROM t WHERE id < :id;

SELECT * FROM table(dbms_xplan.display_cursor(NULL, NULL, 'basic'));

PAUSE

EXECUTE :id := 990;

SELECT count(pad) FROM t WHERE id < :id;

SELECT * FROM table(dbms_xplan.display_cursor(NULL, NULL, 'basic'));

PAUSE

REM
REM Display information about the associated child cursors
REM

SELECT sql_id, child_number, is_bind_sensitive, is_bind_aware, is_shareable
FROM v$sql
WHERE sql_text = 'SELECT count(pad) FROM t WHERE id < :id'
ORDER BY child_number;

PAUSE

REM
REM As of 11g, thanks to extended cursor sharing, the problem is recognized
REM after few executions.
REM

SELECT count(pad) FROM t WHERE id < :id;

SELECT * FROM table(dbms_xplan.display_cursor(NULL, NULL, 'basic'));

PAUSE

EXECUTE :id := 10;

SELECT count(pad) FROM t WHERE id < :id;

SELECT * FROM table(dbms_xplan.display_cursor(NULL, NULL, 'basic'));

PAUSE

REM
REM Display information about the associated child cursors
REM

SELECT child_number, is_bind_sensitive, is_bind_aware, is_shareable
FROM v$sql
WHERE sql_id = '&sql_id'
ORDER BY child_number;

PAUSE

SELECT * FROM table(dbms_xplan.display_cursor('&sql_id',NULL));

PAUSE

SELECT child_number, peeked, executions, rows_processed, buffer_gets
FROM v$sql_cs_statistics 
WHERE sql_id = '&sql_id'
ORDER BY child_number;

PAUSE

SELECT child_number, trim(predicate) AS predicate, low, high
FROM v$sql_cs_selectivity 
WHERE sql_id = '&sql_id'
ORDER BY child_number;

PAUSE

SELECT child_number, bucket_id, count
FROM v$sql_cs_histogram 
WHERE sql_id = '&sql_id'
ORDER BY child_number, bucket_id;

PAUSE

REM
REM Cleanup
REM

UNDEFINE sql_id

DROP TABLE t;
PURGE TABLE t;
