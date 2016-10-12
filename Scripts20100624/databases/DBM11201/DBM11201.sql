set verify off
ACCEPT sysPassword CHAR PROMPT 'Enter new password for SYS: ' HIDE
ACCEPT systemPassword CHAR PROMPT 'Enter new password for SYSTEM: ' HIDE
host /u00/app/oracle/product/11.2.0.1/bin/orapwd file=/u00/app/oracle/product/11.2.0.1/dbs/orapwDBM11201 force=y
@/u00/app/oracle/admin/DBM11201/scripts/CreateDB.sql
@/u00/app/oracle/admin/DBM11201/scripts/CreateDBFiles.sql
@/u00/app/oracle/admin/DBM11201/scripts/CreateDBCatalog.sql
@/u00/app/oracle/admin/DBM11201/scripts/lockAccount.sql
@/u00/app/oracle/admin/DBM11201/scripts/postDBCreation.sql
