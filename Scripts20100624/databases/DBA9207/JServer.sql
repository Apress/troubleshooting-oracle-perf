connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9207/scripts/JServer.log
@/u00/app/oracle/product/9.2.0.7/javavm/install/initjvm.sql;
@/u00/app/oracle/product/9.2.0.7/xdk/admin/initxml.sql;
@/u00/app/oracle/product/9.2.0.7/xdk/admin/xmlja.sql;
@/u00/app/oracle/product/9.2.0.7/rdbms/admin/catjava.sql;
spool off
exit;
