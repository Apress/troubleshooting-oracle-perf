SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11201/scripts/labelSecurity.log append
@/u00/app/oracle/product/11.2.0.1/rdbms/admin/catols.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
startup pfile="/u00/app/oracle/admin/DBA11201/scripts/init.ora";
spool off
