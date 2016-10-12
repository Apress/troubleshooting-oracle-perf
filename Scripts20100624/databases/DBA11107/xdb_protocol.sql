connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11107/scripts/xdb_protocol.log
@/u00/app/oracle/product/11.1.0.7/rdbms/admin/catqm.sql change_on_install SYSAUX TEMP;
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/11.1.0.7/rdbms/admin/catxdbj.sql;
@/u00/app/oracle/product/11.1.0.7/rdbms/admin/catrul.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
@/u00/app/oracle/product/11.1.0.7/rdbms/admin/catxdbdbca.sql 51113 51114;
spool off
