set verify off
PROMPT specify a password for sys as parameter 1;
DEFINE sysPassword = &1
PROMPT specify a password for system as parameter 2;
DEFINE systemPassword = &2
PROMPT specify a password for sysman as parameter 3;
DEFINE sysmanPassword = &3
PROMPT specify a password for dbsnmp as parameter 4;
DEFINE dbsnmpPassword = &4
host /u00/app/oracle/product/10.2.0.4/bin/orapwd file=/u00/app/oracle/product/10.2.0.4/dbs/orapwDBA10204 password=&&sysPassword force=y
@/u00/app/oracle/admin/DBA10204/scripts/CreateDB.sql
@/u00/app/oracle/admin/DBA10204/scripts/CreateDBFiles.sql
@/u00/app/oracle/admin/DBA10204/scripts/CreateDBCatalog.sql
@/u00/app/oracle/admin/DBA10204/scripts/JServer.sql
@/u00/app/oracle/admin/DBA10204/scripts/odm.sql
@/u00/app/oracle/admin/DBA10204/scripts/context.sql
@/u00/app/oracle/admin/DBA10204/scripts/xdb_protocol.sql
@/u00/app/oracle/admin/DBA10204/scripts/ordinst.sql
@/u00/app/oracle/admin/DBA10204/scripts/interMedia.sql
@/u00/app/oracle/admin/DBA10204/scripts/cwmlite.sql
@/u00/app/oracle/admin/DBA10204/scripts/spatial.sql
@/u00/app/oracle/admin/DBA10204/scripts/ultraSearch.sql
@/u00/app/oracle/admin/DBA10204/scripts/labelSecurity.sql
#@/u00/app/oracle/admin/DBA10204/scripts/sampleSchema.sql
@/u00/app/oracle/admin/DBA10204/scripts/emRepository.sql
@/u00/app/oracle/admin/DBA10204/scripts/ultraSearchCfg.sql
@/u00/app/oracle/admin/DBA10204/scripts/postDBCreation.sql
