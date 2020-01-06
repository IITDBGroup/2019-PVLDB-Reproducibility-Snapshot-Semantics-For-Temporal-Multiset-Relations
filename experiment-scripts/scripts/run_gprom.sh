#!/bin/bash


GPROMDIR=/gprom/src
QUERYDIR=/reproducibility/experiment-scripts/gprom_queries

if [ ! -d "$QUERYDIR" ];
then
        mkdir $QUERYDIR
fi;

echo -e "Generate q1.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db time_tpch_1gb -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL(SELECT l_returnflag, l_linestatus, sum(l_quantity) as sum_qty, sum(l_extendedprice) as sum_base_price, sum(l_extendedprice * (1 - l_discount)) as sum_disc_price, sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_charge, avg(l_quantity) as avg_qty, avg(l_extendedprice) as avg_price, avg(l_discount) as avg_disc, count(*) as count_order FROM time_lineitem WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) WHERE l_shipdate <= TO_DATE('1998-12-01', 'YYYY-MM-DD') GROUP BY l_returnflag, l_linestatus );" -Pexecutor sql -backend postgres -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/q1.sql


echo -e "Generate q5.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db time_tpch_1gb -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SELECT * FROM (SEQUENCED TEMPORAL(SELECT n_name, sum(l_extendedprice * (1 - l_discount)) as revenue FROM time_customer WITH TIME (VISIBLE_TIME_BEGIN, VISIBLE_TIME_END), time_orders WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_lineitem WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_supplier WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_nation WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_region WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) WHERE c_custkey = o_custkey AND l_orderkey = o_orderkey AND l_suppkey = s_suppkey AND c_nationkey = s_nationkey AND s_nationkey = n_nationkey AND n_regionkey = r_regionkey AND r_name = 'AMERICA' AND o_orderdate >= TO_DATE('1995-01-01', 'YYYY-MM-DD') AND o_orderdate < TO_DATE('1995-02-01','YYYY-MM-DD') GROUP BY n_name)) ORDER BY revenue DESC;" -backend postgres -Pexecutor sql -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/q5.sql


echo -e "Generate q6.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db time_tpch_1gb -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL(SELECT sum(l_extendedprice * l_discount) as revenue FROM time_lineitem WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) WHERE l_shipdate >= TO_DATE('1995-01-01', 'YYYY-MM-DD') AND l_shipdate < TO_DATE('1996-01-01', 'YYYY-MM-DD') AND l_discount > 0.05 - 0.01 AND l_discount < 0.05 + 0.01 AND l_quantity < 25);" -backend postgres -Pexecutor sql -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE  > $QUERYDIR/q6.sql


echo -e "Generate q7.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db time_tpch_1gb -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SELECT * FROM (SEQUENCED TEMPORAL(SELECT supp_nation, cust_nation, sum(volume) AS revenue FROM (SELECT n1.n_name AS supp_nation, n2.n_name AS cust_nation, l_extendedprice * (1 - l_discount) AS volume FROM time_supplier WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_lineitem WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_orders WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_customer WITH TIME (VISIBLE_TIME_BEGIN, VISIBLE_TIME_END), time_nation WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) n1, time_nation WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) n2 WHERE s_suppkey = l_suppkey AND o_orderkey = l_orderkey AND c_custkey = o_custkey AND s_nationkey = n1.n_nationkey AND c_nationkey = n2.n_nationkey AND ((n1.n_name = 'EGYPT' AND n2.n_name = 'IRAQ') OR (n1.n_name = 'IRAQ' AND n2.n_name = 'EGYPT')) AND l_shipdate > TO_DATE('1995-01-01', 'YYYY-MM-DD') AND l_shipdate < TO_DATE('1996-12-31', 'YYYY-MM-DD')) GROUP BY supp_nation, cust_nation)) ORDER BY supp_nation, cust_nation;" -backend postgres -Pexecutor sql -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/q7.sql


