set echo on
spool /u00/app/oracle/admin/DBA10104/scripts/cwmlite.log
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/10.1.0.4/olap/admin/olap.sql SYSAUX TEMP;
spool off
