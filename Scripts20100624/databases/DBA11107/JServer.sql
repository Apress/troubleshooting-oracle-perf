connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11107/scripts/JServer.log
@/u00/app/oracle/product/11.1.0.7/javavm/install/initjvm.sql;
@/u00/app/oracle/product/11.1.0.7/xdk/admin/initxml.sql;
@/u00/app/oracle/product/11.1.0.7/xdk/admin/xmlja.sql;
@/u00/app/oracle/product/11.1.0.7/rdbms/admin/catjava.sql;
@/u00/app/oracle/product/11.1.0.7/rdbms/admin/catexf.sql;
spool off
