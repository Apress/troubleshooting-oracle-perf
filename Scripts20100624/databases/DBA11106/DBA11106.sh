#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBA11106/adump
mkdir -p /u00/app/oracle/admin/DBA11106/dpdump
mkdir -p /u00/app/oracle/admin/DBA11106/pfile
mkdir -p /u00/app/oracle/cfgtoollogs/dbca/DBA11106
mkdir -p /u00/app/oracle/product/11.1.0.6/dbs
mkdir -p /u01/oradata/DBA11106
mkdir -p /u01/oradata/flash_recovery_area
ORACLE_SID=DBA11106; export ORACLE_SID
PATH=$ORACLE_HOME/bin:$PATH; export PATH
echo You should Add this entry in the /etc/oratab: DBA11106:/u00/app/oracle/product/11.1.0.6:Y
/u00/app/oracle/product/11.1.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA11106/scripts/DBA11106.sql
