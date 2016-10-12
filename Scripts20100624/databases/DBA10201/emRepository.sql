connect "SYS"/"&&sysPassword" as SYSDBA
set echo off
spool /u00/app/oracle/admin/DBA10201/scripts/emRepository.log
@/u00/app/oracle/product/10.2.0.1/sysman/admin/emdrep/sql/emreposcre /u00/app/oracle/product/10.2.0.1 SYSMAN &&sysmanPassword TEMP ON;
WHENEVER SQLERROR CONTINUE;
spool off
