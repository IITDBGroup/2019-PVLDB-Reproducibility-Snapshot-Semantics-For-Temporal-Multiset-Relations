WITH _temp_view_1 AS (
    SELECT /*+ materialize */ F0."emp_no" AS "emp_no", F0."salary" AS "salary", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
    FROM (
        SELECT F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F1."emp_no" AS "emp_no1", F1."salary" AS "salary", greatest(F0."t_b", F1."t_b") AS "t_b", least(F0."t_e", F1."t_e") AS "t_e"
        FROM ((
                SELECT F0."emp_no" AS "emp_no", F0."dept_no" AS "dept_no", F0."from_date" AS "t_b", F0."to_date" AS "t_e"
                FROM "dept_emp" AS F0) F0 JOIN (
                SELECT F0."emp_no" AS "emp_no", F0."salary" AS "salary", F0."from_date" AS "t_b", F0."to_date" AS "t_e"
                FROM "salaries" AS F0) F1 ON (((F0."emp_no" = F1."emp_no") AND ((F0."t_b" <= F1."t_e") AND (F1."t_b" <= F0."t_e")))))) F0
    WHERE (F0."salary" > 133000)),
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
        ) F0
    WHERE (F0.DIFFPREVIOUS != 0) AND (NOT (((F0."t_e") IS NULL))))
SELECT F0."emp_no" AS "emp_no", F0."salary" AS "salary", F0."t_b" AS "t_b", F0."t_e" AS "t_e"
FROM ((SELECT * FROM _temp_view_0) F0 JOIN generate_series(1,(SELECT MAX(NUMOPEN) FROM (SELECT * FROM _temp_view_0) F0)) F1(n) ON ((F0."numopen" >= F1.N)));
