connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10204/scripts/odm.log
@/u00/app/oracle/product/10.2.0.4/rdbms/admin/dminst.sql SYSAUX TEMP;
spool off
