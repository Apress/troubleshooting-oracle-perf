SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************ http://top.antognini.ch **************************
REM ***************************************************************************
REM
REM File name...: bind_variables.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows how and when bind variables lead to the
REM               sharing of cursors.
REM Notes.......: This script works as of 10g only. The 9i version is named
REM               bind_variables_9i.sql.
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM 08.03.2009 Fixed typo in comment
REM 24.06.2010 Because of 11g modified/added queries against V$SQL_SHARED_CURSOR
REM ***************************************************************************

SET TERMOUT ON
SET FEEDBACK OFF
SET VERIFY OFF
SET SCAN ON

@../connect.sql

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;

CREATE TABLE t (n NUMBER, v VARCHAR2(4000));

ALTER SYSTEM FLUSH SHARED_POOL;

COLUMN sql_id NEW_VALUE sql_id

PAUSE

REM
REM This script only works if:
REM - the database character set is a single-byte encoding (e.g. WE8MSWIN1252) 
REM - the database national character is a two-byte encoding (e.g. AL16UTF16)
REM

SELECT parameter, value 
FROM nls_database_parameters 
WHERE parameter IN ('NLS_CHARACTERSET','NLS_NCHAR_CHARACTERSET');

PAUSE

REM
REM Execute three times the same SQL statement. Every time the value of the 
REM bind variable is changed. Note that the SQL statement uses two bind 
REM variables: a NUMBER and a VARCHAR2(32).
REM

VARIABLE n NUMBER
VARIABLE v VARCHAR2(32)

EXECUTE :n := 1; :v := 'Helicon';

INSERT INTO t (n, v) VALUES (:n, :v);

EXECUTE :n := 2; :v := 'Trantor';

INSERT INTO t (n, v) VALUES (:n, :v);

EXECUTE :n := 3; :v := 'Kalgan';

INSERT INTO t (n, v) VALUES (:n, :v);

PAUSE

REM
REM Display information about the associated child cursors
REM

SELECT sql_id, child_number, executions
FROM v$sql
WHERE sql_text = 'INSERT INTO t (n, v) VALUES (:n, :v)';

PAUSE

REM
REM Re-execute the SQL statement two times. Compared to the previous 
REM executions, the size of the VARCHAR2 bind variable is increased.
REM

VARIABLE v VARCHAR2(33)

EXECUTE :n := 4; :v := 'Terminus';

INSERT INTO t (n, v) VALUES (:n, :v);

VARIABLE v VARCHAR2(128)

EXECUTE :n := 4; :v := 'Terminus';

INSERT INTO t (n, v) VALUES (:n, :v);

PAUSE

REM
REM Display information about the associated child cursors
REM

SELECT sql_id, child_number, executions
FROM v$sql
WHERE sql_text = 'INSERT INTO t (n, v) VALUES (:n, :v)';

PAUSE

REM
REM Re-execute the SQL statement two times. Compared to the previous 
REM executions, the size of the VARCHAR2 bind variable is increased.
REM

VARIABLE v VARCHAR2(129)

EXECUTE :n := 4; :v := 'Terminus';

INSERT INTO t (n, v) VALUES (:n, :v);

VARIABLE v VARCHAR2(2000)

EXECUTE :n := 4; :v := 'Terminus';

INSERT INTO t (n, v) VALUES (:n, :v);

PAUSE

REM
REM Display information about the associated child cursors
REM

SELECT sql_id, child_number, executions
FROM v$sql
WHERE sql_text = 'INSERT INTO t (n, v) VALUES (:n, :v)';

PAUSE

REM
REM Re-execute the SQL statement two times. Compared to the previous 
REM executions, the size of the VARCHAR2 bind variable is increased.
REM

VARIABLE v VARCHAR2(2001)

EXECUTE :n := 4; :v := 'Terminus';

INSERT INTO t (n, v) VALUES (:n, :v);

VARIABLE v VARCHAR2(4000)

EXECUTE :n := 4; :v := 'Terminus';

INSERT INTO t (n, v) VALUES (:n, :v);

PAUSE

REM
REM Display information about the associated child cursors
REM

SELECT sql_id, child_number, executions
FROM v$sql
WHERE sql_text = 'INSERT INTO t (n, v) VALUES (:n, :v)';

PAUSE

REM
REM Several child cursors were generated because of the increasing size of the
REM VARCHAR2 bind variable. 
REM

COLUMN bind_mismatch FORMAT a13
COLUMN incomplete_cursor FORMAT a17
COLUMN bind_length_upgradeable FORMAT a23

SELECT child_number, bind_mismatch, incomplete_cursor
FROM v$sql_shared_cursor
WHERE sql_id = '&sql_id';

PAUSE

REM The following query works as of 11.2 only

SELECT child_number, bind_length_upgradeable
FROM v$sql_shared_cursor
WHERE sql_id = '&sql_id';

PAUSE

REM
REM The metadata associated to the bind variables confirms that the database
REM engine uses bind variable graduation to minimize the number of child 
REM cursors.
REM

SELECT s.child_number, m.position, m.max_length, 
       decode(m.datatype,1,'VARCHAR2',2,'NUMBER',m.datatype) aS datatype
FROM v$sql s, v$sql_bind_metadata m
WHERE s.sql_id = '&sql_id'
AND s.child_address = m.address
ORDER BY 1, 2;

PAUSE

REM
REM Show that the boundaries for bind variable graduation (32, 128 and 2000)
REM are bytes, not characters. For that purpose, the national character set
REM is used.
REM

ALTER SYSTEM FLUSH SHARED_POOL;

VARIABLE n NUMBER
VARIABLE v NVARCHAR2(16)

EXECUTE :n := 1; :v := 'Helicon';

INSERT INTO t (n, v) VALUES (:n, :v);

VARIABLE v NVARCHAR2(17)

EXECUTE :n := 2; :v := 'Trantor';

INSERT INTO t (n, v) VALUES (:n, :v);

PAUSE

SELECT sql_id, child_number, executions
FROM v$sql
WHERE sql_text = 'INSERT INTO t (n, v) VALUES (:n, :v)';

PAUSE

SELECT child_number, bind_mismatch, incomplete_cursor
FROM v$sql_shared_cursor
WHERE sql_id = '&sql_id';

PAUSE

REM The following query works as of 11.2 only

SELECT child_number, bind_length_upgradeable
FROM v$sql_shared_cursor
WHERE sql_id = '&sql_id';

PAUSE

SELECT s.child_number, m.position, m.max_length, 
       decode(m.datatype,1,'VARCHAR2',2,'NUMBER',m.datatype) aS datatype
FROM v$sql s, v$sql_bind_metadata m
WHERE s.sql_id = '&sql_id'
AND s.child_address = m.address
ORDER BY 1, 2;

REM
REM Cleanup
REM

UNDEFINE sql_id

DROP TABLE t;
PURGE TABLE t;
