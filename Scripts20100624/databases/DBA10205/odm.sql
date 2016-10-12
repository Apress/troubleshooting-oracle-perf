connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10205/scripts/odm.log
@/u00/app/oracle/product/10.2.0.5/rdbms/admin/dminst.sql SYSAUX TEMP;
spool off