echo -e "Generate q8.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db time_tpch_1gb -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SELECT * FROM (SEQUENCED TEMPORAL(SELECT o_year, sum(CASE WHEN nation = 'ALGERIA' THEN volume ELSE 0 END) / sum(volume) AS mkt_share FROM (SELECT to_char(o_orderdate, 'YYYY') AS o_year, l_extendedprice * (1 - l_discount) AS volume, n2.n2_name AS nation FROM time_part WITH TIME (AVAILABLE_TIME_BEGIN, AVAILABLE_TIME_END), time_supplier WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_lineitem WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_orders WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_customer WITH TIME (VISIBLE_TIME_BEGIN, VISIBLE_TIME_END), time_nation WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) n1, (SELECT n_nationkey AS n2_nationkey, n_name AS n2_name FROM time_nation WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END)) n2, time_region WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) WHERE p_partkey = l_partkey  AND s_suppkey = l_suppkey  AND l_orderkey = o_orderkey  AND o_custkey = c_custkey  AND c_nationkey = n1.n_nationkey  AND n1.n_regionkey = r_regionkey  AND r_name = 'AFRICA'  AND s_nationkey = n2.n2_nationkey  AND o_orderdate >= TO_DATE('1995-01-01', 'YYYY-MM-DD')  AND o_orderdate <= TO_DATE('1996-12-31', 'YYYY-MM-DD')  AND p_type = 'PROMO BRUSHED COPPER') GROUP BY o_year)) ORDER BY o_year;" -backend postgres -Pexecutor sql -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/q8.sql

echo -e "Generate q9.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db time_tpch_1gb -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SELECT * FROM (SEQUENCED TEMPORAL(SELECT nation, o_year, sum(amount) AS sum_profit FROM (SELECT n_name AS nation, to_char(o_orderdate, 'YYYY') AS o_year, l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity AS amount FROM time_part WITH TIME (AVAILABLE_TIME_BEGIN, AVAILABLE_TIME_END), time_supplier WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_lineitem WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_partsupp WITH TIME (VALIDITY_TIME_BEGIN, VALIDITY_TIME_END), time_orders WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_nation WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) where s_suppkey = l_suppkey AND  ps_suppkey = l_suppkey AND  ps_partkey = l_partkey AND  p_partkey = l_partkey AND  o_orderkey = l_orderkey AND  s_nationkey = n_nationkey AND  p_name LIKE '%orange%') GROUP BY nation, o_year)) ORDER BY nation, o_year desc;" -backend postgres -Pexecutor sql -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/q9.sql

echo -e "Generate q12.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db time_tpch_1gb -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SELECT * FROM (SEQUENCED TEMPORAL(SELECT l_shipmode,sum(CASE WHEN o_orderpriORity = '1-URGENT' OR o_orderpriority = '2-HIGH' THEN 1 ELSE 0 END) AS high_line_count, sum(CASE WHEN o_orderpriORity <> '1-URGENT' AND o_orderpriORity <> '2-HIGH' THEN 1 ELSE 0 END) AS low_line_count FROM time_orders WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_lineitem WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END) WHERE o_orderkey = l_orderkey AND (l_shipmode = 'AIR' OR l_shipmode = 'MAIL') AND l_commitdate < l_receiptdate AND l_shipdate < l_commitdate AND l_receiptdate >= TO_DATE('1995-01-01', 'YYYY-MM-DD') AND l_receiptdate < TO_DATE('1996-01-01', 'YYYY-MM-DD') GROUP BY l_shipmode)) ORDER BY l_shipmode;" -backend postgres -Pexecutor sql -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/q12.sql


echo -e "Generate q14.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db time_tpch_1gb -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL(SELECT 100.00 * sum(CASE WHEN p_type LIKE 'PROMO%' THEN l_extendedprice * (1 - l_discount) ELSE 0 END) / sum(l_extendedprice * (1 - l_discount)) AS promo_revenue FROM time_lineitem WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_part WITH TIME (AVAILABLE_TIME_BEGIN, AVAILABLE_TIME_END) WHERE l_partkey = p_partkey AND l_shipdate >= TO_DATE('1997-12-01', 'YYYY-MM-DD') AND l_shipdate < TO_DATE('1998-12-01', 'YYYY-MM-DD'));" -backend postgres -Pexecutor sql -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/q14.sql


