connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10205/scripts/postDBCreation.log
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
create spfile='/u00/app/oracle/product/10.2.0.5/dbs/spfileDBA10205.ora' FROM pfile='/u00/app/oracle/admin/DBA10205/scripts/init.ora';
shutdown immediate;
connect "SYS"/"&&sysPassword" as SYSDBA
startup ;
alter user SYSMAN identified by "&&sysmanPassword" account unlock;
alter user DBSNMP identified by "&&dbsnmpPassword" account unlock;
select 'utl_recomp_begin: ' || to_char(sysdate, 'HH:MI:SS') from dual;
execute utl_recomp.recomp_serial();
select 'utl_recomp_end: ' || to_char(sysdate, 'HH:MI:SS') from dual;
host /u00/app/oracle/product/10.2.0.5/bin/emca -config dbcontrol db -silent -DB_UNIQUE_NAME DBA10205 -PORT 1521 -EM_HOME /u00/app/oracle/product/10.2.0.5 -LISTENER LISTENER -SERVICE_NAME DBA10205.antognini.ch -SYS_PWD &&sysPassword -SID DBA10205 -ORACLE_HOME /u00/app/oracle/product/10.2.0.5 -DBSNMP_PWD &&dbsnmpPassword -HOST helicon -LISTENER_OH /u00/app/oracle/product/10.2.0.5 -LOG_FILE /u00/app/oracle/admin/DBA10205/scripts/emConfig.log -SYSMAN_PWD &&sysmanPassword;
spool /u00/app/oracle/admin/DBA10205/scripts/postDBCreation.log
exit;
