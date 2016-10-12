SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: sql_trace_trigger.sql
REM Author......: Christian Antognini
REM Date........: June 2010
REM Description.: You can use this script to create a logon trigger that 
REM               enables SQL trace.
REM Notes.......: This script works as of 10g only. To use it with later
REM               releases use event 10046 instead of the dbms_monitor package.
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
REM The trigger will enable SQL trace for each user having the
REM following role enabled while connecting the database.
REM

CREATE ROLE sql_trace;

PAUSE

CREATE OR REPLACE TRIGGER enable_sql_trace AFTER LOGON ON DATABASE
BEGIN
  IF (dbms_session.is_role_enabled('SQL_TRACE'))
  THEN
    EXECUTE IMMEDIATE 'ALTER SESSION SET timed_statistics = TRUE';
    EXECUTE IMMEDIATE 'ALTER SESSION SET max_dump_file_size = unlimited';
    dbms_monitor.session_trace_enable;
  END IF;
END;
/
