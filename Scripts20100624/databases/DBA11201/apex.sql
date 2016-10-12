SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11201/scripts/apex.log append
@/u00/app/oracle/product/11.2.0.1/apex/catapx.sql change_on_install SYSAUX SYSAUX TEMP /i/ NONE;
spool off
