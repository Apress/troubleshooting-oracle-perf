#!/bin/sh

mkdir /u00/app/oracle/admin/DBM9207/bdump
mkdir /u00/app/oracle/admin/DBM9207/cdump
mkdir /u00/app/oracle/admin/DBM9207/create
mkdir /u00/app/oracle/admin/DBM9207/pfile
mkdir /u00/app/oracle/admin/DBM9207/udump
mkdir /u00/app/oracle/oradata
mkdir /u00/app/oracle/product/9.2.0.7/dbs
mkdir /u01/oradata/DBM9207
setenv ORACLE_SID DBM9207
echo Add this entry in the oratab: DBM9207:/u00/app/oracle/product/9.2.0.7:Y
/u00/app/oracle/product/9.2.0.7/bin/orapwd file=/u00/app/oracle/product/9.2.0.7/dbs/orapwDBM9207 password=change_on_install
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9207/scripts/CreateDB.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9207/scripts/CreateDBFiles.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9207/scripts/CreateDBCatalog.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM9207/scripts/postDBCreation.sql
