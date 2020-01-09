WITH _temp_view_1 AS (
SELECT /*+ materialize */ F0."emp_no1" AS "emp_no1", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0."max_salary" AS "max_salary", F0."dept_no1" AS "dept_no1", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (
    (SELECT * FROM (
        (SELECT * FROM (
            (SELECT MAX(salary) as max_salary, dept_no AS dept_no1, ts1, te1 FROM (
                SELECT * FROM (
                    dept_emp a
                    PERIOD JOIN WITH(from_date, to_date, from_date, to_date) AS (ts1, te1)
                    salaries b USING(emp_no)) x) y
             GROUP BY PERIOD WITH (ts1, te1) dept_no ) x1
                PERIOD JOIN WITH(ts1, te1, from_date, to_date) AS (ts2, te2)
                salaries c
                ON (c.salary = x1.max_salary)
            ) y1) z1
        PERIOD JOIN WITH(ts2, te2, from_date, to_date) AS (ts3, te3)
        dept_emp d
        USING(emp_no)) x2) y2
        PERIOD JOIN WITH(ts3, te3, hire_date, end_hire) AS (t_b, t_e)
        (select emp_no1,first_name,last_name,hire_date,end_hire from 
        (SELECT emp_no AS emp_no1, first_name AS first_name, last_name AS last_name, hire_date AS HIRE_DATE, TO_DATE('9999-01-01', 'SYYYY-MM-DD') AS END_HIRE FROM employees) z) m
        ON (emp_no = emp_no1)) F0
),
_temp_view_0 AS (
SELECT /*+ materialize */ F0."emp_no1" AS "emp_no1", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0."max_salary" AS "max_salary", F0."dept_no1" AS "dept_no1", F0.DIFFPREVIOUS AS DIFFPREVIOUS, F0."numopen" AS "numopen", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT "emp_no1" AS "emp_no1", "first_name" AS "first_name", "last_name" AS "last_name", "max_salary" AS "max_salary", "dept_no1" AS "dept_no1", DIFFPREVIOUS AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."emp_no1", F0."first_name", F0."last_name", F0."max_salary", F0."dept_no1" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
FROM (
SELECT "emp_no1" AS "emp_no1", "first_name" AS "first_name", "last_name" AS "last_name", "max_salary" AS "max_salary", "dept_no1" AS "dept_no1", COALESCE(("numopen" - lag(F0."numopen") OVER (PARTITION BY F0."emp_no1", F0."first_name", F0."last_name", F0."max_salary", F0."dept_no1" ORDER BY F0."ts")), -2000000000) AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "ts"
FROM (
SELECT  DISTINCT "emp_no1" AS "emp_no1", "first_name" AS "first_name", "last_name" AS "last_name", "max_salary" AS "max_salary", "dept_no1" AS "dept_no1", (sum(F0."t_b") OVER (PARTITION BY F0."emp_no1", F0."first_name", F0."last_name", F0."max_salary", F0."dept_no1" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING) - sum(F0."t_e") OVER (PARTITION BY F0."emp_no1", F0."first_name", F0."last_name", F0."max_salary", F0."dept_no1" ORDER BY F0."ts" RANGE UNBOUNDED PRECEDING)) AS "numopen", "ts" AS "ts"
FROM (
SELECT F0."emp_no1" AS "emp_no1", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0."max_salary" AS "max_salary", F0."dept_no1" AS "dept_no1", 0 AS "t_b", 1 AS "t_e", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_1) F0 UNION ALL
SELECT F0."emp_no1" AS "emp_no1", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0."max_salary" AS "max_salary", F0."dept_no1" AS "dept_no1", 1 AS "t_b", 0 AS "t_e", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_1) F0) F0) F0) F0
WHERE (F0.DIFFPREVIOUS != 0)) F0
WHERE (NOT (((F0."t_e") IS NULL))))
SELECT F0."emp_no1" AS "emp_no1", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0."max_salary" AS "max_salary", F0."dept_no1" AS "dept_no1", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM ((SELECT * FROM _temp_view_0) F0 JOIN generate_series(1,(SELECT MAX(NUMOPEN) FROM (SELECT * FROM _temp_view_0) F0)) F1(n) ON ((F0."numopen" >= F1.N)));