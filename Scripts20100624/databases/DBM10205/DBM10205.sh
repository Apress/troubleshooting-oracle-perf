#!/bin/sh

OLD_UMASK=`umask`
umask 0027
mkdir -p /u00/app/oracle/admin/DBM10205/adump
mkdir -p /u00/app/oracle/admin/DBM10205/bdump
mkdir -p /u00/app/oracle/admin/DBM10205/cdump
mkdir -p /u00/app/oracle/admin/DBM10205/dpdump
mkdir -p /u00/app/oracle/admin/DBM10205/pfile
mkdir -p /u00/app/oracle/admin/DBM10205/udump
mkdir -p /u00/app/oracle/product/10.2.0.5/cfgtoollogs/dbca/DBM10205
mkdir -p /u00/app/oracle/product/10.2.0.5/dbs
mkdir -p /u01/oradata/DBM10205
mkdir -p /u01/oradata/flash_recovery_area
umask ${OLD_UMASK}
ORACLE_SID=DBM10205; export ORACLE_SID
echo You should Add this entry in the /etc/oratab: DBM10205:/u00/app/oracle/product/10.2.0.5:Y
/u00/app/oracle/product/10.2.0.5/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM10205/scripts/DBM10205.sql
