#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBA11107/adump
mkdir -p /u00/app/oracle/admin/DBA11107/dpdump
mkdir -p /u00/app/oracle/admin/DBA11107/pfile
mkdir -p /u00/app/oracle/cfgtoollogs/dbca/DBA11107
mkdir -p /u00/app/oracle/product/11.1.0.7/dbs
mkdir -p /u01/oradata/DBA11107
mkdir -p /u01/oradata/flash_recovery_area
ORACLE_SID=DBA11107; export ORACLE_SID
PATH=$ORACLE_HOME/bin:$PATH; export PATH
echo You should Add this entry in the /etc/oratab: DBA11107:/u00/app/oracle/product/11.1.0.7:Y
/u00/app/oracle/product/11.1.0.7/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA11107/scripts/DBA11107.sql
