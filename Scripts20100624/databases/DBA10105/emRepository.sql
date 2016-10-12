connect "SYS"/"&&sysPassword" as SYSDBA
set echo off
spool /u00/app/oracle/admin/DBA10105/scripts/emRepository.log
@/u00/app/oracle/product/10.1.0.5/sysman/admin/emdrep/sql/emreposcre /u00/app/oracle/product/10.1.0.5 SYSMAN &&sysmanPassword TEMP ON;
spool off
