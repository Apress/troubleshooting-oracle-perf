#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBM10203/adump
mkdir -p /u00/app/oracle/admin/DBM10203/bdump
mkdir -p /u00/app/oracle/admin/DBM10203/cdump
mkdir -p /u00/app/oracle/admin/DBM10203/dpdump
mkdir -p /u00/app/oracle/admin/DBM10203/pfile
mkdir -p /u00/app/oracle/admin/DBM10203/udump
mkdir -p /u00/app/oracle/product/10.2.0.3/cfgtoollogs/dbca/DBM10203
mkdir -p /u00/app/oracle/product/10.2.0.3/dbs
mkdir -p /u01/oradata/DBM10203
mkdir -p /u01/oradata/flash_recovery_area
ORACLE_SID=DBM10203; export ORACLE_SID
echo You should Add this entry in the /etc/oratab: DBM10203:/u00/app/oracle/product/10.2.0.3:Y
/u00/app/oracle/product/10.2.0.3/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM10203/scripts/DBM10203.sql
