connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10201/scripts/JServer.log
@/u00/app/oracle/product/10.2.0.1/javavm/install/initjvm.sql;
@/u00/app/oracle/product/10.2.0.1/xdk/admin/initxml.sql;
@/u00/app/oracle/product/10.2.0.1/xdk/admin/xmlja.sql;
@/u00/app/oracle/product/10.2.0.1/rdbms/admin/catjava.sql;
@/u00/app/oracle/product/10.2.0.1/rdbms/admin/catexf.sql;
spool off
