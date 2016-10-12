SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: long_parse.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script is used to carry out a parse lasting about one
REM               second. It also shows how to create a stored outline to avoid
REM               such a long parse.
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

DROP OUTLINE o;

BEGIN
  FOR i IN 1..10 LOOP
    BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE t' || i;
      EXECUTE IMMEDIATE 'PURGE TABLE t' || i;
    EXCEPTION
      WHEN OTHERS THEN NULL;
    END;
    EXECUTE IMMEDIATE 'CREATE TABLE t' || i || ' AS 
                       SELECT mod(rownum,2)  AS n1,  mod(rownum,3)  AS n2,  mod(rownum,4)  AS n3, 
                              mod(rownum,5)  AS n4,  mod(rownum,6)  AS n5,  mod(rownum,7)  AS n6, 
                              mod(rownum,8)  AS n7,  mod(rownum,9)  AS n8,  mod(rownum,10) AS n9,
                              mod(rownum,11) AS n10, mod(rownum,12) AS n11, mod(rownum,13) AS n12,
                              mod(rownum,14) AS n13, mod(rownum,15) AS n14, mod(rownum,16) AS n15,
                              mod(rownum,17) AS n16, mod(rownum,18) AS n17, mod(rownum,19) AS n18,
                              mod(rownum,20) AS n19, mod(rownum,21) AS n20
                       FROM dual
                       CONNECT BY level <= 10000';
    FOR j IN 1..10 LOOP
      EXECUTE IMMEDIATE 'CREATE INDEX t' || i || '_n' || j || '_i ON t' || i || ' (n' || j || ')';
    END LOOP;
    dbms_stats.gather_table_stats(user, 't' || i, method_opt=>'for all columns size 254');
  END LOOP;
END;
/

ALTER SYSTEM FLUSH SHARED_POOL;

PAUSE

REM
REM Parse without stored outline
REM

@../connect.sql

execute dbms_monitor.session_trace_enable

SELECT  count(*)
FROM t1
WHERE t1.n1 = 1 AND n2 = 2 AND n3 = 3 AND n4 = 4 AND n5 = 5 AND n6 = 6 AND n7 = 7 AND n8 = 8 AND n9 = 9 AND n10 = 10
AND EXISTS (SELECT 1 FROM t2 WHERE t2.n1 = t1.n1 AND t2.n2 = t1.n2 AND t2.n3 = t1.n3 AND t2.n4 = t1.n4 AND t2.n5 = t1.n5 AND t2.n6 = t1.n6 AND t2.n7 = t1.n7 AND t2.n8 = t1.n8 AND t2.n9 = t1.n9 AND t2.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t3 WHERE t3.n1 = t1.n1 AND t3.n2 = t1.n2 AND t3.n3 = t1.n3 AND t3.n4 = t1.n4 AND t3.n5 = t1.n5 AND t3.n6 = t1.n6 AND t3.n7 = t1.n7 AND t3.n8 = t1.n8 AND t3.n9 = t1.n9 AND t3.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t4 WHERE t4.n1 = t1.n1 AND t4.n2 = t1.n2 AND t4.n3 = t1.n3 AND t4.n4 = t1.n4 AND t4.n5 = t1.n5 AND t4.n6 = t1.n6 AND t4.n7 = t1.n7 AND t4.n8 = t1.n8 AND t4.n9 = t1.n9 AND t4.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t5 WHERE t5.n1 = t1.n1 AND t5.n2 = t1.n2 AND t5.n3 = t1.n3 AND t5.n4 = t1.n4 AND t5.n5 = t1.n5 AND t5.n6 = t1.n6 AND t5.n7 = t1.n7 AND t5.n8 = t1.n8 AND t5.n9 = t1.n9 AND t5.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t6 WHERE t6.n1 = t1.n1 AND t6.n2 = t1.n2 AND t6.n3 = t1.n3 AND t6.n4 = t1.n4 AND t6.n5 = t1.n5 AND t6.n6 = t1.n6 AND t6.n7 = t1.n7 AND t6.n8 = t1.n8 AND t6.n9 = t1.n9 AND t6.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t7 WHERE t7.n1 = t1.n1 AND t7.n2 = t1.n2 AND t7.n3 = t1.n3 AND t7.n4 = t1.n4 AND t7.n5 = t1.n5 AND t7.n6 = t1.n6 AND t7.n7 = t1.n7 AND t7.n8 = t1.n8 AND t7.n9 = t1.n9 AND t7.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t8 WHERE t8.n1 = t1.n1 AND t8.n2 = t1.n2 AND t8.n3 = t1.n3 AND t8.n4 = t1.n4 AND t8.n5 = t1.n5 AND t8.n6 = t1.n6 AND t8.n7 = t1.n7 AND t8.n8 = t1.n8 AND t8.n9 = t1.n9 AND t8.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t9 WHERE t9.n1 = t1.n1 AND t9.n2 = t1.n2 AND t9.n3 = t1.n3 AND t9.n4 = t1.n4 AND t9.n5 = t1.n5 AND t9.n6 = t1.n6 AND t9.n7 = t1.n7 AND t9.n8 = t1.n8 AND t9.n9 = t1.n9 AND t9.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t10 WHERE t10.n1 = t1.n1 AND t10.n2 = t1.n2 AND t10.n3 = t1.n3 AND t10.n4 = t1.n4 AND t10.n5 = t1.n5 AND t10.n6 = t1.n6 AND t10.n7 = t1.n7 AND t10.n8 = t1.n8 AND t10.n9 = t1.n9 AND t10.n10 = t1.n10);