echo -e "Generate q19.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db time_tpch_1gb -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL(SELECT sum(l_extendedprice* (1 - l_discount)) AS revenue FROM time_lineitem WITH TIME (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END), time_part WITH TIME (AVAILABLE_TIME_BEGIN, AVAILABLE_TIME_END) WHERE (p_partkey = l_partkey AND p_Brand = 'Brand#22' AND (p_container = 'SM CASE' OR p_container = 'SM BOX' OR p_container = 'SM PACK' OR p_container = 'SM PKG') AND l_quantity >= 2 AND l_quantity <= 2 + 10 AND p_size >= 1 AND p_size <= 5 AND (l_shipmode ='AIR' OR l_shipmode = 'AIR REG') AND l_shipinstruct = 'DELIVER IN PERSON') OR (p_partkey = l_partkey AND p_Brand = 'Brand#32' AND (p_container = 'MED BAG' OR p_container = 'MED BOX' OR p_container = 'MED PKG' OR p_container = 'MED PACK') AND l_quantity >= 19 AND l_quantity <= 19 + 10 AND p_size >= 1 AND p_size <= 10 AND (l_shipmode ='AIR' OR l_shipmode = 'AIR REG') AND l_shipinstruct = 'DELIVER IN PERSON') OR (p_partkey = l_partkey AND p_Brand = 'Brand#43' AND (p_container = 'LG CASE' OR p_container = 'LG BOX' OR p_container = 'LG PACK' OR p_container = 'LG PKG') AND l_quantity >= 21 AND l_quantity <= 21 + 10 AND p_size >= 1 AND p_size <= 15 AND (l_shipmode ='AIR' OR l_shipmode = 'AIR REG') AND l_shipinstruct = 'DELIVER IN PERSON'));" -backend postgres -Pexecutor sql -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/q19.sql



echo -e "Generate join1.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (SELECT dept_no, a.emp_no, salary FROM DEPT_EMP WITH TIME (from_date, to_date) a ,SALARIES WITH TIME (from_date, to_date) b WHERE a.emp_no = b.emp_no);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/join1.sql


echo -e "Generate join2.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (SELECT title, salary, a.dept_no FROM dept_emp WITH TIME (from_date, to_date) a, salaries WITH TIME (from_date, to_date) b, titles WITH TIME (from_date, to_date) c WHERE a.emp_no = b.emp_no AND a.emp_no = c.emp_no);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/join2.sql

echo -e "Generate join3.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (select a.emp_no, dept_no FROM dept_manager WITH TIME (from_date, to_date) a, salaries WITH TIME (from_date, to_date) b WHERE a.emp_no = b.emp_no AND salary > 70000);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/join3.sql


echo -e "Generate join4.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (select a.emp_no, a.dept_no, b.salary, e.first_name, e.last_name FROM dept_manager WITH TIME (from_date, to_date) a, salaries WITH TIME (from_date, to_date) b, (SELECT emp_no AS emp_no, first_name AS first_name, last_name AS last_name, hire_date AS HIRE_DATE, TO_DATE('9999-01-01', 'SYYYY-MM-DD') AS END_HIRE FROM employees) WITH TIME(HIRE_DATE, END_HIRE) e WHERE a.emp_no = b.emp_no AND a.emp_no = e.emp_no);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_agg_combine_with_norm TRUE -temporal_use_coalesce TRUE -temporal_use_normalization TRUE > $QUERYDIR/join4.sql



echo -e "Generate agg1.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (SELECT dept_no, AVG(salary) as avg_salary FROM dept_emp WITH TIME (from_date, to_date) a, salaries WITH TIME (from_date, to_date) b WHERE a.emp_no = b.emp_no GROUP BY dept_no);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/agg1.sql


echo -e "Generate agg2.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (SELECT dept_no, AVG(salary) as avg_salary FROM dept_manager WITH TIME (from_date, to_date) a, salaries WITH TIME (from_date, to_date) b WHERE a.emp_no = b.emp_no GROUP BY dept_no);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/agg2.sql


echo -e "Generate agg3.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (SELECT count(1) FROM (SELECT count(*) AS c, dept_no FROM dept_emp WITH TIME (from_date, to_date) WHERE emp_no < 10282 GROUP BY dept_no HAVING count(*) > 21) s);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/agg3.sql


