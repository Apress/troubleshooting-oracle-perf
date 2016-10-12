connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10104/scripts/spatial.log
@/u00/app/oracle/product/10.1.0.4/md/admin/mdinst.sql;
spool off