execute dbms_monitor.session_trace_disable

PAUSE

REM
REM Parse with stored outline
REM

@../connect.sql

CREATE OUTLINE o ON
SELECT  count(*)
FROM t1
WHERE t1.n1 = 1 AND n2 = 2 AND n3 = 3 AND n4 = 4 AND n5 = 5 AND n6 = 6 AND n7 = 7 AND n8 = 8 AND n9 = 9 AND n10 = 10
AND EXISTS (SELECT 1 FROM t2 WHERE t2.n1 = t1.n1 AND t2.n2 = t1.n2 AND t2.n3 = t1.n3 AND t2.n4 = t1.n4 AND t2.n5 = t1.n5 AND t2.n6 = t1.n6 AND t2.n7 = t1.n7 AND t2.n8 = t1.n8 AND t2.n9 = t1.n9 AND t2.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t3 WHERE t3.n1 = t1.n1 AND t3.n2 = t1.n2 AND t3.n3 = t1.n3 AND t3.n4 = t1.n4 AND t3.n5 = t1.n5 AND t3.n6 = t1.n6 AND t3.n7 = t1.n7 AND t3.n8 = t1.n8 AND t3.n9 = t1.n9 AND t3.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t4 WHERE t4.n1 = t1.n1 AND t4.n2 = t1.n2 AND t4.n3 = t1.n3 AND t4.n4 = t1.n4 AND t4.n5 = t1.n5 AND t4.n6 = t1.n6 AND t4.n7 = t1.n7 AND t4.n8 = t1.n8 AND t4.n9 = t1.n9 AND t4.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t5 WHERE t5.n1 = t1.n1 AND t5.n2 = t1.n2 AND t5.n3 = t1.n3 AND t5.n4 = t1.n4 AND t5.n5 = t1.n5 AND t5.n6 = t1.n6 AND t5.n7 = t1.n7 AND t5.n8 = t1.n8 AND t5.n9 = t1.n9 AND t5.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t6 WHERE t6.n1 = t1.n1 AND t6.n2 = t1.n2 AND t6.n3 = t1.n3 AND t6.n4 = t1.n4 AND t6.n5 = t1.n5 AND t6.n6 = t1.n6 AND t6.n7 = t1.n7 AND t6.n8 = t1.n8 AND t6.n9 = t1.n9 AND t6.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t7 WHERE t7.n1 = t1.n1 AND t7.n2 = t1.n2 AND t7.n3 = t1.n3 AND t7.n4 = t1.n4 AND t7.n5 = t1.n5 AND t7.n6 = t1.n6 AND t7.n7 = t1.n7 AND t7.n8 = t1.n8 AND t7.n9 = t1.n9 AND t7.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t8 WHERE t8.n1 = t1.n1 AND t8.n2 = t1.n2 AND t8.n3 = t1.n3 AND t8.n4 = t1.n4 AND t8.n5 = t1.n5 AND t8.n6 = t1.n6 AND t8.n7 = t1.n7 AND t8.n8 = t1.n8 AND t8.n9 = t1.n9 AND t8.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t9 WHERE t9.n1 = t1.n1 AND t9.n2 = t1.n2 AND t9.n3 = t1.n3 AND t9.n4 = t1.n4 AND t9.n5 = t1.n5 AND t9.n6 = t1.n6 AND t9.n7 = t1.n7 AND t9.n8 = t1.n8 AND t9.n9 = t1.n9 AND t9.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t10 WHERE t10.n1 = t1.n1 AND t10.n2 = t1.n2 AND t10.n3 = t1.n3 AND t10.n4 = t1.n4 AND t10.n5 = t1.n5 AND t10.n6 = t1.n6 AND t10.n7 = t1.n7 AND t10.n8 = t1.n8 AND t10.n9 = t1.n9 AND t10.n10 = t1.n10);

