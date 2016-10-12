#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBA10104/bdump
mkdir -p /u00/app/oracle/admin/DBA10104/cdump
mkdir -p /u00/app/oracle/admin/DBA10104/create
mkdir -p /u00/app/oracle/admin/DBA10104/pfile
mkdir -p /u00/app/oracle/admin/DBA10104/udump
mkdir -p /u00/app/oracle/product/10.1.0.4/dbs
mkdir -p /u01/oradata/DBA10104
mkdir -p /u01/oradata/flash_recovery_area
ORACLE_SID=DBA10104; export ORACLE_SID
echo Add this entry in the oratab: DBA10104:/u00/app/oracle/product/10.1.0.4:Y
/u00/app/oracle/product/10.1.0.4/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA10104/scripts/DBA10104.sql
