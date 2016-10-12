set echo on
spool /u00/app/oracle/admin/DBA11107/scripts/cwmlite.log
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/11.1.0.7/olap/admin/olap.sql SYSAUX TEMP;
spool off
