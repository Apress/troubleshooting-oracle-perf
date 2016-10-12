connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9208/scripts/CreateDBCatalog.log
@/u00/app/oracle/product/9.2.0.8/rdbms/admin/catalog.sql;
@/u00/app/oracle/product/9.2.0.8/rdbms/admin/catexp7.sql;
@/u00/app/oracle/product/9.2.0.8/rdbms/admin/catblock.sql;
@/u00/app/oracle/product/9.2.0.8/rdbms/admin/catproc.sql;
@/u00/app/oracle/product/9.2.0.8/rdbms/admin/catoctk.sql;
@/u00/app/oracle/product/9.2.0.8/rdbms/admin/owminst.plb;
connect SYSTEM/manager
@/u00/app/oracle/product/9.2.0.8/sqlplus/admin/pupbld.sql;
connect SYSTEM/manager
set echo on
spool /u00/app/oracle/admin/DBA9208/scripts/sqlPlusHelp.log
@/u00/app/oracle/product/9.2.0.8/sqlplus/admin/help/hlpbld.sql helpus.sql;
spool off
spool off
exit;
