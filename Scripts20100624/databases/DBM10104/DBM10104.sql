set verify off
PROMPT specify a password for sys as parameter 1;
DEFINE sysPassword = &1
PROMPT specify a password for system as parameter 2;
DEFINE systemPassword = &2
host /u00/app/oracle/product/10.1.0.4/bin/orapwd file=/u00/app/oracle/product/10.1.0.4/dbs/orapwDBM10104 password=&&sysPassword force=y
@/u00/app/oracle/admin/DBM10104/scripts/CreateDB.sql
@/u00/app/oracle/admin/DBM10104/scripts/CreateDBFiles.sql
@/u00/app/oracle/admin/DBM10104/scripts/CreateDBCatalog.sql
@/u00/app/oracle/admin/DBM10104/scripts/postDBCreation.sql
