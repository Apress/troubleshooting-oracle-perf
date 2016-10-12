set echo on
spool /u00/app/oracle/admin/DBA11107/scripts/lockAccount.log
BEGIN 
 FOR item IN ( SELECT USERNAME FROM DBA_USERS WHERE USERNAME NOT IN ( 
'SYS','SYSTEM') ) 
 LOOP 
  dbms_output.put_line('Locking and Expiring: ' || item.USERNAME); 
  execute immediate 'alter user ' || item.USERNAME || ' password expire account lock' ;
 END LOOP;
END;
/
spool off
