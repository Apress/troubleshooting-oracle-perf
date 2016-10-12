connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11106/scripts/postDBCreation.log
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
create spfile='/u00/app/oracle/product/11.1.0.6/dbs/spfileDBA11106.ora' FROM pfile='/u00/app/oracle/admin/DBA11106/scripts/init.ora';
shutdown immediate;
connect "SYS"/"&&sysPassword" as SYSDBA
startup ;
alter user SYSMAN identified by "&&sysmanPassword" account unlock;
alter user DBSNMP identified by "&&dbsnmpPassword" account unlock;
select 'utl_recomp_begin: ' || to_char(sysdate, 'HH:MI:SS') from dual;
execute utl_recomp.recomp_serial();
select 'utl_recomp_end: ' || to_char(sysdate, 'HH:MI:SS') from dual;
host /u00/app/oracle/product/11.1.0.6/bin/emca -config dbcontrol db -silent -DB_UNIQUE_NAME DBA11106 -PORT 1521 -EM_HOME /u00/app/oracle/product/11.1.0.6 -LISTENER LISTENER -SERVICE_NAME DBA11106.antognini.ch -SYS_PWD &&sysPassword -SID DBA11106 -ORACLE_HOME /u00/app/oracle/product/11.1.0.6 -DBSNMP_PWD &&dbsnmpPassword -HOST helicon.antognini.ch -LISTENER_OH /u00/app/oracle/product/11.1.0.6 -LOG_FILE /u00/app/oracle/admin/DBA11106/scripts/emConfig.log -SYSMAN_PWD &&sysmanPassword;
spool /u00/app/oracle/admin/DBA11106/scripts/postDBCreation.log
exit;
