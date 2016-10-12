connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9206/scripts/xdb_protocol.log
@/u00/app/oracle/product/9.2.0.6/rdbms/admin/catqm.sql change_on_install XDB TEMP;
connect SYS/change_on_install as SYSDBA
@/u00/app/oracle/product/9.2.0.6/rdbms/admin/catxdbj.sql;
connect SYS/change_on_install as SYSDBA
@/u00/app/oracle/product/9.2.0.6/rdbms/admin/catxdbdbca.sql 50923 50924;
spool off
exit;
