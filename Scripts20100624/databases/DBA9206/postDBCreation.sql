connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9206/scripts/postDBCreation.log
@/u00/app/oracle/product/9.2.0.6/rdbms/admin/utlrp.sql;
shutdown ;
connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9206/scripts/postDBCreation.log
create spfile='/u00/app/oracle/product/9.2.0.6/dbs/spfileDBA9206.ora' FROM pfile='/u00/app/oracle/admin/DBA9206/scripts/init.ora';
startup ;
exit;
