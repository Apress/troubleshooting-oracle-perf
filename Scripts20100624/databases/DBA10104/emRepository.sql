connect "SYS"/"&&sysPassword" as SYSDBA
set echo off
spool /u00/app/oracle/admin/DBA10104/scripts/emRepository.log
@/u00/app/oracle/product/10.1.0.4/sysman/admin/emdrep/sql/emreposcre /u00/app/oracle/product/10.1.0.4 SYSMAN &&sysmanPassword TEMP ON;
spool off
