#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBA10103/bdump
mkdir -p /u00/app/oracle/admin/DBA10103/cdump
mkdir -p /u00/app/oracle/admin/DBA10103/create
mkdir -p /u00/app/oracle/admin/DBA10103/pfile
mkdir -p /u00/app/oracle/admin/DBA10103/udump
mkdir -p /u00/app/oracle/product/10.1.0.3/dbs
mkdir -p /u01/oradata/DBA10103
mkdir -p /u01/oradata/flash_recovery_area
ORACLE_SID=DBA10103; export ORACLE_SID
echo Add this entry in the oratab: DBA10103:/u00/app/oracle/product/10.1.0.3:Y
/u00/app/oracle/product/10.1.0.3/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA10103/scripts/DBA10103.sql
