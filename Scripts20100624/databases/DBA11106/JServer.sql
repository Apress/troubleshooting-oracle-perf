connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11106/scripts/JServer.log
@/u00/app/oracle/product/11.1.0.6/javavm/install/initjvm.sql;
@/u00/app/oracle/product/11.1.0.6/xdk/admin/initxml.sql;
@/u00/app/oracle/product/11.1.0.6/xdk/admin/xmlja.sql;
@/u00/app/oracle/product/11.1.0.6/rdbms/admin/catjava.sql;
@/u00/app/oracle/product/11.1.0.6/rdbms/admin/catexf.sql;
spool off
