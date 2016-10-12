#!/bin/sh

mkdir /u00/app/oracle/admin/DBA9206/bdump
mkdir /u00/app/oracle/admin/DBA9206/cdump
mkdir /u00/app/oracle/admin/DBA9206/create
mkdir /u00/app/oracle/admin/DBA9206/pfile
mkdir /u00/app/oracle/admin/DBA9206/udump
mkdir /u00/app/oracle/product/9.2.0.6/dbs
mkdir /u01/oradata/DBA9206
setenv ORACLE_SID DBA9206
echo Add this entry in the oratab: DBA9206:/u00/app/oracle/product/9.2.0.6:Y
/u00/app/oracle/product/9.2.0.6/bin/orapwd file=/u00/app/oracle/product/9.2.0.6/dbs/orapwDBA9206 password=change_on_install
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/CreateDB.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/CreateDBFiles.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/CreateDBCatalog.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/JServer.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/ordinst.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/interMedia.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/context.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/xdb_protocol.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/spatial.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/ultraSearch.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/labelSecurity.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/odm.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/cwmlite.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/demoSchemas.sql
/u00/app/oracle/product/9.2.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9206/scripts/postDBCreation.sql
