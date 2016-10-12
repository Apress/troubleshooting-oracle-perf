connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10105/scripts/labelSecurity.log
@/u00/app/oracle/product/10.1.0.5/rdbms/admin/catols.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
startup pfile="/u00/app/oracle/admin/DBA10105/scripts/init.ora";
spool off
