connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10205/scripts/interMedia.log
@/u00/app/oracle/product/10.2.0.5/ord/im/admin/iminst.sql;
spool off
