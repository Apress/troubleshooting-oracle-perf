SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: display_cursor_9i.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script displays the execution plan of a cursor stored
REM               in the library cache. The cursor is identified by address,
REM               hash value, and child number.
REM Notes.......: This script is for Oracle9i only.
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM
REM ***************************************************************************

SET TERMOUT ON
SET FEEDBACK OFF
SET VERIFY OFF
SET SCAN ON

UNDEFINE address
UNDEFINE hash_value
UNDEFINE child_number
UNDEFINE statement_id

@../connect.sql

SET ECHO ON

SELECT address, hash_value, child_number, sql_text
FROM v$sql
WHERE sql_text LIKE '%&sql_text%' AND sql_text NOT LIKE '%v$sql%';

DEFINE statement_id = '&&address-&&hash_value-&&child_number'

DELETE plan_table WHERE statement_id = '&statement_id';

INSERT INTO plan_table (statement_id, timestamp, operation, options, 
                        object_node, object_owner, object_name, optimizer, 
                        search_columns, id, parent_id, position, cost, 
                        cardinality, bytes, other_tag, partition_start, 
                        partition_stop, partition_id, other, distribution, 
                        cpu_cost, io_cost, temp_space, access_predicates,
                        filter_predicates)
SELECT '&statement_id', sysdate,
       operation, options, object_node, object_owner, object_name,
       optimizer, search_columns, id, parent_id, position, cost,
       cardinality, bytes, other_tag, partition_start, partition_stop,
       partition_id, other, distribution, cpu_cost, io_cost, temp_space,
       access_predicates, filter_predicates
FROM v$sql_plan
WHERE address = '&address'
AND hash_value = &hash_value
AND child_number = &child_number;

SELECT * FROM table(dbms_xplan.display(null,'&statement_id'));

UNDEFINE address
UNDEFINE hash_value
UNDEFINE child_number
UNDEFINE statement_id
