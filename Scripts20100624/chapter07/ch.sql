SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: ch.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: Create a test table, named CH, which contains one row for
REM               each person living in Switzerland.
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

SET ECHO ON

DROP TABLE t;

CREATE TABLE t AS 
SELECT 0 n 
FROM 
dual CONNECT BY level <= 10000;

DROP TABLE ch;

CREATE TABLE ch (state VARCHAR2(2), language VARCHAR2(1), dummy NUMBER) NOLOGGING;

INSERT /*+ append */ INTO ch (state, language) SELECT 'AG','D' FROM t,t WHERE rownum <= 484475;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'AG','O' FROM t,t WHERE rownum <= 53397;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'AG','I' FROM t,t WHERE rownum <= 18355;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'AI','D' FROM t,t WHERE rownum <= 13930;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'AI','O' FROM t,t WHERE rownum <= 1064;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'AR','D' FROM t,t WHERE rownum <= 48508;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'AR','O' FROM t WHERE rownum <= 3776;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'AR','I' FROM t WHERE rownum <= 904;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'BE','D' FROM t,t WHERE rownum <= 798175;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'BE','F' FROM t,t WHERE rownum <= 72215;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'BE','O' FROM t,t WHERE rownum <= 60813;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'BE','I' FROM t,t WHERE rownum <= 19004;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'BL','D' FROM t,t WHERE rownum <= 229505;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'BL','O' FROM t,t WHERE rownum <= 20529;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'BL','I' FROM t WHERE rownum <= 9211;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'BL','F' FROM t WHERE rownum <= 3947;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'BS','D' FROM t,t WHERE rownum <= 148188;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'BS','O' FROM t,t WHERE rownum <= 25601;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'BS','I' FROM t WHERE rownum <= 9343;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'BS','F' FROM t WHERE rownum <= 4671;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'FR','F' FROM t,t WHERE rownum <= 153373;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'FR','D' FROM t,t WHERE rownum <= 70862;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'FR','O' FROM t,t WHERE rownum <= 18443;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'GE','F' FROM t,t WHERE rownum <= 317794;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'GE','O' FROM t,t WHERE rownum <= 85108;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'GE','D' FROM t,t WHERE rownum <= 16350;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'GL','D' FROM t,t WHERE rownum <= 32930;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'GL','O' FROM t WHERE rownum <= 3761;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'GL','I' FROM t WHERE rownum <= 1688;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'GR','D' FROM t,t WHERE rownum <= 127109;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'GR','R' FROM t,t WHERE rownum <= 26985;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'GR','I' FROM t,t WHERE rownum <= 18982;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'GR','O' FROM t,t WHERE rownum <= 13399;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'JU','F' FROM t,t WHERE rownum <= 62276;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'JU','D' FROM t WHERE rownum <= 3044;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'JU','O' FROM t WHERE rownum <= 2629;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'JU','I' FROM t WHERE rownum <= 1245;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'LU','D' FROM t,t WHERE rownum <= 313204;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'LU','O' FROM t,t WHERE rownum <= 32412;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'LU','I' FROM t WHERE rownum <= 6693;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'NE','F' FROM t,t WHERE rownum <= 142407;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'NE','O' FROM t,t WHERE rownum <= 12521;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'NE','D' FROM t WHERE rownum <= 6844;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'NE','I' FROM t WHERE rownum <= 5342;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'NW','D' FROM t,t WHERE rownum <= 35979;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'NW','O' FROM t WHERE rownum <= 2372;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'NW','I' FROM t WHERE rownum <= 544;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'OW','D' FROM t,t WHERE rownum <= 30458;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'OW','O' FROM t WHERE rownum <= 2540;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'SG','D' FROM t,t WHERE rownum <= 400569;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'SG','O' FROM t,t WHERE rownum <= 44153;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'SG','I' FROM t,t WHERE rownum <= 10469;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'SH','D' FROM t,t WHERE rownum <= 64750;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'SH','O' FROM t WHERE rownum <= 7243;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'SH','I' FROM t WHERE rownum <= 1921;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'SO','D' FROM t,t WHERE rownum <= 217663;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'SO','O' FROM t,t WHERE rownum <= 21199;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'SO','I' FROM t WHERE rownum <= 7641;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'SZ','D' FROM t,t WHERE rownum <= 119888;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'SZ','O' FROM t,t WHERE rownum <= 13469;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'TG','D' FROM t,t WHERE rownum <= 203445;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'TG','O' FROM t,t WHERE rownum <= 19999;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'TG','I' FROM t WHERE rownum <= 6436;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'TI','I' FROM t,t WHERE rownum <= 261401;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'TI','O' FROM t,t WHERE rownum <= 27052;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'TI','D' FROM t,t WHERE rownum <= 26108;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'UR','D' FROM t,t WHERE rownum <= 214939;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'UR','O' FROM t,t WHERE rownum <= 11953;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'UR','I' FROM t WHERE rownum <= 2988;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'VD','F' FROM t,t WHERE rownum <= 516975;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'VD','O' FROM t,t WHERE rownum <= 66991;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'VD','D' FROM t,t WHERE rownum <= 29703;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'VD','I' FROM t,t WHERE rownum <= 18327;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'VS','F' FROM t,t WHERE rownum <= 176480;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'VS','D' FROM t,t WHERE rownum <= 79809;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'VS','O' FROM t,t WHERE rownum <= 24729;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'ZG','D' FROM t,t WHERE rownum <= 87012;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'ZG','O' FROM t,t WHERE rownum <= 12678;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'ZG','I' FROM t WHERE rownum <= 2556;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'ZH','D' FROM t,t WHERE rownum <= 918843;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'ZH','O' FROM t,t WHERE rownum <= 156553;
COMMIT;
INSERT /*+ append */ INTO ch (state, language) SELECT 'ZH','I' FROM t,t WHERE rownum <= 49699;
COMMIT;

CREATE INDEX ch_state_i ON ch (state) NOLOGGING;

CREATE INDEX ch_language_i ON ch (language) NOLOGGING;

BEGIN
  dbms_stats.gather_table_stats(
    ownname => user,
    tabname => 'CH',       
    estimate_percent => 100,       
    method_opt => 'FOR ALL COLUMNS SIZE 100',
    cascade => TRUE
  );
END;
/

SELECT state, language, count(*)
FROM ch
GROUP BY state, language
ORDER BY state, count(*) DESC;

DROP TABLE t;
PURGE TABLE t;
