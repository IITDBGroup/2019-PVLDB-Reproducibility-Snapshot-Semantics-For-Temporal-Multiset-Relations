WITH _temp_view_2 AS (
    SELECT /*+ materialize */ F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F1."emp_no" AS "emp_no1", F1."salary" AS "salary", greatest(F0."t_b", F1."t_b") AS "t_b", least(F0."t_e", F1."t_e") AS "t_e"
    FROM ((
            SELECT F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F0."from_date" AS "t_b", F0."to_date" AS "t_e"
            FROM "dept_emp" AS F0) F0 JOIN (
            SELECT F0."emp_no" AS "emp_no", F0."salary" AS "salary", F0."from_date" AS "t_b", F0."to_date" AS "t_e"
            FROM "salaries" AS F0) F1 ON (((F0."emp_no" = F1."emp_no") AND ((F0."t_b" <= F1."t_e") AND (F1."t_b" <= F0."t_e")))))),
_temp_view_7 AS (
    SELECT /*+ materialize */ F0."emp_no" AS "emp_no", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0."hire_date" AS "hire_date", to_date('9999-01-01', 'SYYYY-MM-DD') AS "end_hire"
    FROM "employees" AS F0),
_temp_view_1 AS (
    SELECT /*+ materialize */ F0."emp_no1" AS "emp_no1", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0."max_salary" AS "max_salary", F0."dept_no1" AS "dept_no1", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (
        SELECT F0."max_salary" AS "max_salary", F0."dept_no" AS "dept_no", F0."emp_no" AS "emp_no", F0."salary" AS "salary", F0."emp_no1" AS "emp_no1", F0."dept_no1" AS "dept_no1", F1."emp_no" AS "emp_no2", F1."first_name" AS "first_name", F1."last_name" AS "last_name", greatest(F0."t_b", F1."t_b") AS "t_b", least(F0."t_e", F1."t_e") AS "t_e"
        FROM ((
                SELECT F0."max_salary" AS "max_salary", F0."dept_no" AS "dept_no", F0."emp_no" AS "emp_no", F0."salary" AS "salary", F1."emp_no" AS "emp_no1", F1."dept_no" AS "dept_no1", greatest(F0."t_b", F1."t_b") AS "t_b", least(F0."t_e", F1."t_e") AS "t_e"
                FROM ((
                        SELECT F0."max_salary" AS "max_salary", F0."dept_no" AS "dept_no", F1."emp_no" AS "emp_no", F1."salary" AS "salary", greatest(F0."t_b", F1."t_b") AS "t_b", least(F0."t_e", F1."t_e") AS "t_e"
                        FROM ((
                                SELECT max(F0."salary") AS "max_salary", F0."dept_no" AS "dept_no", F0.T AS "t_b", COALESCE(F0."winf_1", F0."t_e") AS "t_e"
                                FROM (
                                    SELECT F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F0."emp_no1" AS "emp_no1", F0."salary" AS "salary", F0."t_b" AS "t_b", F0."t_e" AS "t_e", F0.IDD AS IDD, F1.T AS T, lead(F1.T) OVER (PARTITION BY F0.IDD ORDER BY F1.T) AS "winf_1"
                                    FROM ((
                                            SELECT "emp_no" AS "emp_no", "dept_no" AS "dept_no", "emp_no1" AS "emp_no1", "salary" AS "salary", "t_b" AS "t_b", "t_e" AS "t_e", ROW_NUMBER() OVER ( ORDER BY 1) AS IDD
                                            FROM (SELECT * FROM _temp_view_2) F0) F0 CROSS JOIN (
                                            SELECT F0.T AS T, F0."dept_no" AS "dept_no_1"
                                            FROM (
                                                SELECT  DISTINCT F0.T AS T, F0."dept_no" AS "dept_no"
                                                FROM (
                                                    SELECT  DISTINCT F0.T AS T, F0."dept_no" AS "dept_no"
                                                    FROM (
                                                        SELECT  DISTINCT F0.T AS T, F0."dept_no" AS "dept_no"
                                                        FROM (
                                                            SELECT F0."t_b" AS T, F0."dept_no" AS "dept_no"
                                                            FROM (SELECT * FROM _temp_view_2) F0 UNION ALL
                                                            SELECT F0."t_e" AS T, F0."dept_no" AS "dept_no"
                                                            FROM (SELECT * FROM _temp_view_2) F0) F0 UNION ALL
                                                        SELECT F0."t_b" AS T, F0."dept_no" AS "dept_no"
                                                        FROM (SELECT * FROM _temp_view_2) F0) F0 UNION ALL
                                                    SELECT F0."t_e" AS T, F0."dept_no" AS "dept_no"
                                                    FROM (SELECT * FROM _temp_view_2) F0) F0) F0) F1)
                                    WHERE (((F0."dept_no" = F1."dept_no_1") AND (F1.T >= F0."t_b")) AND (F1.T < F0."t_e"))) F0
                                GROUP BY F0."dept_no", F0.T, COALESCE(F0."winf_1", F0."t_e")) F0 JOIN (
                                SELECT F0."emp_no" AS "emp_no", F0."salary" AS "salary", F0."from_date" AS "t_b", F0."to_date" AS "t_e"
                                FROM "salaries" AS F0) F1 ON (((F0."t_b" <= F1."t_e") AND (F1."t_b" <= F0."t_e"))))) F0 JOIN (
                        SELECT F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F0."from_date" AS "t_b", F0."to_date" AS "t_e"
                        FROM "dept_emp" AS F0) F1 ON (((F0."t_b" <= F1."t_e") AND (F1."t_b" <= F0."t_e"))))) F0 JOIN (
                SELECT F0."emp_no" AS "emp_no", F0."first_name" AS "first_name", F0."last_name" AS "last_name", F0."hire_date" AS "t_b", F0."end_hire" AS "t_e"
                FROM (SELECT * FROM _temp_view_7) F0) F1 ON (((F0."t_b" <= F1."t_e") AND (F1."t_b" <= F0."t_e"))))) F0
    WHERE ((((F0."emp_no2" = F0."emp_no") AND (F0."salary" = F0."max_salary")) AND (F0."dept_no1" = F0."dept_no")) AND (F0."emp_no1" = F0."emp_no2"))),
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
