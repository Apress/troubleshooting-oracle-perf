#!/bin/sh

mkdir /u00/app/oracle/admin/DBA9204/bdump
mkdir /u00/app/oracle/admin/DBA9204/cdump
mkdir /u00/app/oracle/admin/DBA9204/create
mkdir /u00/app/oracle/admin/DBA9204/pfile
mkdir /u00/app/oracle/admin/DBA9204/udump
mkdir /u00/app/oracle/oradata
mkdir /u00/app/oracle/product/9.2.0.4/dbs
mkdir /u01/oradata/DBA9204
setenv ORACLE_SID DBA9204
echo Add this entry in the oratab: DBA9204:/u00/app/oracle/product/9.2.0.4:Y
/u00/app/oracle/product/9.2.0.4/bin/orapwd file=/u00/app/oracle/product/9.2.0.4/dbs/orapwDBA9204 password=change_on_install
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/CreateDB.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/CreateDBFiles.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/CreateDBCatalog.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/JServer.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/ordinst.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/interMedia.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/context.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/xdb_protocol.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/spatial.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/ultraSearch.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/labelSecurity.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/odm.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/cwmlite.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/demoSchemas.sql
/u00/app/oracle/product/9.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9204/scripts/postDBCreation.sql
