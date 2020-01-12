WITH _temp_view_5 AS (
SELECT /*+ materialize */ F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F0."from_date" AS "t_b", F0."to_date" AS "t_e"
FROM "dept_emp" AS F0),
_temp_view_4 AS (
SELECT /*+ materialize */ F0."emp_no" AS "emp_no", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (SELECT * FROM _temp_view_5) F0),
_temp_view_3 AS (
SELECT 1 AS "AGG_GB_ARG0", F0."emp_no" AS "emp_no", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (SELECT * FROM _temp_view_4) F0),
_temp_view_9 AS (
SELECT /*+ materialize */ F0."dept_no" AS "dept_no", F0."emp_no" AS "emp_no", F0."from_date" AS "t_b", F0."to_date" AS "t_e"
FROM "dept_manager" AS F0),
_temp_view_8 AS (
SELECT /*+ materialize */ F0."emp_no" AS "emp_no", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (SELECT * FROM _temp_view_9) F0),
_temp_view_7 AS (
SELECT 1 AS "AGG_GB_ARG0", F0."emp_no" AS "emp_no", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (SELECT * FROM _temp_view_8) F0),
_temp_view_11 AS (
SELECT (sum(F0.S) OVER (PARTITION BY F0."emp_no" ORDER BY F0.T RANGE UNBOUNDED PRECEDING) - sum(F0.E) OVER (PARTITION BY F0."emp_no" ORDER BY F0.T RANGE UNBOUNDED PRECEDING)) AS "numopen", "emp_no" AS "emp_no", T AS "t_b", lead(F0.T) OVER (PARTITION BY F0."emp_no" ORDER BY F0.T) AS "t_e"
FROM (
SELECT sum(F0.S) AS S, sum(F0.E) AS E, F0."emp_no" AS "emp_no", F0.T AS T
FROM (
SELECT count(F0."AGG_GB_ARG0") AS S, F0."emp_no" AS "emp_no", F0."t_b" AS T, 0 AS E
FROM (SELECT * FROM _temp_view_3) F0
GROUP BY F0."emp_no", F0."t_b" UNION ALL 
SELECT 0 AS S, F0."emp_no" AS "emp_no", F0."t_e" AS T, count(F0."AGG_GB_ARG0") AS E
FROM (SELECT * FROM _temp_view_3) F0
GROUP BY F0."emp_no", F0."t_e" UNION ALL 
SELECT (0 - count(F0."AGG_GB_ARG0")) AS S, F0."emp_no" AS "emp_no", F0."t_b" AS "t_b", 0 AS E
FROM (SELECT * FROM _temp_view_7) F0
GROUP BY F0."emp_no", F0."t_b" UNION ALL 
SELECT 0 AS S, F0."emp_no" AS "emp_no", F0."t_e" AS T, (0 - count(F0."AGG_GB_ARG0")) AS E
FROM (SELECT * FROM _temp_view_7) F0
GROUP BY F0."emp_no", F0."t_e") F0
GROUP BY F0."emp_no", F0.T) F0),
_temp_view_2 AS (
SELECT /*+ materialize */ F0."numopen" AS "numopen", F0."emp_no" AS "emp_no", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM ((
SELECT (sum(F0.S) OVER (PARTITION BY F0."emp_no" ORDER BY F0.T RANGE UNBOUNDED PRECEDING) - sum(F0.E) OVER (PARTITION BY F0."emp_no" ORDER BY F0.T RANGE UNBOUNDED PRECEDING)) AS "numopen", "emp_no" AS "emp_no", T AS "t_b", lead(F0.T) OVER (PARTITION BY F0."emp_no" ORDER BY F0.T) AS "t_e"
FROM (
SELECT sum(F0.S) AS S, sum(F0.E) AS E, F0."emp_no" AS "emp_no", F0.T AS T
FROM (
SELECT count(F0."AGG_GB_ARG0") AS S, F0."emp_no" AS "emp_no", F0."t_b" AS T, 0 AS E
FROM (SELECT * FROM _temp_view_3) F0
GROUP BY F0."emp_no", F0."t_b" UNION ALL 
SELECT 0 AS S, F0."emp_no" AS "emp_no", F0."t_e" AS T, count(F0."AGG_GB_ARG0") AS E
FROM (SELECT * FROM _temp_view_3) F0
GROUP BY F0."emp_no", F0."t_e" UNION ALL 
SELECT (0 - count(F0."AGG_GB_ARG0")) AS S, F0."emp_no" AS "emp_no", F0."t_b" AS "t_b", 0 AS E
FROM (SELECT * FROM _temp_view_7) F0
GROUP BY F0."emp_no", F0."t_b" UNION ALL 
SELECT 0 AS S, F0."emp_no" AS "emp_no", F0."t_e" AS T, (0 - count(F0."AGG_GB_ARG0")) AS E
FROM (SELECT * FROM _temp_view_7) F0
GROUP BY F0."emp_no", F0."t_e") F0
GROUP BY F0."emp_no", F0.T) F0) F0 JOIN generate_series(1,(SELECT MAX(NUMOPEN) FROM (SELECT * FROM _temp_view_11) F0)) F1(n) ON (((F0."numopen" > 0) AND (F0."numopen" >= F1.N))))),
_temp_view_1 AS (
SELECT /*+ materialize */ F0."emp_no" AS "emp_no", F0."salary" AS "salary", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT F0."emp_no" AS "emp_no", F1."emp_no" AS "emp_no1", F1."salary" AS "salary", greatest(F0."t_b", F1."t_b") AS "t_b", least(F0."t_e", F1."t_e") AS "t_e"
FROM ((
SELECT F0."emp_no" AS "emp_no", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (SELECT * FROM _temp_view_2) F0) F0 JOIN (
SELECT F0."emp_no" AS "emp_no", F0."salary" AS "salary", F0."from_date" AS "t_b", F0."to_date" AS "t_e"
FROM "salaries" AS F0) F1 ON (((F0."t_b" <= F1."t_e") AND (F1."t_b" <= F0."t_e"))))) F0
WHERE (F0."emp_no" = F0."emp_no1")),
_temp_view_0 AS (
SELECT /*+ materialize */ F0."emp_no" AS "emp_no", F0."salary" AS "salary", F0.DIFFPREVIOUS AS DIFFPREVIOUS, F0."numopen" AS "numopen", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT "emp_no" AS "emp_no", "salary" AS "salary", DIFFPREVIOUS AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."emp_no", F0."salary" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
FROM (
SELECT "emp_no" AS "emp_no", "salary" AS "salary", COALESCE(("numopen" - lag(F0."numopen") OVER (PARTITION BY F0."emp_no", F0."salary" ORDER BY F0."ts")), -2000000000) AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "ts"
FROM (
SELECT  DISTINCT "emp_no" AS "emp_no", "salary" AS "salary", (sum(F0."t_b") OVER (PARTITION BY F0."emp_no", F0."salary" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) - sum(F0."t_e") OVER (PARTITION BY F0."emp_no", F0."salary" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING)) AS "numopen", "ts" AS "ts"
FROM (
SELECT F0."emp_no" AS "emp_no", F0."salary" AS "salary", 0 AS "t_b", 1 AS "t_e", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_1) F0 UNION ALL 
SELECT F0."emp_no" AS "emp_no", F0."salary" AS "salary", 1 AS "t_b", 0 AS "t_e", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_1) F0) F0) F0) F0
WHERE (F0.DIFFPREVIOUS != 0)) F0
WHERE (NOT (((F0."t_e") IS NULL))))
SELECT F0."emp_no" AS "emp_no", F0."salary" AS "salary", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM ((SELECT * FROM _temp_view_0) F0 JOIN generate_series(1,(SELECT MAX(NUMOPEN) FROM (SELECT * FROM _temp_view_0) F0)) F1(n) ON ((F0."numopen" >= F1.N)));


