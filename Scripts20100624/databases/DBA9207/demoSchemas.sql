spool /u00/app/oracle/admin/DBA9207/scripts/demoSchemas.log
connect SYSTEM/manager
@/u00/app/oracle/product/9.2.0.7/demo/schema/human_resources/hr_main.sql change_on_install EXAMPLE TEMP change_on_install /u00/app/oracle/admin/DBA9207/scripts/;
connect SYSTEM/manager
@/u00/app/oracle/product/9.2.0.7/demo/schema/order_entry/oe_main.sql change_on_install EXAMPLE TEMP change_on_install change_on_install /u00/app/oracle/admin/DBA9207/scripts/;
connect SYSTEM/manager
@/u00/app/oracle/product/9.2.0.7/demo/schema/product_media/pm_main.sql change_on_install EXAMPLE TEMP change_on_install change_on_install /u00/app/oracle/product/9.2.0.7/demo/schema/product_media/ /u00/app/oracle/admin/DBA9207/scripts/ /u00/app/oracle/product/9.2.0.7/demo/schema/product_media/;
connect SYSTEM/manager
@/u00/app/oracle/product/9.2.0.7/demo/schema/sales_history/sh_main.sql change_on_install EXAMPLE TEMP change_on_install /u00/app/oracle/product/9.2.0.7/demo/schema/sales_history/ /u00/app/oracle/admin/DBA9207/scripts/;
@/u00/app/oracle/product/9.2.0.7/demo/schema/sales_history/sh_olp_c.sql;
connect SYSTEM/manager
@/u00/app/oracle/product/9.2.0.7/demo/schema/shipping/qs_main.sql change_on_install EXAMPLE TEMP manager change_on_install change_on_install /u00/app/oracle/admin/DBA9207/scripts/;
spool off
exit;
