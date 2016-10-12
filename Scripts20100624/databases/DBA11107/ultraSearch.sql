connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11107/scripts/ultraSearch.log
@/u00/app/oracle/product/11.1.0.7/ultrasearch/admin/wk0install.sql SYS &&sysPassword change_on_install SYSAUX TEMP "" PORTAL false;
spool off
