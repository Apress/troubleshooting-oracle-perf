#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBM10103/bdump
mkdir -p /u00/app/oracle/admin/DBM10103/cdump
mkdir -p /u00/app/oracle/admin/DBM10103/create
mkdir -p /u00/app/oracle/admin/DBM10103/pfile
mkdir -p /u00/app/oracle/admin/DBM10103/udump
mkdir -p /u01/oradata/flash_recovery_area
mkdir -p /u00/app/oracle/product/10.1.0.3/dbs
mkdir -p /u01/oradata/DBM10103
ORACLE_SID=DBM10103; export ORACLE_SID
echo Add this entry in the oratab: DBM10103:/u00/app/oracle/product/10.1.0.3:Y
/u00/app/oracle/product/10.1.0.3/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM10103/scripts/DBM10103.sql
