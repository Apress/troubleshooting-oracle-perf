connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10203/scripts/ordinst.log
@/u00/app/oracle/product/10.2.0.3/ord/admin/ordinst.sql SYSAUX SYSAUX;
spool off
