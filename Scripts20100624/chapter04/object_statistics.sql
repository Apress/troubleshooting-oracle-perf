SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: object_statistics.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script provides an overview of all object statistics.
REM Notes.......: Since also extended statistics are shown, the scripts only
REM               works in Oracle Database 11g.
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

SET SERVEROUTPUT ON

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;

execute dbms_random.seed(0)

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

UPDATE t SET val1 = NULL WHERE val1 < 0;

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

REM
REM Table statistics
REM

SELECT num_rows, blocks, empty_blocks, avg_space, chain_cnt, avg_row_len
FROM user_tab_statistics
WHERE table_name = 'T';

PAUSE

REM
REM Column statistics
REM

COLUMN name FORMAT A4
COLUMN #dst FORMAT 9999
COLUMN low_value FORMAT A14
COLUMN high_value FORMAT A14
COLUMN dens FORMAT .99999
COLUMN #null FORMAT 9999
COLUMN avglen FORMAT 9999
COLUMN histogram FORMAT A15
COLUMN #bkt FORMAT 9999

SELECT column_name AS "NAME", 
       num_distinct AS "#DST", 
       low_value, 
       high_value, 
       density AS "DENS", 
       num_nulls AS "#NULL", 
       avg_col_len AS "AVGLEN", 
       histogram, 
       num_buckets AS "#BKT"
FROM user_tab_col_statistics
WHERE table_name = 'T';

PAUSE

COLUMN low_value FORMAT 9999
COLUMN high_value FORMAT 9999

SELECT utl_raw.cast_to_number(low_value) AS low_value,
       utl_raw.cast_to_number(high_value) AS high_value
FROM user_tab_col_statistics
WHERE table_name = 'T'
AND column_name = 'VAL1';

PAUSE

DECLARE
  l_low_value user_tab_col_statistics.low_value%TYPE;
  l_high_value user_tab_col_statistics.high_value%TYPE;
  l_val1 t.val1%TYPE;
BEGIN
  SELECT low_value, high_value
  INTO l_low_value, l_high_value
  FROM user_tab_col_statistics
  WHERE table_name = 'T'
  AND column_name = 'VAL1';
  
  dbms_stats.convert_raw_value(l_low_value, l_val1);
  dbms_output.put_line('low_value: ' || l_val1);
  dbms_stats.convert_raw_value(l_high_value, l_val1);
  dbms_output.put_line('high_value: ' || l_val1);
END;
/

PAUSE

REM
REM Histograms
REM

SELECT val2 AS val2, count(*)
FROM t
GROUP BY val2
ORDER BY val2;

PAUSE

SELECT endpoint_value, endpoint_number,
       endpoint_number - lag(endpoint_number,1,0) 
                         OVER (ORDER BY endpoint_number) AS frequency
FROM user_tab_histograms
WHERE table_name = 'T'
AND column_name = 'VAL2'
ORDER BY endpoint_number;

PAUSE

DELETE plan_table;
EXPLAIN PLAN SET STATEMENT_ID '101' FOR SELECT * FROM t WHERE val2 = 101;
EXPLAIN PLAN SET STATEMENT_ID '102' FOR SELECT * FROM t WHERE val2 = 102;
EXPLAIN PLAN SET STATEMENT_ID '103' FOR SELECT * FROM t WHERE val2 = 103;
EXPLAIN PLAN SET STATEMENT_ID '104' FOR SELECT * FROM t WHERE val2 = 104;
EXPLAIN PLAN SET STATEMENT_ID '105' FOR SELECT * FROM t WHERE val2 = 105;
EXPLAIN PLAN SET STATEMENT_ID '106' FOR SELECT * FROM t WHERE val2 = 106;

COLUMN statement_id FORMAT A12

SELECT statement_id, cardinality
FROM plan_table
WHERE id = 0
ORDER BY statement_id;

PAUSE

SELECT count(*), max(val2), bucket
FROM (
  SELECT val2, ntile(5) OVER (ORDER BY val2) AS bucket
  FROM t
)
GROUP BY bucket
ORDER BY bucket;

PAUSE

SELECT count(*), max(val2) AS endpoint_value, endpoint_number
FROM (
  SELECT val2, ntile(5) OVER (ORDER BY val2) AS endpoint_number
  FROM t
)
GROUP BY endpoint_number
ORDER BY endpoint_number;

PAUSE

BEGIN
  dbms_stats.gather_table_stats(
    ownname          => user,
    tabname          => 'T',
    estimate_percent => 100,
    method_opt       => 'for all columns size 5',
    cascade          => TRUE
  );
END;
/

PAUSE

SELECT endpoint_value, endpoint_number
FROM user_tab_histograms
WHERE table_name = 'T'
AND column_name = 'VAL2'
ORDER BY endpoint_number;

PAUSE

UPDATE t SET val2 = 105 WHERE val2 = 106 AND rownum <= 13;

PAUSE

REM
REM Extended statistics
REM

SELECT dbms_stats.create_extended_stats(ownname   => user,
                                        tabname   => 'T',
                                        extension => '(upper(pad))'),
       dbms_stats.create_extended_stats(ownname   => user,
                                        tabname   => 'T',
                                        extension => '(val2,val3)')
FROM dual;

PAUSE

SELECT extension_name, extension
FROM user_stat_extensions
WHERE table_name = 'T';

PAUSE

COLUMN column_name FORMAT A30
COLUMN data_type FORMAT A9
COLUMN hidden_column FORMAT A6

SELECT column_name, data_type, hidden_column, data_default
FROM user_tab_cols
WHERE table_name = 'T'
ORDER BY column_id;

PAUSE

COLUMN name FORMAT A10
COLUMN name FORMAT A10

DROP TABLE persons;

CREATE TABLE persons (
  name VARCHAR2(100),
  name_upper AS (upper(name))
);

INSERT INTO persons (name) VALUES ('Michelle');

SELECT name 
FROM persons
WHERE name_upper = 'MICHELLE';

PAUSE

REM
REM Index statistics
REM

COLUMN name FORMAT A10
COLUMN blevel FORMAT 9
COLUMN leaf_blks FORMAT 99999
COLUMN dst_keys FORMAT 99999
COLUMN num_rows FORMAT 99999
COLUMN clust_fact FORMAT 99999
COLUMN leaf_per_key FORMAT 99999
COLUMN data_per_key FORMAT 99999

SELECT index_name AS name, 
       blevel, 
       leaf_blocks AS leaf_blks, 
       distinct_keys AS dst_keys, 
       num_rows, 
       clustering_factor AS clust_fact,
       avg_leaf_blocks_per_key AS leaf_per_key, 
       avg_data_blocks_per_key AS data_per_key
FROM user_ind_statistics
WHERE table_name = 'T';

REM
REM Cleanup
REM

BEGIN
  dbms_stats.drop_extended_stats(ownname   => user, 
                                 tabname   => 'T', 
                                 extension => '(upper(pad))');
  dbms_stats.drop_extended_stats(ownname   => user, 
                                 tabname   => 'T', 
                                 extension => '(val2,val3)');
END;
/

DROP TABLE t;
PURGE TABLE t;

DROP TABLE persons;
PURGE TABLE persons;
