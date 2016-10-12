connect SYS/&&sysPassword as SYSDBA
set echo on
spool helicon:/u00/app/oracle/admin/DBA10103/scripts/labelSecurity.log
@/u00/app/oracle/product/10.1.0.3/rdbms/admin/catols.sql ;
connect SYS/&&sysPassword as SYSDBA
startup pfile="/u00/app/oracle/admin/DBA10103/scripts/init.ora";
spool off
