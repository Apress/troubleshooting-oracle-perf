connect SYS/&&sysPassword as SYSDBA
set echo off
spool helicon:/u00/app/oracle/admin/DBA10103/scripts/emRepository.log
@/u00/app/oracle/product/10.1.0.3/sysman/admin/emdrep/sql/emreposcre /u00/app/oracle/product/10.1.0.3 SYSMAN &&sysmanPassword TEMP ON;
spool off
