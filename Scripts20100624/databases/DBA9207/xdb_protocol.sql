connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9207/scripts/xdb_protocol.log
@/u00/app/oracle/product/9.2.0.7/rdbms/admin/catqm.sql change_on_install XDB TEMP;
connect SYS/change_on_install as SYSDBA
@/u00/app/oracle/product/9.2.0.7/rdbms/admin/catxdbj.sql;
connect SYS/change_on_install as SYSDBA
@/u00/app/oracle/product/9.2.0.7/rdbms/admin/catxdbdbca.sql 50927 50928;
spool off
exit;
