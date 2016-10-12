connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10104/scripts/JServer.log
@/u00/app/oracle/product/10.1.0.4/javavm/install/initjvm.sql;
@/u00/app/oracle/product/10.1.0.4/xdk/admin/initxml.sql;
@/u00/app/oracle/product/10.1.0.4/xdk/admin/xmlja.sql;
@/u00/app/oracle/product/10.1.0.4/rdbms/admin/catjava.sql;
@/u00/app/oracle/product/10.1.0.4/rdbms/admin/catexf.sql;
spool off
