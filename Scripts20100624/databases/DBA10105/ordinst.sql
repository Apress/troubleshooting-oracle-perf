connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10105/scripts/ordinst.log
@/u00/app/oracle/product/10.1.0.5/ord/admin/ordinst.sql SYSAUX SYSAUX;
spool off
