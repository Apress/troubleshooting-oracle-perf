spool /u00/app/oracle/admin/DBA9204/scripts/demoSchemas.log
connect SYSTEM/manager
@/u00/app/oracle/product/9.2.0.4/demo/schema/human_resources/hr_main.sql change_on_install EXAMPLE TEMP change_on_install /u00/app/oracle/admin/DBA9204/scripts/;
connect SYSTEM/manager
@/u00/app/oracle/product/9.2.0.4/demo/schema/order_entry/oe_main.sql change_on_install EXAMPLE TEMP change_on_install change_on_install /u00/app/oracle/admin/DBA9204/scripts/;
connect SYSTEM/manager
@/u00/app/oracle/product/9.2.0.4/demo/schema/product_media/pm_main.sql change_on_install EXAMPLE TEMP change_on_install change_on_install /u00/app/oracle/product/9.2.0.4/demo/schema/product_media/ /u00/app/oracle/admin/DBA9204/scripts/ /u00/app/oracle/product/9.2.0.4/demo/schema/product_media/;
connect SYSTEM/manager
@/u00/app/oracle/product/9.2.0.4/demo/schema/sales_history/sh_main.sql change_on_install EXAMPLE TEMP change_on_install /u00/app/oracle/product/9.2.0.4/demo/schema/sales_history/ /u00/app/oracle/admin/DBA9204/scripts/;
@/u00/app/oracle/product/9.2.0.4/demo/schema/sales_history/sh_olp_c.sql;
connect SYSTEM/manager
@/u00/app/oracle/product/9.2.0.4/demo/schema/shipping/qs_main.sql change_on_install EXAMPLE TEMP manager change_on_install change_on_install /u00/app/oracle/admin/DBA9204/scripts/;
spool off
exit;
