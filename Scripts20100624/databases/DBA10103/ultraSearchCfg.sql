connect SYS/&&sysPassword as SYSDBA
set echo on
spool helicon:/u00/app/oracle/admin/DBA10103/scripts/ultraSearchCfg.log
alter user WKSYS account unlock identified by change_on_install;
@/u00/app/oracle/product/10.1.0.3/ultrasearch/admin/wk0config.sql change_on_install (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=helicon.antognini.ch)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=DBA10103.antognini.ch))) false " ";
spool off
