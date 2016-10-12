connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBM10201/scripts/CreateDB.log
startup nomount pfile="/u00/app/oracle/admin/DBM10201/scripts/init.ora";
CREATE DATABASE "DBM10201"
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 100
DATAFILE '/u01/oradata/DBM10201/system01.dbf' SIZE 300M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
EXTENT MANAGEMENT LOCAL
SYSAUX DATAFILE '/u01/oradata/DBM10201/sysaux01.dbf' SIZE 120M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
SMALLFILE DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE '/u01/oradata/DBM10201/temp01.dbf' SIZE 20M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED
SMALLFILE UNDO TABLESPACE "UNDOTBS1" DATAFILE '/u01/oradata/DBM10201/undotbs01.dbf' SIZE 200M REUSE AUTOEXTEND ON NEXT  5120K MAXSIZE UNLIMITED
CHARACTER SET WE8ISO8859P15
NATIONAL CHARACTER SET AL16UTF16
LOGFILE GROUP 1 ('/u01/oradata/DBM10201/redo01.dbf') SIZE 51200K,
GROUP 2 ('/u01/oradata/DBM10201/redo02.dbf') SIZE 51200K,
GROUP 3 ('/u01/oradata/DBM10201/redo03.dbf') SIZE 51200K
USER SYS IDENTIFIED BY "&&sysPassword" USER SYSTEM IDENTIFIED BY "&&systemPassword";
spool off
