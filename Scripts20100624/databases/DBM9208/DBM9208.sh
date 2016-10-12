#!/bin/sh

mkdir /u00/app/oracle/admin/DBM9208/bdump
mkdir /u00/app/oracle/admin/DBM9208/cdump
mkdir /u00/app/oracle/admin/DBM9208/create
mkdir /u00/app/oracle/admin/DBM9208/pfile
mkdir /u00/app/oracle/admin/DBM9208/udump
mkdir /u00/app/oracle/oradata
mkdir /u00/app/oracle/product/9.2.0.8/dbs
mkdir /u01/oradata/DBM9208
setenv ORACLE_SID DBM9208
echo Add this entry in the oratab: DBM9208:/u00/app/oracle/product/9.2.0.8:Y
/u00/app/oracle/product/9.2.0.8/bin/orapwd file=/u00/app/oracle/product/9.2.0.8/dbs/orapwDBM9208 password=change_on_install
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9208/scripts/CreateDB.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9208/scripts/CreateDBFiles.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9208/scripts/CreateDBCatalog.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9208/scripts/postDBCreation.sql
