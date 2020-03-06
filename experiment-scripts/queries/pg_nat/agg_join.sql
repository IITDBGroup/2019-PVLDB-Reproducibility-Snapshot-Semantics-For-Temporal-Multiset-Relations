WITH maxS AS (
SELECT max(salary) as max_salary, dept_no, ts from_date, te to_date
FROM (DEPT_EMP a
PERIOD JOIN WITH(from_date, to_date, from_date, to_date) AS (ts, te)
SALARIES b USING(emp_no)) x
GROUP BY PERIOD WITH (ts, te) dept_no
),
empl AS (
SELECT EMP_NO EEMP_NO, FIRST_NAME, LAST_NAME, HIRE_DATE, TO_DATE('9999-01-01', 'YYYY-MM-DD') AS END_HIRE
FROM EMPLOYEES
),
_temp_view_1 AS (
SELECT emp_no AS emp_no1, first_name, last_name, max_salary, dept_no AS dept_no1, start_date AS t_b, end_date AS t_e
FROM ((SELECT * FROM (  (SELECT * FROM ( maxS a
           PERIOD JOIN WITH(from_date, to_date, from_date, to_date) AS (ts, te)
           SALARIES s ON a.max_salary=s.salary
                   ) x
                   ) x
               PERIOD JOIN WITH(ts, te, from_date, to_date) AS (ss, ee)
               (SELECT emp_no AS demp_no, dept_no, from_date, to_date from DEPT_EMP) d
               USING(dept_no)
                           ) y
           ) y
           PERIOD JOIN WITH(ss, ee, HIRE_DATE, END_HIRE) AS (start_date, end_date)
           empl e
           ON y.demp_no=e.eemp_no AND y.emp_no=e.eemp_no
          ) z
),
_temp_view_0 AS (
SELECT /*+ materialize */ F0."emp_no1" AS "emp_no1", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0."max_salary" AS "max_sal
ary", F0."dept_no1" AS "dept_no1", F0.DIFFPREVIOUS AS DIFFPREVIOUS, F0."numopen" AS "numopen", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM (
SELECT "emp_no1" AS "emp_no1", "first_name" AS "first_name", "last_name" AS "last_name", "max_salary" AS "max_salary", "dept_no1" AS "dept_no1",
 DIFFPREVIOUS AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "t_b", last_value(F0."ts") OVER (PARTITION BY F0."emp_no1", F0."first_name", F0."
last_name", F0."max_salary", F0."dept_no1" ORDER BY F0."ts" ROWS BETWEEN (1) FOLLOWING AND (1) FOLLOWING) AS "t_e"
FROM (
SELECT "emp_no1" AS "emp_no1", "first_name" AS "first_name", "last_name" AS "last_name", "max_salary" AS "max_salary", "dept_no1" AS "dept_no1",
 COALESCE(("numopen" - lag(F0."numopen") OVER (PARTITION BY F0."emp_no1", F0."first_name", F0."last_name", F0."max_salary", F0."dept_no1" ORDER
BY F0."ts")), -2000000000) AS DIFFPREVIOUS, "numopen" AS "numopen", "ts" AS "ts"
FROM (
SELECT  DISTINCT "emp_no1" AS "emp_no1", "first_name" AS "first_name", "last_name" AS "last_name", "max_salary" AS "max_salary", "dept_no1" AS "
dept_no1", (sum(F0."t_b") OVER (PARTITION BY F0."emp_no1", F0."first_name", F0."last_name", F0."max_salary", F0."dept_no1" ORDER BY F0."ts" RANG
E UNBOUNDED PRECEDING) - sum(F0."t_e") OVER (PARTITION BY F0."emp_no1", F0."first_name", F0."last_name", F0."max_salary", F0."dept_no1" ORDER BY
 F0."ts" RANGE UNBOUNDED PRECEDING)) AS "numopen", "ts" AS "ts"
FROM (
SELECT F0."emp_no1" AS "emp_no1", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0."max_salary" AS "max_salary", F0."dept_no1"
 AS "dept_no1", 0 AS "t_b", 1 AS "t_e", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_1) F0 UNION ALL
SELECT F0."emp_no1" AS "emp_no1", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0."max_salary" AS "max_salary", F0."dept_no1"
 AS "dept_no1", 1 AS "t_b", 0 AS "t_e", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_1) F0) F0) F0) F0
) F0
WHERE (F0.DIFFPREVIOUS != 0) AND (NOT (((F0."t_e") IS NULL))))
SELECT F0."emp_no1" AS "emp_no1", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0."max_salary" AS "max_salary", F0."dept_no1"
 AS "dept_no1", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM ((SELECT * FROM _temp_view_0) F0 JOIN generate_series(1,(SELECT MAX(NUMOPEN) FROM (SELECT * FROM _temp_view_0) F0)) F1(n) ON ((F0."numopen"
 >= F1.N)));