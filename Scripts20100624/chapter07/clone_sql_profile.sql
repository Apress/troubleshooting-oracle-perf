SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: clone_sql_profile.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows how to create a copy of a SQL profile. The 
REM               profile to be copied must already exist.
REM Notes.......: This script requires Oracle Database 10g Release 2 or later.
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

UNDEFINE sql_profile_name
UNDEFINE sql_profile_category

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE mystgtab PURGE;

BEGIN
  dbms_sqltune.create_stgtab_sqlprof(
    table_name      => 'MYSTGTAB',
    schema_name     => user,
    tablespace_name => 'USERS'
  );
END;
/

PAUSE

REM
REM "Export" SQL profile
REM

SELECT name, category
FROM dba_sql_profiles;

BEGIN
  dbms_sqltune.pack_stgtab_sqlprof(
    profile_name         => '&&sql_profile_name',
    profile_category     => '&&sql_profile_category',
    staging_table_name   => 'MYSTGTAB',
    staging_schema_owner => user
  );
END;
/

PAUSE

REM
REM Change name and category
REM

BEGIN
  dbms_sqltune.remap_stgtab_sqlprof(
    old_profile_name         => '&&sql_profile_name',
    new_profile_name         => '&&sql_profile_name'||'_CLONE',
    new_profile_category     => '&&sql_profile_category'||'_CLONE',
    staging_table_name   => 'MYSTGTAB',
    staging_schema_owner => user
  );
END;
/

PAUSE

REM
REM "Import" SQL profile
REM

SELECT name, sql_text
FROM dba_sql_profiles
WHERE category = '&&sql_profile_category'||'-CLONE';

BEGIN
  dbms_sqltune.unpack_stgtab_sqlprof(
    profile_name         => '&&sql_profile_name'||'_CLONE',
    profile_category     => '&&sql_profile_category'||'_CLONE',
    replace              => TRUE,
    staging_table_name   => 'MYSTGTAB',
    staging_schema_owner => user
  );
END;
/

SELECT name, sql_text
FROM dba_sql_profiles
WHERE category = '&&sql_profile_category'||'_CLONE';

PAUSE

REM
REM Cleanup
REM

DROP TABLE mystgtab PURGE;

BEGIN
  dbms_sqltune.drop_sql_profile(name=>'&&sql_profile_name'||'_CLONE');
END;
/

UNDEFINE sql_profile_name
UNDEFINE sql_profile_category
