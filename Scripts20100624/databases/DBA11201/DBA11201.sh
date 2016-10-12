#!/bin/sh

OLD_UMASK=`umask`
umask 0027
mkdir -p /u00/app/oracle/admin/DBA11201/adump
mkdir -p /u00/app/oracle/admin/DBA11201/dpdump
mkdir -p /u00/app/oracle/admin/DBA11201/pfile
mkdir -p /u00/app/oracle/cfgtoollogs/dbca/DBA11201
mkdir -p /u00/app/oracle/product/11.2.0.1/dbs
mkdir -p /u01/oradata
mkdir -p /u01/oradata/DBA11201
mkdir -p /u01/oradata/flash_recovery_area
umask ${OLD_UMASK}
ORACLE_SID=DBA11201; export ORACLE_SID
PATH=$ORACLE_HOME/bin:$PATH; export PATH
echo You should Add this entry in the /etc/oratab: DBA11201:/u00/app/oracle/product/11.2.0.1:Y
/u00/app/oracle/product/11.2.0.1/bin/sqlplus /nolog @/u00/app/oracle/admin/DBA11201/scripts/DBA11201.sql
