WITH _temp_view_1 AS (
SELECT /*+ materialize */ F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F0."salary" AS "salary", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
   (SELECT *
    FROM (DEPT_MANAGER a 
           PERIOD JOIN WITH(from_date, to_date, from_date, to_date) AS (ts1, te1)
           SALARIES b
           USING(emp_no)) x) y 
    PERIOD JOIN WITH(ts1, te1, hire_date, end_hire) AS (t_b, t_e)
    (select emp_no,first_name,last_name,hire_date,end_hire from 
        (SELECT emp_no AS emp_no, first_name AS first_name, last_name AS last_name, hire_date AS HIRE_DATE, TO_DATE('9999-01-01', 'SYYYY-MM-DD') AS END_HIRE FROM employees) z) m
    USING(emp_no)) F0
),
_temp_view_0 AS (
SELECT /*+ materialize */ F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F0."salary" AS "salary", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0.DIFFPREVIOUS AS DIFFPREVIOUS, F0."numopen" AS "numopen", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT "emp_no" AS "emp_no", "dept_no" AS "dept_no", "salary" AS "salary", "first_name" AS "first_name", "last_name" AS "last_name", DIFFPREVIOUS AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."emp_no", F0."dept_no", F0."salary", F0."first_name", F0."last_name" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
FROM (
SELECT "emp_no" AS "emp_no", "dept_no" AS "dept_no", "salary" AS "salary", "first_name" AS "first_name", "last_name" AS "last_name", COALESCE(("numopen" - lag(F0."numopen") OVER (PARTITION BY F0."emp_no", F0."dept_no", F0."salary", F0."first_name", F0."last_name" ORDER BY F0."ts")), -2000000000) AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "ts"
FROM (
SELECT  DISTINCT "emp_no" AS "emp_no", "dept_no" AS "dept_no", "salary" AS "salary", "first_name" AS "first_name", "last_name" AS "last_name", (sum(F0."t_b") OVER (PARTITION BY F0."emp_no", F0."dept_no", F0."salary", F0."first_name", F0."last_name" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) - sum(F0."t_e") OVER (PARTITION BY F0."emp_no", F0."dept_no", F0."salary", F0."first_name", F0."last_name" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING)) AS "numopen", "ts" AS "ts"
FROM (
SELECT F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F0."salary" AS "salary", F0."first_name" AS "first_name", F0."last_name" AS "last_name", 0 AS "t_b", 1 AS "t_e", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_1) F0 UNION ALL
SELECT F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F0."salary" AS "salary", F0."first_name" AS "first_name", F0."last_name" AS "last_name", 1 AS "t_b", 0 AS "t_e", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_1) F0) F0) F0) F0
) F0
WHERE (F0.DIFFPREVIOUS != 0) AND (NOT (((F0."t_e") IS NULL))))
SELECT F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F0."salary" AS "salary", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM ((SELECT * FROM _temp_view_0) F0 JOIN generate_series(1,(SELECT MAX(NUMOPEN) FROM (SELECT * FROM _temp_view_0) F0)) F1(n) ON ((F0."numopen" >= F1.N)));