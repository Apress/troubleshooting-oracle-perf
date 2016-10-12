/**************************************************************************
******************* Troubleshooting Oracle Performance ********************
************************* http://top.antognini.ch *************************
***************************************************************************

File name...: ParsingTest3.c
Author......: Christian Antognini
Date........: August 2008
Description.: This file contains an implementation of test case 2.
Notes.......: Run the script ParsingTest.sql to create the required objects.
Parameters. : -

You can send feedbacks or questions about this script to top@antognini.ch.

Changes:
DD.MM.YYYY Description
---------------------------------------------------------------------------

**************************************************************************/

#include <oci.h>


void checkerr(OCIError* err, char* msg, sword status) 
{
  text errbuf[512];
  ub4 buflen;
  ub4 errcode;

  switch (status) 
  {
    case OCI_SUCCESS:
      break;
    default:
      OCIErrorGet(err, 1, NULL, &errcode, errbuf, sizeof(errbuf), OCI_HTYPE_ERROR);
      printf("Error calling %s - %s\n", msg, errbuf);
      break;
  }
}


void parse_connect_string(char* connect_str, text username[30], text password[30], text dbname [30])
{
  username[0] = 0;
  password[0] = 0;
  dbname [0] = 0;

  char* to=username;

  while (*connect_str) 
  {
    if (*connect_str == '/') 
    {
      *to = 0;
      to = password;
      connect_str++;
      continue;
    }
    if (*connect_str == '@') 
    {
      *to = 0;
      to = dbname;
      connect_str++;
      continue;
    }
    *to = *connect_str;
    to++;
    connect_str++;
  }
  *to=0;
}

int main(int argc, char* argv[]) 
{
  OCIEnv* env = 0;
  OCIError* err = 0;
  OCISvcCtx* svc = 0;
  OCIStmt* stm = 0;
  OCIDefine* def = 0;
  OCIBind* bnd = 0;

  text username[30];
  text password[30];
  text dbname [30];
  text *sql = (text *)"SELECT pad FROM t WHERE val = :1";
  text val[4000];

  sword r;

  if (argc != 2) 
  {
    printf("usage: %s username/password[@dbname]\n", argv[0]);
    exit (-1);
  }

  parse_connect_string(argv[1], username, password, dbname);

  OCIEnvCreate(&env, OCI_DEFAULT, 0, 0, 0, 0, 0, 0);
  OCIHandleAlloc(env, (dvoid *)&err, OCI_HTYPE_ERROR, 0, 0);

  if (r = OCILogon2(env, err, &svc, username, strlen(username), password, strlen(password), dbname, strlen(dbname), OCI_DEFAULT) != OCI_SUCCESS) 
  //if (r = OCILogon2(env, err, &svc, username, strlen(username), password, strlen(password), dbname, strlen(dbname), OCI_LOGON2_STMTCACHE) != OCI_SUCCESS) 
  {
    checkerr(err, "OCILogon2", r);
    goto clean_up;
  }

  /*
  ub4 size = 50;
  OCIAttrSet(svc, OCI_HTYPE_SVCCTX, &size, 0, OCI_ATTR_STMTCACHESIZE, err);
  size = 0;
  OCIAttrGet(svc, OCI_HTYPE_SVCCTX, &size, NULL, OCI_ATTR_STMTCACHESIZE, err);
  printf("cache size %i\n", size);
  */

  int i;
  for (i=1 ; i<=10000 ; i++)
  {
    if (r = OCIStmtPrepare2(svc, (OCIStmt **)&stm, err, sql, strlen(sql), NULL, 0, OCI_NTV_SYNTAX, OCI_DEFAULT) != OCI_SUCCESS)
    {
      checkerr(err, "OCIStmtPrepare2", r);
      goto clean_up;
    }

    if (r = OCIDefineByPos(stm, &def, err, 1, val, sizeof(val), SQLT_STR, 0, 0, 0, OCI_DEFAULT) != OCI_SUCCESS)
    {
      checkerr(err, "OCIDefineByPos", r);
      goto clean_up;
    }

    if (r = OCIBindByPos(stm, &bnd, err, 1, &i, sizeof(i), SQLT_INT, 0, 0, 0, 0, 0, OCI_DEFAULT) != OCI_SUCCESS)
    {
      checkerr(err, "OCIBindByPos", r);
      goto clean_up;
    }

    if (r = OCIStmtExecute(svc, stm, err, 0, 0, 0, 0, OCI_DEFAULT) != OCI_SUCCESS)
    {
      checkerr(err, "OCIStmtExecute", r);
      goto clean_up;
    }

    if (r = OCIStmtFetch2(stm, err, 1, OCI_FETCH_NEXT, 0, OCI_DEFAULT) == OCI_SUCCESS)
    {
      //printf("%i - %s\n", i, val);
    }

    if (r = OCIStmtRelease(stm, err, NULL, 0, OCI_DEFAULT) != OCI_SUCCESS)
    {
      checkerr(err, "OCIStmtRelease", r);
      goto clean_up;
    }
  }

  if (r = OCILogoff(svc, err) != OCI_SUCCESS)
  {
    checkerr(err, "OCILogoff", r);
  }

  clean_up:
    if (stm) OCIHandleFree(stm, OCI_HTYPE_STMT);
    if (err) OCIHandleFree(err, OCI_HTYPE_ERROR);
    if (svc) OCIHandleFree(svc, OCI_HTYPE_SVCCTX);
    if (env) OCIHandleFree(env, OCI_HTYPE_ENV);

  return 0;
}

