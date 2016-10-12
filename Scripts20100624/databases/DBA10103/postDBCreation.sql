connect SYS/&&sysPassword as SYSDBA
set echo on
spool helicon:/u00/app/oracle/admin/DBA10103/scripts/postDBCreation.log
connect SYS/&&sysPassword as SYSDBA
set echo on
create spfile='/u00/app/oracle/product/10.1.0.3/dbs/spfileDBA10103.ora' FROM pfile='/u00/app/oracle/admin/DBA10103/scripts/init.ora';
shutdown immediate;
connect SYS/&&sysPassword as SYSDBA
startup ;
select 'utl_recomp_begin: ' || to_char(sysdate, 'HH:MI:SS') from dual;
execute utl_recomp.recomp_serial();
select 'utl_recomp_end: ' || to_char(sysdate, 'HH:MI:SS') from dual;
spool helicon:/u00/app/oracle/admin/DBA10103/scripts/postDBCreation.log
exit;
