connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9208/scripts/labelSecurity.log
@/u00/app/oracle/product/9.2.0.8/rdbms/admin/catols.sql ;
startup pfile="/u00/app/oracle/admin/DBA9208/scripts/init.ora";
spool off
exit;
