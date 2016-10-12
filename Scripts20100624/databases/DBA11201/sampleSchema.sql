SET VERIFY OFF
connect "SYSTEM"/"&&systemPassword"
set echo on
spool /u00/app/oracle/admin/DBA11201/scripts/sampleSchema.log append
@/u00/app/oracle/product/11.2.0.1/demo/schema/mksample.sql &&systemPassword &&sysPassword change_on_install change_on_install change_on_install change_on_install change_on_install change_on_install EXAMPLE TEMP /u00/app/oracle/admin/DBA11201/scripts/
spool off
