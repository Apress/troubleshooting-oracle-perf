connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10105/scripts/odmmetadata.log
@/u00/app/oracle/product/10.1.0.5/dm/admin/dminst1.sql SYSAUX TEMP /u00/app/oracle/product/10.1.0.5/dm/admin;
spool off
