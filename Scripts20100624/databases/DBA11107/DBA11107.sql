set verify off
PROMPT specify a password for sys as parameter 1;
DEFINE sysPassword = &1
PROMPT specify a password for system as parameter 2;
DEFINE systemPassword = &2
PROMPT specify a password for sysman as parameter 3;
DEFINE sysmanPassword = &3
PROMPT specify a password for dbsnmp as parameter 4;
DEFINE dbsnmpPassword = &4
host /u00/app/oracle/product/11.1.0.7/bin/orapwd file=/u00/app/oracle/product/11.1.0.7/dbs/orapwDBA11107 password=&&sysPassword force=y
@/u00/app/oracle/admin/DBA11107/scripts/CreateDB.sql
@/u00/app/oracle/admin/DBA11107/scripts/CreateDBFiles.sql
@/u00/app/oracle/admin/DBA11107/scripts/CreateDBCatalog.sql
@/u00/app/oracle/admin/DBA11107/scripts/JServer.sql
@/u00/app/oracle/admin/DBA11107/scripts/context.sql
@/u00/app/oracle/admin/DBA11107/scripts/xdb_protocol.sql
@/u00/app/oracle/admin/DBA11107/scripts/ordinst.sql
@/u00/app/oracle/admin/DBA11107/scripts/interMedia.sql
@/u00/app/oracle/admin/DBA11107/scripts/cwmlite.sql
@/u00/app/oracle/admin/DBA11107/scripts/spatial.sql
@/u00/app/oracle/admin/DBA11107/scripts/ultraSearch.sql
@/u00/app/oracle/admin/DBA11107/scripts/labelSecurity.sql
#@/u00/app/oracle/admin/DBA11107/scripts/sampleSchema.sql
@/u00/app/oracle/admin/DBA11107/scripts/emRepository.sql
@/u00/app/oracle/admin/DBA11107/scripts/apex.sql
@/u00/app/oracle/admin/DBA11107/scripts/owb.sql
@/u00/app/oracle/admin/DBA11107/scripts/ultraSearchCfg.sql
@/u00/app/oracle/admin/DBA11107/scripts/lockAccount.sql
@/u00/app/oracle/admin/DBA11107/scripts/postDBCreation.sql
