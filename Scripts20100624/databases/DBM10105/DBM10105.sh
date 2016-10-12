#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBM10105/bdump
mkdir -p /u00/app/oracle/admin/DBM10105/cdump
mkdir -p /u00/app/oracle/admin/DBM10105/create
mkdir -p /u00/app/oracle/admin/DBM10105/pfile
mkdir -p /u00/app/oracle/admin/DBM10105/udump
mkdir -p /u00/app/oracle/product/10.1.0.5/dbs
mkdir -p /u01/oradata/DBM10105
mkdir -p /u01/oradata/flash_recovery_area
ORACLE_SID=DBM10105; export ORACLE_SID
echo Add this entry in the oratab: DBM10105:/u00/app/oracle/product/10.1.0.5:Y
/u00/app/oracle/product/10.1.0.5/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM10105/scripts/DBM10105.sql
