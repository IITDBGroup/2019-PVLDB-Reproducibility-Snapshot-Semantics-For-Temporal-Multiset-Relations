WITH _temp_view_1 AS (
SELECT /*+ materialize */ F0."title" AS "title", F0."salary" AS "salary", F0."dept_no" AS "dept_no", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
(SELECT *
    FROM (DEPT_EMP a 
           PERIOD JOIN WITH(from_date, to_date, from_date, to_date) AS (ts1, te1)
           SALARIES b
           USING(emp_no)) x) y 
                PERIOD JOIN WITH(ts1, te1, from_date, to_date) AS (t_b, t_e)
                TITLES c
                USING(emp_no)) F0
),
_temp_view_0 AS (
SELECT /*+ materialize */ F0."title" AS "title", F0."salary" AS "salary", F0."dept_no" AS "dept_no", F0.DIFFPREVIOUS AS DIFFPREVIOUS, F0."numopen" AS "numopen", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT "title" AS "title", "salary" AS "salary", "dept_no" AS "dept_no", DIFFPREVIOUS AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."title", F0."salary", F0."dept_no" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
FROM (
SELECT "title" AS "title", "salary" AS "salary", "dept_no" AS "dept_no", COALESCE(("numopen" - lag(F0."numopen") OVER (PARTITION BY F0."title", F0."salary", F0."dept_no" ORDER BY F0."ts")), -2000000000) AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "ts"
FROM (
SELECT  DISTINCT "title" AS "title", "salary" AS "salary", "dept_no" AS "dept_no", (sum(F0."t_b") OVER (PARTITION BY F0."title", F0."salary", F0."dept_no" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) - sum(F0."t_e") OVER (PARTITION BY F0."title", F0."salary", F0."dept_no" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING)) AS "numopen", "ts" AS "ts"
FROM (
SELECT F0."title" AS "title", F0."salary" AS "salary", F0."dept_no" AS "dept_no", 0 AS "t_b", 1 AS "t_e", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_1) F0 UNION ALL
SELECT F0."title" AS "title", F0."salary" AS "salary", F0."dept_no" AS "dept_no", 1 AS "t_b", 0 AS "t_e", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_1) F0) F0) F0) F0
) F0
WHERE (F0.DIFFPREVIOUS != 0) AND (NOT (((F0."t_e") IS NULL))))
SELECT F0."title" AS "title", F0."salary" AS "salary", F0."dept_no" AS "dept_no", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM ((SELECT * FROM _temp_view_0) F0 JOIN generate_series(1,(SELECT MAX(NUMOPEN) FROM (SELECT * FROM _temp_view_0) F0)) F1(n) ON ((F0."numopen" >= F1.N)));                