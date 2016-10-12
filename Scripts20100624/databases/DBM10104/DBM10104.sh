#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBM10104/bdump
mkdir -p /u00/app/oracle/admin/DBM10104/cdump
mkdir -p /u00/app/oracle/admin/DBM10104/create
mkdir -p /u00/app/oracle/admin/DBM10104/pfile
mkdir -p /u00/app/oracle/admin/DBM10104/udump
mkdir -p /u00/app/oracle/product/10.1.0.4/dbs
mkdir -p /u01/oradata/DBM10104
mkdir -p /u01/oradata/flash_recovery_area
ORACLE_SID=DBM10104; export ORACLE_SID
echo Add this entry in the oratab: DBM10104:/u00/app/oracle/product/10.1.0.4:Y
/u00/app/oracle/product/10.1.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM10104/scripts/DBM10104.sql
