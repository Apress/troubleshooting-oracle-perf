set echo on
spool /u00/app/oracle/admin/DBA9208/scripts/cwmlite.log
connect SYS/change_on_install as SYSDBA
@/u00/app/oracle/product/9.2.0.8/olap/admin/olap.sql DBA9208;
connect SYS/change_on_install as SYSDBA
@/u00/app/oracle/product/9.2.0.8/cwmlite/admin/oneinstl.sql CWMLITE TEMP;
spool off
exit;
