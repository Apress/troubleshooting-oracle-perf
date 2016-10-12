connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10202/scripts/xdb_protocol.log
@/u00/app/oracle/product/10.2.0.2/rdbms/admin/catqm.sql change_on_install SYSAUX TEMP;
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/10.2.0.2/rdbms/admin/catxdbj.sql;
@/u00/app/oracle/product/10.2.0.2/rdbms/admin/catrul.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/10.2.0.2/rdbms/admin/catxdbdbca.sql 51023 51024;
spool off
