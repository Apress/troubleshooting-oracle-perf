connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11106/scripts/apex.log
@/u00/app/oracle/product/11.1.0.6/apex/catapx.sql change_on_install SYSAUX SYSAUX TEMP /i/ NONE;
spool off
