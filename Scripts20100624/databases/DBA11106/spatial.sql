connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11106/scripts/spatial.log
@/u00/app/oracle/product/11.1.0.6/md/admin/mdinst.sql;
spool off
