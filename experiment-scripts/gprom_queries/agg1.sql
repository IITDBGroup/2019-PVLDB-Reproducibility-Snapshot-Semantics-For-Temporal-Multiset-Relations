WITH _temp_view_3 AS (
SELECT /*+ materialize */ sum(F0."salary") AS "AGGR_0_avg_sum", count(1) AS "AGGR_0_avg_cnt", count(1) AS "open_inter_c_", F0."dept_no" AS "GROUP_0", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F1."emp_no" AS "emp_no1", F1."salary" AS "salary", greatest(F0."t_b", F1."t_b") AS "t_b", least(F0."t_e", F1."t_e") AS "t_e"
FROM ((
SELECT F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F0."from_date" AS "t_b", F0."to_date" AS "t_e"
FROM "dept_emp" AS F0) F0 JOIN (
SELECT F0."emp_no" AS "emp_no", F0."salary" AS "salary", F0."from_date" AS "t_b", F0."to_date" AS "t_e"
FROM "salaries" AS F0) F1 ON (((F0."t_b" <= F1."t_e") AND (F1."t_b" <= F0."t_e"))))) F0
WHERE (F0."emp_no" = F0."emp_no1")
GROUP BY F0."dept_no", F0."t_b", F0."t_e"),
_temp_view_2 AS (
SELECT /*+ materialize */ F0."AGGR_0" AS "AGGR_0", F0."GROUP_0" AS "GROUP_0", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT (CASE  WHEN ((F0."W_ADD__AGGR_0_avg_cnt" - F0."W_DEC__AGGR_0_avg_cnt") = 0) THEN (NULL)::float8 ELSE ((F0."W_ADD__AGGR_0_avg_sum" - F0."W_DEC__AGGR_0_avg_sum") / (F0."W_ADD__AGGR_0_avg_cnt" - F0."W_DEC__AGGR_0_avg_cnt")) END) AS "AGGR_0", (F0."W_ADD__AGGR_0_avg_cnt" - F0."W_DEC__AGGR_0_avg_cnt") AS "open_inter_c_", F0."GROUP_0" AS "GROUP_0", F0."ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
FROM (
SELECT "ADD__AGGR_0_avg_sum" AS "ADD__AGGR_0_avg_sum", "ADD__AGGR_0_avg_cnt" AS "ADD__AGGR_0_avg_cnt", "ADD__open_inter_c_" AS "ADD__open_inter_c_", "DEC__AGGR_0_avg_sum" AS "DEC__AGGR_0_avg_sum", "DEC__AGGR_0_avg_cnt" AS "DEC__AGGR_0_avg_cnt", "DEC__open_inter_c_" AS "DEC__open_inter_c_", "GROUP_0" AS "GROUP_0", "ts" AS "ts", sum(F0."ADD__AGGR_0_avg_sum") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_ADD__AGGR_0_avg_sum", sum(F0."ADD__AGGR_0_avg_cnt") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_ADD__AGGR_0_avg_cnt", sum(F0."ADD__open_inter_c_") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_ADD__open_inter_c_", sum(F0."DEC__AGGR_0_avg_sum") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_DEC__AGGR_0_avg_sum", sum(F0."DEC__AGGR_0_avg_cnt") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_DEC__AGGR_0_avg_cnt", sum(F0."DEC__open_inter_c_") OVER (PARTITION BY F0."GROUP_0" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) AS "W_DEC__open_inter_c_"
FROM (
SELECT sum(F0."ADD__AGGR_0_avg_sum") AS "ADD__AGGR_0_avg_sum", sum(F0."ADD__AGGR_0_avg_cnt") AS "ADD__AGGR_0_avg_cnt", sum(F0."ADD__open_inter_c_") AS "ADD__open_inter_c_", sum(F0."DEC__AGGR_0_avg_sum") AS "DEC__AGGR_0_avg_sum", sum(F0."DEC__AGGR_0_avg_cnt") AS "DEC__AGGR_0_avg_cnt", sum(F0."DEC__open_inter_c_") AS "DEC__open_inter_c_", F0."GROUP_0" AS "GROUP_0", F0."ts" AS "ts"
FROM (
SELECT F0."AGGR_0_avg_sum" AS "ADD__AGGR_0_avg_sum", F0."AGGR_0_avg_cnt" AS "ADD__AGGR_0_avg_cnt", F0."open_inter_c_" AS "ADD__open_inter_c_", 0 AS "DEC__AGGR_0_avg_sum", 0 AS "DEC__AGGR_0_avg_cnt", 0 AS "DEC__open_inter_c_", F0."GROUP_0" AS "GROUP_0", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_3) F0 UNION ALL 
SELECT 0 AS "ADD__AGGR_0_avg_sum", 0 AS "ADD__AGGR_0_avg_cnt", 0 AS "ADD__open_inter_c_", F0."AGGR_0_avg_sum" AS "DEC__AGGR_0_avg_sum", F0."AGGR_0_avg_cnt" AS "DEC__AGGR_0_avg_cnt", F0."open_inter_c_" AS "DEC__open_inter_c_", F0."GROUP_0" AS "GROUP_0", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_3) F0) F0
GROUP BY F0."GROUP_0", F0."ts") F0) F0) F0
WHERE ((NOT (((F0."t_e") IS NULL))) AND (F0."open_inter_c_" > 0))),
_temp_view_1 AS (
SELECT /*+ materialize */ F0."GROUP_0" AS "dept_no", F0."AGGR_0" AS "avg_salary", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (SELECT * FROM _temp_view_2) F0),
_temp_view_0 AS (
SELECT /*+ materialize */ F0."dept_no" AS "dept_no", F0."avg_salary" AS "avg_salary", F0.DIFFPREVIOUS AS DIFFPREVIOUS, F0."numopen" AS "numopen", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT "dept_no" AS "dept_no", "avg_salary" AS "avg_salary", DIFFPREVIOUS AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."dept_no", F0."avg_salary" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
FROM (
SELECT "dept_no" AS "dept_no", "avg_salary" AS "avg_salary", COALESCE(("numopen" - lag(F0."numopen") OVER (PARTITION BY F0."dept_no", F0."avg_salary" ORDER BY F0."ts")), -2000000000) AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "ts"
FROM (
SELECT  DISTINCT "dept_no" AS "dept_no", "avg_salary" AS "avg_salary", (sum(F0."t_b") OVER (PARTITION BY F0."dept_no", F0."avg_salary" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) - sum(F0."t_e") OVER (PARTITION BY F0."dept_no", F0."avg_salary" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING)) AS "numopen", "ts" AS "ts"
FROM (
SELECT F0."dept_no" AS "dept_no", F0."avg_salary" AS "avg_salary", 0 AS "t_b", 1 AS "t_e", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_1) F0 UNION ALL 
SELECT F0."dept_no" AS "dept_no", F0."avg_salary" AS "avg_salary", 1 AS "t_b", 0 AS "t_e", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_1) F0) F0) F0) F0
WHERE (F0.DIFFPREVIOUS != 0)) F0
WHERE (NOT (((F0."t_e") IS NULL))))
SELECT F0."dept_no" AS "dept_no", F0."avg_salary" AS "avg_salary", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM ((SELECT * FROM _temp_view_0) F0 JOIN generate_series(1,(SELECT MAX(NUMOPEN) FROM (SELECT * FROM _temp_view_0) F0)) F1(n) ON ((F0."numopen" >= F1.N)));


