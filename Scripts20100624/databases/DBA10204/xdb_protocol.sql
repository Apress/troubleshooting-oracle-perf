connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10204/scripts/xdb_protocol.log
@/u00/app/oracle/product/10.2.0.4/rdbms/admin/catqm.sql change_on_install SYSAUX TEMP;
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/10.2.0.4/rdbms/admin/catxdbj.sql;
@/u00/app/oracle/product/10.2.0.4/rdbms/admin/catrul.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/10.2.0.4/rdbms/admin/catxdbdbca.sql 51027 51028;
spool off
