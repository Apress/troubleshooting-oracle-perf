connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11107/scripts/ordinst.log
@/u00/app/oracle/product/11.1.0.7/ord/admin/ordinst.sql SYSAUX SYSAUX;
spool off
