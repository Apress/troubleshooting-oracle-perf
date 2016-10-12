connect "SYS"/"&&sysPassword" as SYSDBA
set echo off
spool /u00/app/oracle/admin/DBA11107/scripts/emRepository.log
@/u00/app/oracle/product/11.1.0.7/sysman/admin/emdrep/sql/emreposcre /u00/app/oracle/product/11.1.0.7 SYSMAN &&sysmanPassword TEMP ON;
WHENEVER SQLERROR CONTINUE;
spool off
