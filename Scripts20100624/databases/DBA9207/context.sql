connect SYS/change_on_install as SYSDBA
set echo on
spool /u00/app/oracle/admin/DBA9207/scripts/context.log
@/u00/app/oracle/product/9.2.0.7/ctx/admin/dr0csys change_on_install DRSYS TEMP;
connect CTXSYS/change_on_install
@/u00/app/oracle/product/9.2.0.7/ctx/admin/dr0inst /u00/app/oracle/product/9.2.0.7/lib/libctxx9.so;
@/u00/app/oracle/product/9.2.0.7/ctx/admin/defaults/dr0defin.sql AMERICAN;
spool off
exit;
