connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBM10201/scripts/postDBCreation.log
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
create spfile='/u00/app/oracle/product/10.2.0.1/dbs/spfileDBM10201.ora' FROM pfile='/u00/app/oracle/admin/DBM10201/scripts/init.ora';
shutdown immediate;
connect "SYS"/"&&sysPassword" as SYSDBA
startup ;
select 'utl_recomp_begin: ' || to_char(sysdate, 'HH:MI:SS') from dual;
execute utl_recomp.recomp_serial();
select 'utl_recomp_end: ' || to_char(sysdate, 'HH:MI:SS') from dual;
spool /u00/app/oracle/admin/DBM10201/scripts/postDBCreation.log
exit;
