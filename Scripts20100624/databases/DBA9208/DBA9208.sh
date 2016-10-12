#!/bin/sh

mkdir /u00/app/oracle/admin/DBA9208/bdump
mkdir /u00/app/oracle/admin/DBA9208/cdump
mkdir /u00/app/oracle/admin/DBA9208/create
mkdir /u00/app/oracle/admin/DBA9208/pfile
mkdir /u00/app/oracle/admin/DBA9208/udump
mkdir /u00/app/oracle/product/9.2.0.8/dbs
mkdir /u01/oradata/DBA9208
setenv ORACLE_SID DBA9208
echo Add this entry in the oratab: DBA9208:/u00/app/oracle/product/9.2.0.8:Y
/u00/app/oracle/product/9.2.0.8/bin/orapwd file=/u00/app/oracle/product/9.2.0.8/dbs/orapwDBA9208 password=change_on_install
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/CreateDB.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/CreateDBFiles.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/CreateDBCatalog.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/JServer.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/ordinst.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/interMedia.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/context.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/xdb_protocol.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/spatial.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/ultraSearch.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/labelSecurity.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/odm.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/cwmlite.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/demoSchemas.sql
/u00/app/oracle/product/9.2.0.8/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9208/scripts/postDBCreation.sql
