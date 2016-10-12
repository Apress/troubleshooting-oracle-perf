#!/bin/sh

mkdir -p /u00/app/oracle/admin/DBM11106/adump
mkdir -p /u00/app/oracle/admin/DBM11106/dpdump
mkdir -p /u00/app/oracle/admin/DBM11106/pfile
mkdir -p /u00/app/oracle/cfgtoollogs/dbca/DBM11106
mkdir -p /u00/app/oracle/product/11.1.0.6/dbs
mkdir -p /u01/oradata/DBM11106
mkdir -p /u01/oradata/flash_recovery_area
ORACLE_SID=DBM11106; export ORACLE_SID
PATH=$ORACLE_HOME/bin:$PATH; export PATH
echo You should Add this entry in the /etc/oratab: DBM11106:/u00/app/oracle/product/11.1.0.6:Y
/u00/app/oracle/product/11.1.0.6/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM11106/scripts/DBM11106.sql
