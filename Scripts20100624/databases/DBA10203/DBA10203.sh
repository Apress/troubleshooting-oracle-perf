#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBA10203/adump
mkdir -p /u00/app/oracle/admin/DBA10203/bdump
mkdir -p /u00/app/oracle/admin/DBA10203/cdump
mkdir -p /u00/app/oracle/admin/DBA10203/dpdump
mkdir -p /u00/app/oracle/admin/DBA10203/pfile
mkdir -p /u00/app/oracle/admin/DBA10203/udump
mkdir -p /u00/app/oracle/product/10.2.0.3/cfgtoollogs/dbca/DBA10203
mkdir -p /u00/app/oracle/product/10.2.0.3/dbs
mkdir -p /u01/oradata/DBA10203
mkdir -p /u01/oradata/flash_recovery_area
ORACLE_SID=DBA10203; export ORACLE_SID
echo You should Add this entry in the /etc/oratab: DBA10203:/u00/app/oracle/product/10.2.0.3:Y
/u00/app/oracle/product/10.2.0.3/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA10203/scripts/DBA10203.sql
