SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11201/scripts/xdb_protocol.log append
@/u00/app/oracle/product/11.2.0.1/rdbms/admin/catqm.sql change_on_install SYSAUX TEMP;
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/11.2.0.1/rdbms/admin/catxdbj.sql;
@/u00/app/oracle/product/11.2.0.1/rdbms/admin/catrul.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/11.2.0.1/rdbms/admin/catxdbdbca.sql 51121 51122;
spool off
