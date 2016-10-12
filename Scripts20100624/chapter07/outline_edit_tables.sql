SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: outline_edit_tables.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script creates the working tables and public synonym
REM               necessary to edit private outlines.
REM Notes.......: This script is meant to be executed in Oracle9i.
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
SET ECHO ON

CONNECT &sysdba_user/&sysdba_password@&service AS SYSDBA

ALTER SESSION SET current_schema = system;

execute dbms_outln_edit.create_edit_tables

CREATE OR REPLACE PUBLIC SYNONYM ol$ FOR system.ol$;
CREATE OR REPLACE PUBLIC SYNONYM ol$hints FOR system.ol$hints;
CREATE OR REPLACE PUBLIC SYNONYM ol$nodes FOR system.ol$nodes;

GRANT SELECT,INSERT,UPDATE,DELETE ON system.ol$ TO public;
GRANT SELECT,INSERT,UPDATE,DELETE ON system.ol$hints TO public;
GRANT SELECT,INSERT,UPDATE,DELETE ON system.ol$nodes TO public;
