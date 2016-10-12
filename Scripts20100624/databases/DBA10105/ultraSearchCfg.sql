connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA10105/scripts/ultraSearchCfg.log
alter user WKSYS account unlock identified by change_on_install;
@/u00/app/oracle/product/10.1.0.5/ultrasearch/admin/wk0config.sql change_on_install (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=helicon.antognini.ch)(Port=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=DBA10105.antognini.ch))) false " ";
spool off
