SET ECHO OFF
REM ***************************************************************************
REM ******************* Troubleshooting Oracle Performance ********************
REM ************************* http://top.antognini.ch *************************
REM ***************************************************************************
REM
REM File name...: mreadtim_lt_sreadtim.sql
REM Author......: Christian Antognini
REM Date........: August 2008
REM Description.: This script shows the correction performed by the query
REM               optimizer when mreadtim is smaller or equal to sreadtim.
REM Notes.......: The scripts changes the system statistics.
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

VARIABLE block_size NUMBER
VARIABLE ioseektim NUMBER
VARIABLE iotfrspeed NUMBER
VARIABLE sreadtim NUMBER
VARIABLE mreadtim NUMBER
VARIABLE mbrc NUMBER
VARIABLE dfmbrc NUMBER

SET ECHO ON

REM
REM Setup test environment
REM

DROP TABLE t;

CREATE TABLE t (
	n1 number,n2 number,n3 number,n4 number,n5 number,n6 number,n7 number,n8 number,n9 number,
	n10 number,n11 number,n12 number,n13 number,n14 number,n15 number,n16 number,n17 number,n18 number,n19 number,
	n20 number,n21 number,n22 number,n23 number,n24 number,n25 number,n26 number,n27 number,n28 number,n29 number,
	n30 number,n31 number,n32 number,n33 number,n34 number,n35 number,n36 number,n37 number,n38 number,n39 number,
	n40 number,n41 number,n42 number,n43 number,n44 number,n45 number,n46 number,n47 number,n48 number,n49 number,
	n50 number,n51 number,n52 number,n53 number,n54 number,n55 number,n56 number,n57 number,n58 number,n59 number,
	n60 number,n61 number,n62 number,n63 number,n64 number,n65 number,n66 number,n67 number,n68 number,n69 number,
	n70 number,n71 number,n72 number,n73 number,n74 number,n75 number,n76 number,n77 number,n78 number,n79 number,
	n80 number,n81 number,n82 number,n83 number,n84 number,n85 number,n86 number,n87 number,n88 number,n89 number,
	n90 number,n91 number,n92 number,n93 number,n94 number,n95 number,n96 number,n97 number,n98 number,n99 number,
	n100 number,n101 number,n102 number,n103 number,n104 number,n105 number,n106 number,n107 number,n108 number,n109 number,
	n110 number,n111 number,n112 number,n113 number,n114 number,n115 number,n116 number,n117 number,n118 number,n119 number,
	n120 number,n121 number,n122 number,n123 number,n124 number,n125 number,n126 number,n127 number,n128 number,n129 number,
	n130 number,n131 number,n132 number,n133 number,n134 number,n135 number,n136 number,n137 number,n138 number,n139 number,
	n140 number,n141 number,n142 number,n143 number,n144 number,n145 number,n146 number,n147 number,n148 number,n149 number,
	n150 number,n151 number,n152 number,n153 number,n154 number,n155 number,n156 number,n157 number,n158 number,n159 number,
	n160 number,n161 number,n162 number,n163 number,n164 number,n165 number,n166 number,n167 number,n168 number,n169 number,
	n170 number,n171 number,n172 number,n173 number,n174 number,n175 number,n176 number,n177 number,n178 number,n179 number,
	n180 number,n181 number,n182 number,n183 number,n184 number,n185 number,n186 number,n187 number,n188 number,n189 number,
	n190 number,n191 number,n192 number,n193 number,n194 number,n195 number,n196 number,n197 number,n198 number,n199 number,
	n200 number,n201 number,n202 number,n203 number,n204 number,n205 number,n206 number,n207 number,n208 number,n209 number,
	n210 number,n211 number,n212 number,n213 number,n214 number,n215 number,n216 number,n217 number,n218 number,n219 number,
	n220 number,n221 number,n222 number,n223 number,n224 number,n225 number,n226 number,n227 number,n228 number,n229 number,
	n230 number,n231 number,n232 number,n233 number,n234 number,n235 number,n236 number,n237 number,n238 number,n239 number,
	n240 number,n241 number,n242 number,n243 number,n244 number,n245 number,n246 number,n247 number,n248 number,n249 number,
	n250 number
);

INSERT INTO t SELECT 
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0
FROM dual
CONNECT BY level <= 10000;

COMMIT;

