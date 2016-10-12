connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10205/scripts/JServer.log
@/u00/app/oracle/product/10.2.0.5/javavm/install/initjvm.sql;
@/u00/app/oracle/product/10.2.0.5/xdk/admin/initxml.sql;
@/u00/app/oracle/product/10.2.0.5/xdk/admin/xmlja.sql;
@/u00/app/oracle/product/10.2.0.5/rdbms/admin/catjava.sql;
@/u00/app/oracle/product/10.2.0.5/rdbms/admin/catexf.sql;
spool off
