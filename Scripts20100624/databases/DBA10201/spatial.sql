connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10201/scripts/spatial.log
@/u00/app/oracle/product/10.2.0.1/md/admin/mdinst.sql;
spool off
