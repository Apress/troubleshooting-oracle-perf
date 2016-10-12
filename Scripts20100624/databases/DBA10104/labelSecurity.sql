connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10104/scripts/labelSecurity.log
@/u00/app/oracle/product/10.1.0.4/rdbms/admin/catols.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
startup pfile="/u00/app/oracle/admin/DBA10104/scripts/init.ora";
spool off