PAUSE

ALTER SYSTEM FLUSH SHARED_POOL;

ALTER SESSION SET use_stored_outlines = TRUE;

execute dbms_monitor.session_trace_enable

SELECT  count(*)
FROM t1
WHERE t1.n1 = 1 AND n2 = 2 AND n3 = 3 AND n4 = 4 AND n5 = 5 AND n6 = 6 AND n7 = 7 AND n8 = 8 AND n9 = 9 AND n10 = 10
AND EXISTS (SELECT 1 FROM t2 WHERE t2.n1 = t1.n1 AND t2.n2 = t1.n2 AND t2.n3 = t1.n3 AND t2.n4 = t1.n4 AND t2.n5 = t1.n5 AND t2.n6 = t1.n6 AND t2.n7 = t1.n7 AND t2.n8 = t1.n8 AND t2.n9 = t1.n9 AND t2.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t3 WHERE t3.n1 = t1.n1 AND t3.n2 = t1.n2 AND t3.n3 = t1.n3 AND t3.n4 = t1.n4 AND t3.n5 = t1.n5 AND t3.n6 = t1.n6 AND t3.n7 = t1.n7 AND t3.n8 = t1.n8 AND t3.n9 = t1.n9 AND t3.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t4 WHERE t4.n1 = t1.n1 AND t4.n2 = t1.n2 AND t4.n3 = t1.n3 AND t4.n4 = t1.n4 AND t4.n5 = t1.n5 AND t4.n6 = t1.n6 AND t4.n7 = t1.n7 AND t4.n8 = t1.n8 AND t4.n9 = t1.n9 AND t4.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t5 WHERE t5.n1 = t1.n1 AND t5.n2 = t1.n2 AND t5.n3 = t1.n3 AND t5.n4 = t1.n4 AND t5.n5 = t1.n5 AND t5.n6 = t1.n6 AND t5.n7 = t1.n7 AND t5.n8 = t1.n8 AND t5.n9 = t1.n9 AND t5.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t6 WHERE t6.n1 = t1.n1 AND t6.n2 = t1.n2 AND t6.n3 = t1.n3 AND t6.n4 = t1.n4 AND t6.n5 = t1.n5 AND t6.n6 = t1.n6 AND t6.n7 = t1.n7 AND t6.n8 = t1.n8 AND t6.n9 = t1.n9 AND t6.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t7 WHERE t7.n1 = t1.n1 AND t7.n2 = t1.n2 AND t7.n3 = t1.n3 AND t7.n4 = t1.n4 AND t7.n5 = t1.n5 AND t7.n6 = t1.n6 AND t7.n7 = t1.n7 AND t7.n8 = t1.n8 AND t7.n9 = t1.n9 AND t7.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t8 WHERE t8.n1 = t1.n1 AND t8.n2 = t1.n2 AND t8.n3 = t1.n3 AND t8.n4 = t1.n4 AND t8.n5 = t1.n5 AND t8.n6 = t1.n6 AND t8.n7 = t1.n7 AND t8.n8 = t1.n8 AND t8.n9 = t1.n9 AND t8.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t9 WHERE t9.n1 = t1.n1 AND t9.n2 = t1.n2 AND t9.n3 = t1.n3 AND t9.n4 = t1.n4 AND t9.n5 = t1.n5 AND t9.n6 = t1.n6 AND t9.n7 = t1.n7 AND t9.n8 = t1.n8 AND t9.n9 = t1.n9 AND t9.n10 = t1.n10)
AND EXISTS (SELECT 1 FROM t10 WHERE t10.n1 = t1.n1 AND t10.n2 = t1.n2 AND t10.n3 = t1.n3 AND t10.n4 = t1.n4 AND t10.n5 = t1.n5 AND t10.n6 = t1.n6 AND t10.n7 = t1.n7 AND t10.n8 = t1.n8 AND t10.n9 = t1.n9 AND t10.n10 = t1.n10);

execute dbms_monitor.session_trace_disable

PAUSE

REM
REM Cleanup
REM

DROP OUTLINE o;

BEGIN
  FOR i IN 1..10 LOOP
    BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE t' || i;
      EXECUTE IMMEDIATE 'PURGE TABLE t' || i;
    EXCEPTION
      WHEN OTHERS THEN NULL;
    END;
  END LOOP;
END;
/
