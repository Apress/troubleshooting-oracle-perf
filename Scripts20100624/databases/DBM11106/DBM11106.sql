set verify off
PROMPT specify a password for sys as parameter 1;
DEFINE sysPassword = &1
PROMPT specify a password for system as parameter 2;
DEFINE systemPassword = &2
host /u00/app/oracle/product/11.1.0.6/bin/orapwd file=/u00/app/oracle/product/11.1.0.6/dbs/orapwDBM11106 password=&&sysPassword force=y
@/u00/app/oracle/admin/DBM11106/scripts/CreateDB.sql
@/u00/app/oracle/admin/DBM11106/scripts/CreateDBFiles.sql
@/u00/app/oracle/admin/DBM11106/scripts/CreateDBCatalog.sql
@/u00/app/oracle/admin/DBM11106/scripts/lockAccount.sql
@/u00/app/oracle/admin/DBM11106/scripts/postDBCreation.sql
