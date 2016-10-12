connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10104/scripts/odm.log
@/u00/app/oracle/product/10.1.0.4/dm/admin/dminst2.sql;
spool off
