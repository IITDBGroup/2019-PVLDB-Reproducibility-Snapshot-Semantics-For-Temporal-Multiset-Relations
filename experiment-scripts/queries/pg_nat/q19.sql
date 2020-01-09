WITH _temp_view_0 AS (
SELECT sum(l_extendedprice* (1 - l_discount)) AS "revenue", ts AS "t_b", te AS "t_e"
FROM (
SELECT * 
FROM 
    (time_lineitem a
    PERIOD JOIN WITH (ACTIVE_TIME_BEGIN, ACTIVE_TIME_END, AVAILABLE_TIME_BEGIN, AVAILABLE_TIME_END) AS (ts,te) 
    time_part b
    ON (p_partkey = l_partkey)) x
WHERE (p_Brand = 'Brand#22' AND (p_container = 'SM CASE' OR p_container = 'SM BOX' OR p_container = 'SM PACK' OR p_container = 'SM PKG') AND l_quantity >= 2 AND l_quantity <= 2 + 10 AND p_size >= 1 AND p_size <= 5 AND (l_shipmode ='AIR' OR l_shipmode = 'AIR REG') AND l_shipinstruct = 'DELIVER IN PERSON') OR (p_partkey = l_partkey AND p_Brand = 'Brand#32' AND (p_container = 'MED BAG' OR p_container = 'MED BOX' OR p_container = 'MED PKG' OR p_container = 'MED PACK') AND l_quantity >= 19 AND l_quantity <= 19 + 10 AND p_size >= 1 AND p_size <= 10 AND (l_shipmode ='AIR' OR l_shipmode = 'AIR REG') AND l_shipinstruct = 'DELIVER IN PERSON') OR (p_partkey = l_partkey AND p_Brand = 'Brand#43' AND (p_container = 'LG CASE' OR p_container = 'LG BOX' OR p_container = 'LG PACK' OR p_container = 'LG PKG') AND l_quantity >= 21 AND l_quantity <= 21 + 10 AND p_size >= 1 AND p_size <= 15 AND (l_shipmode ='AIR' OR l_shipmode = 'AIR REG') AND l_shipinstruct = 'DELIVER IN PERSON')) y
GROUP BY PERIOD WITH (ts,te)
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