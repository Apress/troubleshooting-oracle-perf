connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10204/scripts/interMedia.log
@/u00/app/oracle/product/10.2.0.4/ord/im/admin/iminst.sql;
spool off
