set echo on
spool /u00/app/oracle/admin/DBA9204/scripts/cwmlite.log
connect SYS/change_on_install as SYSDBA
@/u00/app/oracle/product/9.2.0.4/olap/admin/olap.sql DBA9204;
connect SYS/change_on_install as SYSDBA
@/u00/app/oracle/product/9.2.0.4/cwmlite/admin/oneinstl.sql CWMLITE TEMP;
spool off
exit;
