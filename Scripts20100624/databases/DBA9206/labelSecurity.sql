connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9206/scripts/labelSecurity.log
@/u00/app/oracle/product/9.2.0.6/rdbms/admin/catols.sql ;
startup pfile="/u00/app/oracle/admin/DBA9206/scripts/init.ora";
spool off
exit;
