connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10202/scripts/spatial.log
@/u00/app/oracle/product/10.2.0.2/md/admin/mdinst.sql;
spool off
