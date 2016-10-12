connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10203/scripts/ultraSearch.log
@/u00/app/oracle/product/10.2.0.3/ultrasearch/admin/wk0install.sql SYS &&sysPassword change_on_install SYSAUX TEMP "" PORTAL false;
spool off
