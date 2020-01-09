WITH _temp_view_0 AS (
SELECT sum(l_extendedprice * l_discount) as "revenue",  ACTIVE_TIME_BEGIN AS "t_b", ACTIVE_TIME_END AS "t_e"
FROM 
    time_lineitem 
    WHERE l_shipdate >= TO_DATE('1995-01-01', 'YYYY-MM-DD') AND l_shipdate < TO_DATE('1996-01-01', 'YYYY-MM-DD') AND l_discount > 0.05 - 0.01 AND l_discount < 0.05 + 0.01 AND l_quantity < 25
GROUP BY PERIOD WITH (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END)
)
SELECT F0."revenue" AS "revenue", F0."t_b" AS "t_b", F0."ts" AS "t_e"
FROM (
SELECT "revenue" AS "revenue", "is_s" AS "is_s", "is_e" AS "is_e", "ts" AS "ts", "count_start" AS "count_start", "count_end" AS "count_end", lag(F0."ts", 1) OVER ( ORDER BY F0."revenue", F0."ts") AS "t_b"
FROM (
SELECT "revenue" AS "revenue", "is_s" AS "is_s", "is_e" AS "is_e", "ts" AS "ts", sum(F0."is_s") OVER (PARTITION BY F0."revenue" ORDER BY F0."ts", F0."is_e" ROWS UNBOUNDED PRECEDING) AS "count_start", sum(F0."is_e") OVER (PARTITION BY F0."revenue" ORDER BY F0."ts", F0."is_e" ROWS UNBOUNDED PRECEDING) AS "count_end"
FROM (
SELECT F0."revenue" AS "revenue", 1 AS "is_s", 0 AS "is_e", F0."t_b" AS "ts"
FROM (SELECT * FROM _temp_view_0) F0 UNION ALL
SELECT F0."revenue" AS "revenue", 0 AS "is_s", 1 AS "is_e", F0."t_e" AS "ts"
FROM (SELECT * FROM _temp_view_0) F0) F0) F0
WHERE ((F0."count_start" = F0."count_end") OR ((F0."count_start" - F0."is_s") = (F0."count_end" - F0."is_e")))) F0
WHERE (F0."count_start" = F0."count_end");