BEGIN
  SELECT block_size
  INTO :block_size
  FROM user_tablespaces, user_users
  WHERE tablespace_name = default_tablespace;

  dbms_stats.gather_table_stats(user,'t');

  :dfmbrc := 16;
  EXECUTE IMMEDIATE 'ALTER SESSION SET db_file_multiblock_read_count = '||:dfmbrc;
END;
/

DELETE plan_table;

DELETE sys.aux_stats$;

COMMIT;

PAUSE

REM
REM Noworkload system statistics
REM

BEGIN
  :ioseektim := 10;
  :iotfrspeed := 4096;

  dbms_stats.set_system_stats(pname=>'CPUSPEEDNW', pvalue=>1500);
  dbms_stats.set_system_stats(pname=>'IOSEEKTIM', pvalue=>:ioseektim);
  dbms_stats.set_system_stats(pname=>'IOTFRSPEED', pvalue=>:iotfrspeed);
END;
/

EXPLAIN PLAN SET STATEMENT_ID 'noworkload stats' FOR SELECT * FROM t;

PAUSE

REM
REM Workload system statistics (sreadtim=mreadtim)
REM

BEGIN
  :sreadtim := 6;
  :mreadtim := 6;
  :mbrc := 9;

  dbms_stats.set_system_stats(pname=>'CPUSPEED', pvalue=>1500);
  dbms_stats.set_system_stats(pname=>'SREADTIM', pvalue=>:sreadtim);
  dbms_stats.set_system_stats(pname=>'MREADTIM', pvalue=>:mreadtim);
  dbms_stats.set_system_stats(pname=>'MBRC', pvalue=>:mbrc);
  dbms_stats.set_system_stats(pname=>'MAXTHR', pvalue=>NULL);
  dbms_stats.set_system_stats(pname=>'SLAVETHR', pvalue=>NULL);
END;
/

EXPLAIN PLAN SET STATEMENT_ID 'mreadtim = sreadtim' FOR SELECT * FROM t;

PAUSE

REM
REM Workload system statistics (sreadtim>mreadtim)
REM

BEGIN
  dbms_stats.set_system_stats(pname=>'SREADTIM', pvalue=>:sreadtim+0.000000001);
  dbms_stats.set_system_stats(pname=>'MREADTIM', pvalue=>:mreadtim);
END;
/

EXPLAIN PLAN SET STATEMENT_ID 'mreadtim < sreadtim' FOR SELECT * FROM t;

PAUSE

REM
REM Workload system statistics (sreadtim<mreadtim)
REM

BEGIN
  dbms_stats.set_system_stats(pname=>'SREADTIM', pvalue=>:sreadtim);
  dbms_stats.set_system_stats(pname=>'MREADTIM', pvalue=>:mreadtim+0.000000001);
END;
/

EXPLAIN PLAN SET STATEMENT_ID 'mreadtim > sreadtim' FOR SELECT * FROM t;

PAUSE

REM
REM I/O costing
REM
REM In Oracle9i the hint no_cpu_costing does not exist. Therefore, the 
REM estimations related to the following query are not based on I/O costing.
REM

EXPLAIN PLAN SET STATEMENT_ID 'io costing' FOR SELECT /*+ no_cpu_costing */ * FROM t;

PAUSE

REM
REM Compare the estimations with the different sets of system statistics
REM

SELECT statement_id, cost, io_cost, cost-io_cost, cpu_cost
FROM plan_table
WHERE id = 0
ORDER BY statement_id;

SELECT ceil(blocks/1.6765/power(:dfmbrc,0.6581) + 1) AS io_cost_no_sys_stats,
       ceil(blocks/:mbrc * :mreadtim/:sreadtim + 1) AS io_cost_workload_stats, 
       ceil(blocks/:mbrc * (:ioseektim+:mbrc*:block_size/:iotfrspeed)/(:ioseektim+:block_size/:iotfrspeed)+1) AS io_cost_bad_workload_stats,
       ceil(blocks/:dfmbrc * (:ioseektim+:dfmbrc*:block_size/:iotfrspeed)/(:ioseektim+:block_size/:iotfrspeed)+1) AS io_cost_noworkload_stats
FROM user_tables
WHERE table_name = 'T';

PAUSE

REM
REM Cleanup
REM

DROP TABLE t;
PURGE TABLE t;
