connect "SYSTEM"/"&&systemPassword"
set echo on
spool /u00/app/oracle/admin/DBA11107/scripts/sampleSchema.log
@/u00/app/oracle/product/11.1.0.7/demo/schema/mksample.sql &&systemPassword &&sysPassword change_on_install change_on_install change_on_install change_on_install change_on_install change_on_install EXAMPLE TEMP /u00/app/oracle/admin/DBA11107/scripts/
spool off
