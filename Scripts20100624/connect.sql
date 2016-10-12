SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM Script......: connect.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script is called by all other scripts to open a
REM               connection.
REM Notes.......: The user connecting the database must be a DBA.
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM 07.03.2009 Added DBM11107 and DBA11107
REM 24.06.2010 Added DBM10205, DBA10205, DBM11201 and DBA11201
REM ***************************************************************************
SET ECHO ON

REM CONNECT /@dbm9204.antognini.ch
REM CONNECT /@dba9204.antognini.ch
REM CONNECT /@dbm9206.antognini.ch
REM CONNECT /@dba9206.antognini.ch
REM CONNECT /@dbm9207.antognini.ch
REM CONNECT /@dba9207.antognini.ch
REM CONNECT /@dbm9208.antognini.ch
REM CONNECT /@dba9208.antognini.ch
REM CONNECT /@dbm10103.antognini.ch
REM CONNECT /@dba10103.antognini.ch
REM CONNECT /@dbm10104.antognini.ch
REM CONNECT /@dba10104.antognini.ch
REM CONNECT /@dbm10105.antognini.ch
REM CONNECT /@dba10105.antognini.ch
REM CONNECT /@dbm10201.antognini.ch
REM CONNECT /@dba10201.antognini.ch
REM CONNECT /@dbm10202.antognini.ch
REM CONNECT /@dba10202.antognini.ch
REM CONNECT /@dbm10203.antognini.ch
REM CONNECT /@dba10203.antognini.ch
REM CONNECT /@dbm10204.antognini.ch
REM CONNECT /@dba10204.antognini.ch
REM CONNECT /@dbm10205.antognini.ch
REM CONNECT /@dba10205.antognini.ch
REM CONNECT /@dbm11106.antognini.ch
REM CONNECT /@dba11106.antognini.ch
REM CONNECT /@dbm11107.antognini.ch
REM CONNECT /@dba11107.antognini.ch
REM CONNECT cha/cha@dbm11201.antognini.ch
REM CONNECT cha/cha@dba11201.antognini.ch
CONNECT &user/&password@&service
REM CONNECT /

REM
REM Display working environment
REM

SELECT user, instance_name, host_name
FROM v$instance;

SELECT *
FROM v$version
WHERE rownum = 1;
