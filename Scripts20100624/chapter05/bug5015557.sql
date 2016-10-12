SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: bug5015557.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows that the initialization parameter 
REM               optimizer_features_enable disables bug fixes as well as
REM               regular features.
REM Notes.......: This script only works in 10.2.0.3 and 10.2.0.4.
REM Parameters..: -
REM
REM You can send feedbacks or questions about this script to top@antognini.ch.
REM
REM Changes:
REM DD.MM.YYYY Description
REM ---------------------------------------------------------------------------
REM 08.03.2009 Fixed hints + Added note about supported database releases
REM ***************************************************************************

SET TERMOUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET SCAN ON

@../connect.sql

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;

CREATE TABLE t(lot NUMBER(7), color NUMBER(2));
CREATE BITMAP INDEX bi1 ON t(to_char(lot));
CREATE BITMAP INDEX bi2 ON t(to_char(lot)||'/'||to_char(color)); 

PAUSE

REM
REM Reproduce bug
REM

SELECT /*+ optimizer_features_enable('10.2.0.3') 
           ordered 
           use_nl(hist) 
           index_combine(hist) */
       hist.lot
FROM 
(
  SELECT '5155745/1' client_load_id, 'COLOR' AS level_desc FROM dual
  UNION
  SELECT '5155745/29', 'COLOR' FROM dual
) mh, t hist
WHERE to_char(hist.lot) = to_char(mh.client_load_id)
OR (mh.level_desc = 'COLOR'
    AND
    hist.lot || '/' || hist.color = to_char(mh.client_load_id))
;

PAUSE

SELECT /*+ optimizer_features_enable('10.1.0.4') 
           ordered 
           use_nl(hist) 
           index_combine(hist) */
       hist.lot
FROM 
(
  SELECT '5155745/1' client_load_id, 'COLOR' AS level_desc FROM dual
  UNION
  SELECT '5155745/29', 'COLOR' FROM dual
) mh, t hist
WHERE to_char(hist.lot) = to_char(mh.client_load_id)
OR (mh.level_desc = 'COLOR'
    AND
    hist.lot || '/' || hist.color = to_char(mh.client_load_id))
;

