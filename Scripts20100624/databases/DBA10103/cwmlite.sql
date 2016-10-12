set echo on
spool helicon:/u00/app/oracle/admin/DBA10103/scripts/cwmlite.log
connect SYS/&&sysPassword as SYSDBA
@/u00/app/oracle/product/10.1.0.3/olap/admin/olap.sql SYSAUX TEMP;
spool off
