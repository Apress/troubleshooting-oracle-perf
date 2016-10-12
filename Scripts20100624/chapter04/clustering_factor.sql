SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: clustering_factor.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script creates a function that illustrates how the
REM               clustering factor is computed.
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

@../connect.sql

COLUMN index_name FORMAT A11
COLUMN clust_factor FORMAT 999999999999

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;
DROP INDEX t_val1_i;
DROP INDEX t_val2_i;

CREATE TABLE t
AS
SELECT rownum AS id,
       round(dbms_random.normal*1000) AS val1,
       100+round(ln(rownum/3.25+2)) AS val2,
       100+round(ln(rownum/3.25+2)) AS val3,
       dbms_random.string('p',250) AS pad
FROM dual
CONNECT BY level <= 1000
ORDER BY dbms_random.value;

ALTER TABLE t ADD CONSTRAINT t_pk PRIMARY KEY (id);
CREATE INDEX t_val1_i ON t (val1);
CREATE INDEX t_val2_i ON t (val2);

BEGIN
  dbms_stats.gather_table_stats(ownname          => user,
                                tabname          => 'T',
                                estimate_percent => 100,
                                method_opt       => 'for all columns size skewonly',
                                cascade          => TRUE);
END;
/

PAUSE

CREATE OR REPLACE FUNCTION clustering_factor (
  p_owner IN VARCHAR2, 
  p_table_name IN VARCHAR2,
  p_column_name IN VARCHAR2
) RETURN NUMBER IS
  l_cursor             SYS_REFCURSOR;
  l_clustering_factor  BINARY_INTEGER := 0;
  l_block_nr           BINARY_INTEGER := 0;
  l_previous_block_nr  BINARY_INTEGER := 0;
  l_file_nr            BINARY_INTEGER := 0;
  l_previous_file_nr   BINARY_INTEGER := 0;
BEGIN
  OPEN l_cursor FOR 
    'SELECT dbms_rowid.rowid_block_number(rowid) block_nr, '||
    '       dbms_rowid.rowid_to_absolute_fno(rowid, '''||
                                             p_owner||''','''||
                                             p_table_name||''') file_nr '||
    'FROM '||p_owner||'.'||p_table_name||' '||
    'WHERE '||p_column_name||' IS NOT NULL '||
    'ORDER BY ' || p_column_name;
  LOOP
    FETCH l_cursor INTO l_block_nr, l_file_nr;
    EXIT WHEN l_cursor%NOTFOUND;
    IF (l_previous_block_nr <> l_block_nr OR l_previous_file_nr <> l_file_nr)
    THEN
      l_clustering_factor := l_clustering_factor + 1;
    END IF;
    l_previous_block_nr := l_block_nr;
    l_previous_file_nr := l_file_nr;
  END LOOP;
  CLOSE l_cursor;
  RETURN l_clustering_factor;
END;
/

PAUSE

REM
REM Test the function clustering_factor
REM

SELECT index_name, clustering_factor
FROM user_indexes
WHERE table_name = 'T';

PAUSE

SELECT index_name, 
       clustering_factor(user, table_name, column_name) AS clust_factor
FROM user_ind_columns
WHERE table_name = 'T';

PAUSE

REM
REM Cleanup
REM

DROP TABLE t;
PURGE TABLE t;
DROP FUNCTION clustering_factor;
