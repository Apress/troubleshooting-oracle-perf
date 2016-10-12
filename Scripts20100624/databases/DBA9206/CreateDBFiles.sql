connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9206/scripts/CreateDBFiles.log
CREATE TABLESPACE "CWMLITE" LOGGING DATAFILE '/u01/oradata/DBA9206/cwmlite01.dbf' SIZE 20M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO ;
CREATE TABLESPACE "DRSYS" LOGGING DATAFILE '/u01/oradata/DBA9206/drsys01.dbf' SIZE 20M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO ;
CREATE TABLESPACE "EXAMPLE" LOGGING DATAFILE '/u01/oradata/DBA9206/example01.dbf' SIZE 120M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO ;
CREATE TABLESPACE "ODM" LOGGING DATAFILE '/u01/oradata/DBA9206/odm01.dbf' SIZE 20M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO ;
CREATE TABLESPACE "USERS" LOGGING DATAFILE '/u01/oradata/DBA9206/users01.dbf' SIZE 25M REUSE AUTOEXTEND ON NEXT  1280K MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO ;
CREATE TABLESPACE "XDB" LOGGING DATAFILE '/u01/oradata/DBA9206/xdb01.dbf' SIZE 20M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  AUTO ;
spool off
exit;