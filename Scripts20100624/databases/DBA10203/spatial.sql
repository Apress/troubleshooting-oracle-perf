connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10203/scripts/spatial.log
@/u00/app/oracle/product/10.2.0.3/md/admin/mdinst.sql;
spool off
