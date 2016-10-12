connect SYS/&&sysPassword as SYSDBA
set echo on
spool helicon:/u00/app/oracle/admin/DBA10103/scripts/xdb_protocol.log
@/u00/app/oracle/product/10.1.0.3/rdbms/admin/catqm.sql change_on_install SYSAUX TEMP;
connect SYS/&&sysPassword as SYSDBA
@/u00/app/oracle/product/10.1.0.3/rdbms/admin/catxdbj.sql;
connect SYS/&&sysPassword as SYSDBA
@/u00/app/oracle/product/10.1.0.3/rdbms/admin/catxdbdbca.sql 51011 51012;
spool off
