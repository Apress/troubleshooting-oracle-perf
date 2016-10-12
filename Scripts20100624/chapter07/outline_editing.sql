SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: outline_editing.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows how to manually edit a stored outline.
REM Notes.......: -
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
SET LINESIZE 80

COLUMN hint# FORMAT 999999
COLUMN hint_text FORMAT A50
COLUMN user_table_name FORMAT A16

@../connect.sql

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;

CREATE TABLE t AS 
SELECT rownum AS n, rpad('*',100,'*') AS pad
FROM dual
CONNECT BY level <= 1000;

execute dbms_stats.gather_table_stats(user, 't')

CREATE INDEX i ON t(n);

ALTER SESSION SET OPTIMIZER_MODE = ALL_ROWS;

PAUSE

REM
REM Create the outline
REM

CREATE OR REPLACE OUTLINE outline_editing
ON SELECT * FROM t WHERE n = 1970;

PAUSE

REM
REM Create outline working tables (in 10g the tables exist per default)
REM

DECLARE
  l_count PLS_INTEGER;
BEGIN
  SELECT count(*)
  INTO l_count
  FROM all_tables 
  WHERE table_name = 'OL$HINTS';
  
  IF l_count = 1
  THEN
    dbms_outln_edit.create_edit_tables;
  END IF;
END;
/

PAUSE

REM
REM Create private outline
REM

CREATE PRIVATE OUTLINE p_outline_editing FROM outline_editing;

CREATE OR REPLACE PRIVATE OUTLINE p_outline_editing
ON SELECT * FROM t WHERE n = 1970;

PAUSE

REM
REM Update private outline
REM

SELECT hint#, hint_text
FROM ol$hints 
WHERE ol_name = 'P_OUTLINE_EDITING';

REM examples of hint_text:
REM 9i........ FULL(T)
REM 10g/11g... FULL(@"SEL$1" "T"@"SEL$1")

UPDATE ol$hints 
SET hint_text = '&hint_text',
    hint_type = 52
WHERE hint_text LIKE 'INDEX%'
AND ol_name = 'P_OUTLINE_EDITING';

SELECT hint#, hint_text
FROM ol$hints 
WHERE ol_name = 'P_OUTLINE_EDITING';

PAUSE

REM
REM Resynchronize private outline
REM

execute dbms_outln_edit.refresh_private_outline('P_OUTLINE_EDITING')

PAUSE

REM
REM Test if outline used
REM

ALTER SESSION SET use_stored_outlines = FALSE;
ALTER SESSION SET use_private_outlines = TRUE;

EXPLAIN PLAN FOR SELECT * FROM t WHERE n = 1970;
SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER SESSION SET use_stored_outlines = TRUE;
ALTER SESSION SET use_private_outlines = FALSE;

EXPLAIN PLAN FOR SELECT * FROM t WHERE n = 1970;
SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Save outline in the data dictionary
REM

CREATE OR REPLACE OUTLINE outline_editing FROM PRIVATE p_outline_editing;

PAUSE

ALTER SESSION SET use_stored_outlines = FALSE;

EXPLAIN PLAN FOR SELECT * FROM t WHERE n = 1970;
SELECT * FROM table(dbms_xplan.display);

PAUSE

ALTER SESSION SET use_stored_outlines = TRUE;

EXPLAIN PLAN FOR SELECT * FROM t WHERE n = 1970;
SELECT * FROM table(dbms_xplan.display);

PAUSE

REM
REM Cleanup
REM

execute dbms_outln_edit.drop_edit_tables

DROP OUTLINE outline_editing;

DROP TABLE t;
PURGE TABLE t;
