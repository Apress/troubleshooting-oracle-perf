connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11107/scripts/interMedia.log
@/u00/app/oracle/product/11.1.0.7/ord/im/admin/iminst.sql;
spool off
