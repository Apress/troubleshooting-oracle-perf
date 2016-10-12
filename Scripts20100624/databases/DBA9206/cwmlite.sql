set echo on
spool /u00/app/oracle/admin/DBA9206/scripts/cwmlite.log
connect SYS/change_on_install as SYSDBA
@/u00/app/oracle/product/9.2.0.6/olap/admin/olap.sql DBA9206;
connect SYS/change_on_install as SYSDBA
@/u00/app/oracle/product/9.2.0.6/cwmlite/admin/oneinstl.sql CWMLITE TEMP;
spool off
exit;
