SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11201/scripts/CreateDBCatalog.log append
@/u00/app/oracle/product/11.2.0.1/rdbms/admin/catalog.sql;
@/u00/app/oracle/product/11.2.0.1/rdbms/admin/catblock.sql;
@/u00/app/oracle/product/11.2.0.1/rdbms/admin/catproc.sql;
@/u00/app/oracle/product/11.2.0.1/rdbms/admin/catoctk.sql;
@/u00/app/oracle/product/11.2.0.1/rdbms/admin/owminst.plb;
connect "SYSTEM"/"&&systemPassword"
@/u00/app/oracle/product/11.2.0.1/sqlplus/admin/pupbld.sql;
connect "SYSTEM"/"&&systemPassword"
set echo on
spool /u00/app/oracle/admin/DBA11201/scripts/sqlPlusHelp.log append
@/u00/app/oracle/product/11.2.0.1/sqlplus/admin/help/hlpbld.sql helpus.sql;
spool off
spool off
