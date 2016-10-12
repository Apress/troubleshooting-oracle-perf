connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9204/scripts/ordinst.log
@/u00/app/oracle/product/9.2.0.4/ord/admin/ordinst.sql;
spool off
exit;
