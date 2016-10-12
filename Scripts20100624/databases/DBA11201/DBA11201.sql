set verify off
ACCEPT sysPassword CHAR PROMPT 'Enter new password for SYS: ' HIDE
ACCEPT systemPassword CHAR PROMPT 'Enter new password for SYSTEM: ' HIDE
ACCEPT sysmanPassword CHAR PROMPT 'Enter new password for SYSMAN: ' HIDE
ACCEPT dbsnmpPassword CHAR PROMPT 'Enter new password for DBSNMP: ' HIDE
host /u00/app/oracle/product/11.2.0.1/bin/orapwd file=/u00/app/oracle/product/11.2.0.1/dbs/orapwDBA11201 force=y
@/u00/app/oracle/admin/DBA11201/scripts/CreateDB.sql
@/u00/app/oracle/admin/DBA11201/scripts/CreateDBFiles.sql
@/u00/app/oracle/admin/DBA11201/scripts/CreateDBCatalog.sql
@/u00/app/oracle/admin/DBA11201/scripts/JServer.sql
@/u00/app/oracle/admin/DBA11201/scripts/context.sql
@/u00/app/oracle/admin/DBA11201/scripts/xdb_protocol.sql
@/u00/app/oracle/admin/DBA11201/scripts/ordinst.sql
@/u00/app/oracle/admin/DBA11201/scripts/interMedia.sql
@/u00/app/oracle/admin/DBA11201/scripts/cwmlite.sql
@/u00/app/oracle/admin/DBA11201/scripts/spatial.sql
@/u00/app/oracle/admin/DBA11201/scripts/labelSecurity.sql
@/u00/app/oracle/admin/DBA11201/scripts/sampleSchema.sql
@/u00/app/oracle/admin/DBA11201/scripts/emRepository.sql
@/u00/app/oracle/admin/DBA11201/scripts/apex.sql
@/u00/app/oracle/admin/DBA11201/scripts/owb.sql
@/u00/app/oracle/admin/DBA11201/scripts/lockAccount.sql
@/u00/app/oracle/admin/DBA11201/scripts/postDBCreation.sql
