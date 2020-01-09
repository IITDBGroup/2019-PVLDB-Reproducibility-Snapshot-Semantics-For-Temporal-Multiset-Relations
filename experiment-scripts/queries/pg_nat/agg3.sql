WITH _temp_view_0 AS (
SELECT /*+ materialize */ "count(1)", from_date AS "t_b", to_date AS "t_e"
FROM 
(
SELECT count(1) AS "count(1)", from_date, to_date FROM (
    SELECT count(*) AS c, dept_no, from_date, to_date
    FROM dept_emp  
    WHERE emp_no < 10282 
    GROUP BY PERIOD WITH (from_date, to_date) dept_no 
    HAVING count(*) > 21) x 
    GROUP BY PERIOD WITH (from_date, to_date)
) F0
)
SELECT F0."count(1)" AS "count(1)", F0."t_b" AS "t_b", F0."ts" AS "t_e"
FROM (
SELECT "count(1)" AS "count(1)", "is_s" AS "is_s", "is_e" AS "is_e", "ts" AS "ts", "count_start" AS "count_start", "count_end" AS "count_end", lag(F0."ts", 1) OVER ( ORDER BY F0."count(1)", F0."ts") AS "t_b"
FROM (
SELECT "count(1)" AS "count(1)", "is_s" AS "is_s", "is_e" AS "is_e", "ts" AS "ts", sum(F0."is_s") OVER (PARTITION BY F0."count(1)" ORDER BY F0."ts", F0."is_e" ROWS UNBOUNDED PRECEDING) AS "count_start", sum(F0."is_e") OVER (PARTITION BY F0."count(1)" ORDER BY F0."ts", F0."is_e" ROWS UNBOUNDED PRECEDING) AS "count_end"
FROM (
SELECT F0."count(1)" AS "count(1)", 1 AS "is_s", 0 AS "is_e", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_0) F0 UNION ALL
SELECT F0."count(1)" AS "count(1)", 0 AS "is_s", 1 AS "is_e", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_0) F0) F0) F0
WHERE ((F0."count_start" = F0."count_end") OR ((F0."count_start" - F0."is_s") = (F0."count_end" - F0."is_e")))) F0
WHERE (F0."count_start" = F0."count_end");