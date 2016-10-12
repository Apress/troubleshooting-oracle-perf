SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11201/scripts/postDBCreation.log append
select 'utl_recomp_begin: ' || to_char(sysdate, 'HH:MI:SS') from dual;
execute utl_recomp.recomp_serial();
select 'utl_recomp_end: ' || to_char(sysdate, 'HH:MI:SS') from dual;
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
create spfile='/u00/app/oracle/product/11.2.0.1/dbs/spfileDBA11201.ora' FROM pfile='/u00/app/oracle/admin/DBA11201/scripts/init.ora';
shutdown immediate;
connect "SYS"/"&&sysPassword" as SYSDBA
startup ;
host /u00/app/oracle/product/11.2.0.1/bin/emca -config dbcontrol db -silent -DB_UNIQUE_NAME DBA11201 -PORT 1521 -EM_HOME /u00/app/oracle/product/11.2.0.1 -LISTENER LISTENER -SERVICE_NAME DBA11201.antognini.ch -SID DBA11201 -ORACLE_HOME /u00/app/oracle/product/11.2.0.1 -HOST helicon -LISTENER_OH /u00/app/oracle/product/11.2.0.1 -LOG_FILE /u00/app/oracle/admin/DBA11201/scripts/emConfig.log;
spool off
exit;
