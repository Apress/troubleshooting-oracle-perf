connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9207/scripts/postDBCreation.log
@/u00/app/oracle/product/9.2.0.7/rdbms/admin/utlrp.sql;
shutdown ;
connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9207/scripts/postDBCreation.log
create spfile='/u00/app/oracle/product/9.2.0.7/dbs/spfileDBA9207.ora' FROM pfile='/u00/app/oracle/admin/DBA9207/scripts/init.ora';
startup ;
exit;
