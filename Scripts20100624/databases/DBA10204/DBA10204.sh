#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBA10204/adump
mkdir -p /u00/app/oracle/admin/DBA10204/bdump
mkdir -p /u00/app/oracle/admin/DBA10204/cdump
mkdir -p /u00/app/oracle/admin/DBA10204/dpdump
mkdir -p /u00/app/oracle/admin/DBA10204/pfile
mkdir -p /u00/app/oracle/admin/DBA10204/udump
mkdir -p /u00/app/oracle/product/10.2.0.4/cfgtoollogs/dbca/DBA10204
mkdir -p /u00/app/oracle/product/10.2.0.4/dbs
mkdir -p /u01/oradata/DBA10204
mkdir -p /u01/oradata/flash_recovery_area
ORACLE_SID=DBA10204; export ORACLE_SID
echo You should Add this entry in the /etc/oratab: DBA10204:/u00/app/oracle/product/10.2.0.4:Y
/u00/app/oracle/product/10.2.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA10204/scripts/DBA10204.sql
