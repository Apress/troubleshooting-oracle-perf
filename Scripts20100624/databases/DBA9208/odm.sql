connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9208/scripts/odm.log
@/u00/app/oracle/product/9.2.0.8/dm/admin/dminst.sql ODM TEMP /u00/app/oracle/admin/DBA9208/scripts/;
connect SYS/change_on_install as SYSDBA
revoke AQ_ADMINISTRATOR_ROLE from ODM;
spool off
exit;
