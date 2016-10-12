set echo on
spool /u00/app/oracle/admin/DBA10203/scripts/cwmlite.log
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/10.2.0.3/olap/admin/olap.sql SYSAUX TEMP;
spool off
