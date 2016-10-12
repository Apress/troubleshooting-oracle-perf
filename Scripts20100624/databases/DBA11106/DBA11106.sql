set verify off
PROMPT specify a password for sys as parameter 1;
DEFINE sysPassword = &1
PROMPT specify a password for system as parameter 2;
DEFINE systemPassword = &2
PROMPT specify a password for sysman as parameter 3;
DEFINE sysmanPassword = &3
PROMPT specify a password for dbsnmp as parameter 4;
DEFINE dbsnmpPassword = &4
host /u00/app/oracle/product/11.1.0.6/bin/orapwd file=/u00/app/oracle/product/11.1.0.6/dbs/orapwDBA11106 password=&&sysPassword force=y
@/u00/app/oracle/admin/DBA11106/scripts/CreateDB.sql
@/u00/app/oracle/admin/DBA11106/scripts/CreateDBFiles.sql
@/u00/app/oracle/admin/DBA11106/scripts/CreateDBCatalog.sql
@/u00/app/oracle/admin/DBA11106/scripts/JServer.sql
@/u00/app/oracle/admin/DBA11106/scripts/context.sql
@/u00/app/oracle/admin/DBA11106/scripts/xdb_protocol.sql
@/u00/app/oracle/admin/DBA11106/scripts/ordinst.sql
@/u00/app/oracle/admin/DBA11106/scripts/interMedia.sql
@/u00/app/oracle/admin/DBA11106/scripts/cwmlite.sql
@/u00/app/oracle/admin/DBA11106/scripts/spatial.sql
@/u00/app/oracle/admin/DBA11106/scripts/ultraSearch.sql
@/u00/app/oracle/admin/DBA11106/scripts/labelSecurity.sql
@/u00/app/oracle/admin/DBA11106/scripts/sampleSchema.sql
@/u00/app/oracle/admin/DBA11106/scripts/emRepository.sql
@/u00/app/oracle/admin/DBA11106/scripts/apex.sql
@/u00/app/oracle/admin/DBA11106/scripts/owb.sql
@/u00/app/oracle/admin/DBA11106/scripts/ultraSearchCfg.sql
@/u00/app/oracle/admin/DBA11106/scripts/lockAccount.sql
@/u00/app/oracle/admin/DBA11106/scripts/postDBCreation.sql
