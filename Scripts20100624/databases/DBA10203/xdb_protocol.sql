connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10203/scripts/xdb_protocol.log
@/u00/app/oracle/product/10.2.0.3/rdbms/admin/catqm.sql change_on_install SYSAUX TEMP;
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/10.2.0.3/rdbms/admin/catxdbj.sql;
@/u00/app/oracle/product/10.2.0.3/rdbms/admin/catrul.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/10.2.0.3/rdbms/admin/catxdbdbca.sql 51025 51026;
spool off
