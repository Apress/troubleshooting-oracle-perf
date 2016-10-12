set echo on
spool /u00/app/oracle/admin/DBA10105/scripts/cwmlite.log
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/10.1.0.5/olap/admin/olap.sql SYSAUX TEMP;
spool off