echo -e "Generate agg_join.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (SELECT d.emp_no, e.first_name, e.last_name, maxS.max_salary, d.dept_no FROM (SELECT MAX(salary) as max_salary,dept_no AS dept_no FROM dept_emp WITH TIME (from_date, to_date) a JOIN salaries WITH TIME (from_date, to_date) b ON (a.emp_no = b.emp_no) GROUP BY dept_no) maxS, salaries WITH TIME (from_date, to_date) s, dept_emp WITH TIME (from_date, to_date) d, (SELECT emp_no AS emp_no, first_name AS first_name, last_name AS last_name, hire_date AS hire_date, TO_DATE('9999-01-01', 'SYYYY-MM-DD') AS end_hire FROM employees)  WITH TIME (hire_date, end_hire) e WHERE e.emp_no = s.emp_no AND s.salary = max_salary AND d.dept_no = maxS.dept_no AND d.emp_no = e.emp_no);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_agg_combine_with_norm FALSE -temporal_use_coalesce TRUE -temporal_use_normalization TRUE > $QUERYDIR/agg_join.sql


echo -e "Generate diff1.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (SELECT emp_no FROM dept_emp WITH TIME (from_date, to_date) MINUS ALL SELECT emp_no FROM dept_manager WITH TIME (from_date, to_date));" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/diff1.sql



echo -e "Generate diff2.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (SELECT a.emp_no, salary FROM (SELECT emp_no FROM dept_emp WITH TIME (from_date, to_date) MINUS ALL SELECT emp_no FROM dept_manager WITH TIME (from_date, to_date)) a, salaries WITH TIME (from_date, to_date) b WHERE a.emp_no = b.emp_no);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE -temporal_use_normalization TRUE -temporal_agg_combine_with_norm TRUE > $QUERYDIR/diff2.sql


echo -e "Generate q3000k.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (select a.emp_no, salary from dept_emp WITH TIME (from_date, to_date) a JOIN salaries WITH TIME (from_date, to_date) b ON (a.emp_no = b.emp_no) WHERE salary > 10000);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE > $QUERYDIR/q3000k.sql


echo -e "Generate q1000k.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (select a.emp_no, salary from dept_emp WITH TIME (from_date, to_date) a JOIN salaries WITH TIME (from_date, to_date) b ON (a.emp_no = b.emp_no) WHERE salary > 70000);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE > $QUERYDIR/q1000k.sql


echo -e "Generate q500k.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (select a.emp_no, salary from dept_emp WITH TIME (from_date, to_date) a JOIN salaries WITH TIME (from_date, to_date) b ON (a.emp_no = b.emp_no) WHERE salary > 81000);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE > $QUERYDIR/q500k.sql


echo -e "Generate q300k.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (select a.emp_no, salary from dept_emp WITH TIME (from_date, to_date) a JOIN salaries WITH TIME (from_date, to_date) b ON (a.emp_no = b.emp_no) WHERE salary > 88000);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE > $QUERYDIR/q300k.sql



echo -e "Generate q100k.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (select a.emp_no, salary from dept_emp WITH TIME (from_date, to_date) a JOIN salaries WITH TIME (from_date, to_date) b ON (a.emp_no = b.emp_no) WHERE salary > 100000);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE > $QUERYDIR/q100k.sql


echo -e "Generate q10k.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (select a.emp_no, salary from dept_emp WITH TIME (from_date, to_date) a JOIN salaries WITH TIME (from_date, to_date) b ON (a.emp_no = b.emp_no) WHERE salary > 119000);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE > $QUERYDIR/q10k.sql



echo -e "Generate q1k.sql in $QUERYDIR"
$GPROMDIR/src/command_line/gprom -host 127.0.0.1 -db employees -port 5432 -user postgres -passwd test -log -loglevel 0 -sql "SEQUENCED TEMPORAL (select a.emp_no, salary from dept_emp WITH TIME (from_date, to_date) a JOIN salaries WITH TIME (from_date, to_date) b ON (a.emp_no = b.emp_no) WHERE salary > 133000);" -backend postgres -Pexecutor sql  -Cattr_reference_consistency FALSE -Cdata_structure_consistency FALSE -Cschema_consistency FALSE -Cparent_child_links FALSE -temporal_use_coalesce TRUE > $QUERYDIR/q1k.sql

