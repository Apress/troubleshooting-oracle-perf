connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBM9204/scripts/postDBCreation.log
@/u00/app/oracle/product/9.2.0.4/rdbms/admin/utlrp.sql;
shutdown ;
connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBM9204/scripts/postDBCreation.log
create spfile='/u00/app/oracle/product/9.2.0.4/dbs/spfileDBM9204.ora' FROM pfile='/u00/app/oracle/admin/DBM9204/scripts/init.ora';
startup ;
exit;
