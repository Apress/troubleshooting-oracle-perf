set verify off
PROMPT specify a password for sys as parameter 1;
DEFINE sysPassword = &1
PROMPT specify a password for system as parameter 2;
DEFINE systemPassword = &2
host /u00/app/oracle/product/11.1.0.7/bin/orapwd file=/u00/app/oracle/product/11.1.0.7/dbs/orapwDBM11107 password=&&sysPassword force=y
@/u00/app/oracle/admin/DBM11107/scripts/CreateDB.sql
@/u00/app/oracle/admin/DBM11107/scripts/CreateDBFiles.sql
@/u00/app/oracle/admin/DBM11107/scripts/CreateDBCatalog.sql
@/u00/app/oracle/admin/DBM11107/scripts/lockAccount.sql
@/u00/app/oracle/admin/DBM11107/scripts/postDBCreation.sql
