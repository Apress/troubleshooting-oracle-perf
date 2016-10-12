SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11201/scripts/interMedia.log append
@/u00/app/oracle/product/11.2.0.1/ord/im/admin/iminst.sql;
spool off
