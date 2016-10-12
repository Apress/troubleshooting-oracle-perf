set echo on
spool /u00/app/oracle/admin/DBA11106/scripts/cwmlite.log
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/11.1.0.6/olap/admin/olap.sql SYSAUX TEMP;
spool off
