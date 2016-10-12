#!/bin/sh

OLD_UMASK=`umask`
umask 0027
mkdir -p /u00/app/oracle/admin/DBA10205/adump
mkdir -p /u00/app/oracle/admin/DBA10205/bdump
mkdir -p /u00/app/oracle/admin/DBA10205/cdump
mkdir -p /u00/app/oracle/admin/DBA10205/dpdump
mkdir -p /u00/app/oracle/admin/DBA10205/pfile
mkdir -p /u00/app/oracle/admin/DBA10205/udump
mkdir -p /u00/app/oracle/product/10.2.0.5/cfgtoollogs/dbca/DBA10205
mkdir -p /u00/app/oracle/product/10.2.0.5/dbs
mkdir -p /u01/oradata/DBA10205
mkdir -p /u01/oradata/flash_recovery_area
umask ${OLD_UMASK}
ORACLE_SID=DBA10205; export ORACLE_SID
echo You should Add this entry in the /etc/oratab: DBA10205:/u00/app/oracle/product/10.2.0.5:Y
/u00/app/oracle/product/10.2.0.5/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA10205/scripts/DBA10205.sql
