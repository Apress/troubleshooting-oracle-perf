connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9204/scripts/interMedia.log
@/u00/app/oracle/product/9.2.0.4/ord/im/admin/iminst.sql;
spool off
exit;
