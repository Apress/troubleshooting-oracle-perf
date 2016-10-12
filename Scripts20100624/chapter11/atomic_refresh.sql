SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: atomic_refresh.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script can be used to reproduce bug 3168840 in Oracle9i. 
REM               The bug causes refreshes not to work correctly if a single
REM               materialized view is refreshed.
REM Notes.......: -
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM 24.06.2010 Changed CTAS to avoid ORA-30009
REM ***************************************************************************

SET TERMOUT ON
SET FEEDBACK OFF
SET VERIFY OFF
SET SCAN ON

VARIABLE job NUMBER

@../connect.sql

SET ECHO ON

REM
REM Setup test environment
REM

REM Make sure that the initialization job_queue_processes is greater than 0
show parameter job

PAUSE

ALTER SESSION SET nls_date_format = 'DD.MM.YYYY HH24:MI:SS';

DROP MATERIALIZED view mv;

CREATE MATERIALIZED VIEW mv
REFRESH COMPLETE ON DEMAND 
AS
WITH
  t AS (SELECT /*+ materialize */ 1
        FROM dual
        CONNECT BY level <= 1000)
SELECT rownum AS id, rpad('*',100,'*') AS pad
FROM t, t;

PAUSE

REM
REM Refreshing a single materialized view --> bug!
REM

BEGIN
  dbms_job.submit(
    job       => :job,
    what      => 'dbms_mview.refresh(list=>''' || user || '.mv'',method=>''C'',atomic_refresh=>TRUE);',
    next_date => sysdate,
    interval  => 'sysdate+to_dsinterval(''0 00:00:01'')'
  );
  COMMIT;
END;
/

SELECT sysdate, last_date, this_date, next_date
FROM user_jobs
WHERE job = :job;

REM
REM some of the following queries should raise an error 
REM or return the value 0 instead of 1000000...
REM

SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;
SELECT count(*) FROM mv;

PAUSE

REM
REM Cleanup
REM

BEGIN
  dbms_job.remove(:job);
  COMMIT;
END;
/

REM Drop the materialized view with the following SQL statement
REM when the job is no longer running

REM DROP MATERIALIZED view mv;

SELECT * FROM dba_jobs_running WHERE job = :job;
