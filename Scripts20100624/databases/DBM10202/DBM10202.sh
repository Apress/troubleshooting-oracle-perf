#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBM10202/adump
mkdir -p /u00/app/oracle/admin/DBM10202/bdump
mkdir -p /u00/app/oracle/admin/DBM10202/cdump
mkdir -p /u00/app/oracle/admin/DBM10202/dpdump
mkdir -p /u00/app/oracle/admin/DBM10202/pfile
mkdir -p /u00/app/oracle/admin/DBM10202/udump
mkdir -p /u00/app/oracle/product/10.2.0.2/cfgtoollogs/dbca/DBM10202
mkdir -p /u00/app/oracle/product/10.2.0.2/dbs
mkdir -p /u01/oradata/DBM10202
mkdir -p /u01/oradata/flash_recovery_area
ORACLE_SID=DBM10202; export ORACLE_SID
echo You should Add this entry in the /etc/oratab: DBM10202:/u00/app/oracle/product/10.2.0.2:Y
/u00/app/oracle/product/10.2.0.2/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM10202/scripts/DBM10202.sql
