connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11106/scripts/context.log
@/u00/app/oracle/product/11.1.0.6/ctx/admin/catctx change_on_install SYSAUX TEMP NOLOCK;
connect "CTXSYS"/"change_on_install"
@/u00/app/oracle/product/11.1.0.6/ctx/admin/defaults/dr0defin.sql "AMERICAN";
spool off
