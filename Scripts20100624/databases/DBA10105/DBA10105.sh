#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBA10105/bdump
mkdir -p /u00/app/oracle/admin/DBA10105/cdump
mkdir -p /u00/app/oracle/admin/DBA10105/create
mkdir -p /u00/app/oracle/admin/DBA10105/pfile
mkdir -p /u00/app/oracle/admin/DBA10105/udump
mkdir -p /u00/app/oracle/product/10.1.0.5/dbs
mkdir -p /u01/oradata/DBA10105
mkdir -p /u01/oradata/flash_recovery_area
ORACLE_SID=DBA10105; export ORACLE_SID
echo Add this entry in the oratab: DBA10105:/u00/app/oracle/product/10.1.0.5:Y
/u00/app/oracle/product/10.1.0.5/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA10105/scripts/DBA10105.sql
