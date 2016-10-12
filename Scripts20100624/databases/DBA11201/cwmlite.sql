SET VERIFY OFF
set echo on
spool /u00/app/oracle/admin/DBA11201/scripts/cwmlite.log append
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/11.2.0.1/olap/admin/olap.sql SYSAUX TEMP;
spool off
