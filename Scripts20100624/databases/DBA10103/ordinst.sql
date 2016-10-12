connect SYS/&&sysPassword as SYSDBA
set echo on
spool helicon:/u00/app/oracle/admin/DBA10103/scripts/ordinst.log
@/u00/app/oracle/product/10.1.0.3/ord/admin/ordinst.sql SYSAUX SYSAUX;
spool off
