#!/bin/sh

OLD_UMASK=`umask`
umask 0027
mkdir -p /u00/app/oracle/admin/DBM11201/adump
mkdir -p /u00/app/oracle/admin/DBM11201/dpdump
mkdir -p /u00/app/oracle/admin/DBM11201/pfile
mkdir -p /u00/app/oracle/cfgtoollogs/dbca/DBM11201
mkdir -p /u00/app/oracle/product/11.2.0.1/dbs
mkdir -p /u01/oradata
mkdir -p /u01/oradata/DBM11201
mkdir -p /u01/oradata/flash_recovery_area
umask ${OLD_UMASK}
ORACLE_SID=DBM11201; export ORACLE_SID
PATH=$ORACLE_HOME/bin:$PATH; export PATH
echo You should Add this entry in the /etc/oratab: DBM11201:/u00/app/oracle/product/11.2.0.1:Y
/u00/app/oracle/product/11.2.0.1/bin/sqlplus /nolog @/u00/app/oracle/admin/DBM11201/scripts/DBM11201.sql
