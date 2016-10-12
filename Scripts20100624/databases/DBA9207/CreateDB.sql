connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9207/scripts/CreateDB.log
startup nomount pfile="/u00/app/oracle/admin/DBA9207/scripts/init.ora";
CREATE DATABASE DBA9207
MAXINSTANCES 1
MAXLOGHISTORY 1
MAXLOGFILES 5
MAXLOGMEMBERS 3
MAXDATAFILES 100
DATAFILE '/u01/oradata/DBA9207/system01.dbf' SIZE 250M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
EXTENT MANAGEMENT LOCAL
DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE '/u01/oradata/DBA9207/temp01.dbf' SIZE 40M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED
UNDO TABLESPACE "UNDOTBS1" DATAFILE '/u01/oradata/DBA9207/undotbs01.dbf' SIZE 200M REUSE AUTOEXTEND ON NEXT  5120K MAXSIZE UNLIMITED
CHARACTER SET WE8ISO8859P15
NATIONAL CHARACTER SET AL16UTF16
LOGFILE GROUP 1 ('/u01/oradata/DBA9207/redo01.dbf') SIZE 102400K,
GROUP 2 ('/u01/oradata/DBA9207/redo02.dbf') SIZE 102400K,
GROUP 3 ('/u01/oradata/DBA9207/redo03.dbf') SIZE 102400K;
spool off
exit;
