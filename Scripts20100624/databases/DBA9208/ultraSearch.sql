connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9208/scripts/ultraSearch.log
@/u00/app/oracle/product/9.2.0.8/ultrasearch/admin/wk0install.sql SYS change_on_install change_on_install DRSYS TEMP "" PORTAL false;
spool off
exit;
