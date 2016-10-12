connect SYS/&&sysPassword as SYSDBA
set echo on
spool helicon:/u00/app/oracle/admin/DBA10103/scripts/context.log
@/u00/app/oracle/product/10.1.0.3/ctx/admin/catctx change_on_install SYSAUX TEMP NOLOCK;
connect CTXSYS/change_on_install
@/u00/app/oracle/product/10.1.0.3/ctx/admin/defaults/dr0defin.sql AMERICAN;
spool off
