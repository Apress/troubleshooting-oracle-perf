#!/bin/sh

mkdir /u00/app/oracle/admin/DBA9207/bdump
mkdir /u00/app/oracle/admin/DBA9207/cdump
mkdir /u00/app/oracle/admin/DBA9207/create
mkdir /u00/app/oracle/admin/DBA9207/pfile
mkdir /u00/app/oracle/admin/DBA9207/udump
mkdir /u00/app/oracle/oradata
mkdir /u00/app/oracle/product/9.2.0.7/dbs
mkdir /u01/oradata/DBA9207
setenv ORACLE_SID DBA9207
echo Add this entry in the oratab: DBA9207:/u00/app/oracle/product/9.2.0.7:Y
/u00/app/oracle/product/9.2.0.7/bin/orapwd file=/u00/app/oracle/product/9.2.0.7/dbs/orapwDBA9207 password=change_on_install
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/CreateDB.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/CreateDBFiles.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/CreateDBCatalog.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/JServer.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/ordinst.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/interMedia.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/context.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/xdb_protocol.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/spatial.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/ultraSearch.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/labelSecurity.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/odm.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/cwmlite.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/demoSchemas.sql
/u00/app/oracle/product/9.2.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA9207/scripts/postDBCreation.sql
