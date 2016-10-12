connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10203/scripts/interMedia.log
@/u00/app/oracle/product/10.2.0.3/ord/im/admin/iminst.sql;
spool off
