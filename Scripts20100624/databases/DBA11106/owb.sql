connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11106/scripts/owb.log
@/u00/app/oracle/product/11.1.0.6/rdbms/admin/cat_owb.sql SYSAUX TEMP;
spool off
