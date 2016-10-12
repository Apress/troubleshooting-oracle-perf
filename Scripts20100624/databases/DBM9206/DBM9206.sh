#!/bin/sh

mkdir /u00/app/oracle/admin/DBM9206/bdump
mkdir /u00/app/oracle/admin/DBM9206/cdump
mkdir /u00/app/oracle/admin/DBM9206/create
mkdir /u00/app/oracle/admin/DBM9206/pfile
mkdir /u00/app/oracle/admin/DBM9206/udump
mkdir /u00/app/oracle/oradata
mkdir /u00/app/oracle/product/9.2.0.6/dbs
mkdir /u01/oradata/DBM9206
setenv ORACLE_SID DBM9206
echo Add this entry in the oratab: DBM9206:/u00/app/oracle/product/9.2.0.6:Y
/u00/app/oracle/product/9.2.0.6/bin/orapwd file=/u00/app/oracle/product/9.2.0.6/dbs/orapwDBM9206 password=change_on_install
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9206/scripts/CreateDB.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9206/scripts/CreateDBFiles.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9206/scripts/CreateDBCatalog.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9206/scripts/postDBCreation.sql
