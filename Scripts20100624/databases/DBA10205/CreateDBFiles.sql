connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10205/scripts/CreateDBFiles.log
CREATE SMALLFILE TABLESPACE "EXAMPLE" LOGGING DATAFILE '/u01/oradata/DBA10205/example01.dbf' SIZE 150M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO;
CREATE SMALLFILE TABLESPACE "USERS" LOGGING DATAFILE '/u01/oradata/DBA10205/users01.dbf' SIZE 5M REUSE AUTOEXTEND ON NEXT  1280K MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO;
ALTER DATABASE DEFAULT TABLESPACE "USERS";
spool off