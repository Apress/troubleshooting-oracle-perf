#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBA10201/adump
mkdir -p /u00/app/oracle/admin/DBA10201/bdump
mkdir -p /u00/app/oracle/admin/DBA10201/cdump
mkdir -p /u00/app/oracle/admin/DBA10201/dpdump
mkdir -p /u00/app/oracle/admin/DBA10201/pfile
mkdir -p /u00/app/oracle/admin/DBA10201/udump
mkdir -p /u00/app/oracle/product/10.2.0.1/cfgtoollogs/dbca/DBA10201
mkdir -p /u00/app/oracle/product/10.2.0.1/dbs
mkdir -p /u01/oradata/DBA10201
mkdir -p /u01/oradata/flash_recovery_area
ORACLE_SID=DBA10201; export ORACLE_SID
echo You should Add this entry in the /etc/oratab: DBA10201:/u00/app/oracle/product/10.2.0.1:Y
/u00/app/oracle/product/10.2.0.1/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA10201/scripts/DBA10201.sql
