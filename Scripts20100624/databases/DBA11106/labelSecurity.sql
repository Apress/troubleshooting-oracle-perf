connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11106/scripts/labelSecurity.log
@/u00/app/oracle/product/11.1.0.6/rdbms/admin/catols.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
startup pfile="/u00/app/oracle/admin/DBA11106/scripts/init.ora";
spool off
