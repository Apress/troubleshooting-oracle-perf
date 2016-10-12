#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBA10202/adump
mkdir -p /u00/app/oracle/admin/DBA10202/bdump
mkdir -p /u00/app/oracle/admin/DBA10202/cdump
mkdir -p /u00/app/oracle/admin/DBA10202/dpdump
mkdir -p /u00/app/oracle/admin/DBA10202/pfile
mkdir -p /u00/app/oracle/admin/DBA10202/udump
mkdir -p /u00/app/oracle/product/10.2.0.2/cfgtoollogs/dbca/DBA10202
mkdir -p /u00/app/oracle/product/10.2.0.2/dbs
mkdir -p /u01/oradata/DBA10202
mkdir -p /u01/oradata/flash_recovery_area
ORACLE_SID=DBA10202; export ORACLE_SID
echo You should Add this entry in the /etc/oratab: DBA10202:/u00/app/oracle/product/10.2.0.2:Y
/u00/app/oracle/product/10.2.0.2/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA10202/scripts/DBA10202.sql
