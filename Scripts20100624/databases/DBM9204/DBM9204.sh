#!/bin/sh

mkdir /u00/app/oracle/admin/DBM9204/bdump
mkdir /u00/app/oracle/admin/DBM9204/cdump
mkdir /u00/app/oracle/admin/DBM9204/create
mkdir /u00/app/oracle/admin/DBM9204/pfile
mkdir /u00/app/oracle/admin/DBM9204/udump
mkdir /u00/app/oracle/oradata
mkdir /u00/app/oracle/product/9.2.0.4/dbs
mkdir /u01/oradata/DBM9204
setenv ORACLE_SID DBM9204
echo Add this entry in the oratab: DBM9204:/u00/app/oracle/product/9.2.0.4:Y
/u00/app/oracle/product/9.2.0.4/bin/orapwd file=/u00/app/oracle/product/9.2.0.4/dbs/orapwDBM9204 password=change_on_install
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9204/scripts/CreateDB.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9204/scripts/CreateDBFiles.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9204/scripts/CreateDBCatalog.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9204/scripts/postDBCreation.sql
