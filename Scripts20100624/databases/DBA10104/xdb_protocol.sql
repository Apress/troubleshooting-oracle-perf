connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10104/scripts/xdb_protocol.log
@/u00/app/oracle/product/10.1.0.4/rdbms/admin/catqm.sql change_on_install SYSAUX TEMP;
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/10.1.0.4/rdbms/admin/catxdbj.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/10.1.0.4/rdbms/admin/catxdbdbca.sql 51013 51014;
spool off
