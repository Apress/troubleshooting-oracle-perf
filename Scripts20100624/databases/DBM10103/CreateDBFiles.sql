connect SYS/&&sysPassword as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBM10103/scripts/CreateDBFiles.log
CREATE TABLESPACE "USERS" LOGGING DATAFILE '/u01/oradata/DBM10103/users01.dbf' SIZE 5M REUSE AUTOEXTEND ON NEXT  1280K MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO ;
ALTER DATABASE DEFAULT TABLESPACE "USERS";
spool off
