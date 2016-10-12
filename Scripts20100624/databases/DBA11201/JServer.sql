SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11201/scripts/JServer.log append
@/u00/app/oracle/product/11.2.0.1/javavm/install/initjvm.sql;
@/u00/app/oracle/product/11.2.0.1/xdk/admin/initxml.sql;
@/u00/app/oracle/product/11.2.0.1/xdk/admin/xmlja.sql;
@/u00/app/oracle/product/11.2.0.1/rdbms/admin/catjava.sql;
@/u00/app/oracle/product/11.2.0.1/rdbms/admin/catexf.sql;
spool off
