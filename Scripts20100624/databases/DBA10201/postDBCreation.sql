connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10201/scripts/postDBCreation.log
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
create spfile='/u00/app/oracle/product/10.2.0.1/dbs/spfileDBA10201.ora' FROM pfile='/u00/app/oracle/admin/DBA10201/scripts/init.ora';
shutdown immediate;
connect "SYS"/"&&sysPassword" as SYSDBA
startup ;
alter user SYSMAN identified by "&&sysmanPassword" account unlock;
alter user DBSNMP identified by "&&dbsnmpPassword" account unlock;
select 'utl_recomp_begin: ' || to_char(sysdate, 'HH:MI:SS') from dual;
execute utl_recomp.recomp_serial();
select 'utl_recomp_end: ' || to_char(sysdate, 'HH:MI:SS') from dual;
host /u00/app/oracle/product/10.2.0.1/bin/emca -config dbcontrol db -silent -DB_UNIQUE_NAME DBA10201 -PORT 1521 -EM_HOME /u00/app/oracle/product/10.2.0.1 -LISTENER LISTENER -SERVICE_NAME DBA10201.antognini.ch -SYS_PWD &&sysPassword -SID DBA10201 -ORACLE_HOME /u00/app/oracle/product/10.2.0.1 -DBSNMP_PWD &&dbsnmpPassword -HOST helicon.antognini.ch -LISTENER_OH /u00/app/oracle/product/10.2.0.1 -LOG_FILE /u00/app/oracle/admin/DBA10201/scripts/emConfig.log -SYSMAN_PWD &&sysmanPassword;
spool /u00/app/oracle/admin/DBA10201/scripts/postDBCreation.log
exit;
