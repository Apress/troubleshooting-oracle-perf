SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA11201/scripts/context.log append
@/u00/app/oracle/product/11.2.0.1/ctx/admin/catctx change_on_install SYSAUX TEMP NOLOCK;
connect "CTXSYS"/"change_on_install"
@/u00/app/oracle/product/11.2.0.1/ctx/admin/defaults/dr0defin.sql "AMERICAN";
spool off
