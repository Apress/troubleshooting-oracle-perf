connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBM9207/scripts/CreateDBCatalog.log
@/u00/app/oracle/product/9.2.0.7/rdbms/admin/catalog.sql;
@/u00/app/oracle/product/9.2.0.7/rdbms/admin/catexp7.sql;
@/u00/app/oracle/product/9.2.0.7/rdbms/admin/catblock.sql;
@/u00/app/oracle/product/9.2.0.7/rdbms/admin/catproc.sql;
@/u00/app/oracle/product/9.2.0.7/rdbms/admin/catoctk.sql;
@/u00/app/oracle/product/9.2.0.7/rdbms/admin/owminst.plb;
connect SYSTEM/manager
@/u00/app/oracle/product/9.2.0.7/sqlplus/admin/pupbld.sql;
connect SYSTEM/manager
set echo on
spool /u00/app/oracle/admin/DBM9207/scripts/sqlPlusHelp.log
@/u00/app/oracle/product/9.2.0.7/sqlplus/admin/help/hlpbld.sql helpus.sql;
spool off
spool off
exit;
