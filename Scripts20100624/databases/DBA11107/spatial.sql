connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11107/scripts/spatial.log
@/u00/app/oracle/product/11.1.0.7/md/admin/mdinst.sql;
spool off
