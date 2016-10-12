connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10104/scripts/odmmetadata.log
@/u00/app/oracle/product/10.1.0.4/dm/admin/dminst1.sql SYSAUX TEMP /u00/app/oracle/product/10.1.0.4/dm/admin;
spool off
