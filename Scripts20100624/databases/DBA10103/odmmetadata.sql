connect SYS/&&sysPassword as SYSDBA
set echo on
spool helicon:/u00/app/oracle/admin/DBA10103/scripts/odmmetadata.log
@/u00/app/oracle/product/10.1.0.3/dm/admin/dminst1.sql SYSAUX TEMP /u00/app/oracle/product/10.1.0.3/dm/admin;
spool off
