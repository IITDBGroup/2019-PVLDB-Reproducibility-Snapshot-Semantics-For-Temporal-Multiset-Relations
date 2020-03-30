-- ********************************************************************************
-- Queries with GProM
-- ********************************************************************************

-- number of aircrafts in the air at the same time (show results ordered by time)
SELECT *
  FROM
      (SEQUENCED TEMPORAL (
        SELECT COUNT(*)
          FROM flights WITH TIME (departure_time, arrival_time)
      )) seq
 ORDER BY t_b;

-- number of aircrafts in the air at the same time with the same destination (show results for each arrival airport ordered by time)
SELECT *
  FROM
      (SEQUENCED TEMPORAL (
        SELECT COUNT(*)
          FROM flights WITH TIME (departure_time, arrival_time)
         GROUP BY arrival_airport
      )) seq
 ORDER BY arrival_airport, t_b;

-- pairs of aircrafts in the air at the same time with the same destination (show results ordered by time for each arrival airport)
SELECT *
  FROM
      (SEQUENCED TEMPORAL (
        SELECT f1.arrival_airport AS arrival_airport,
               f1.flight_numer as f1_flight_num, f1.departure_airport AS f1_departure_airport, f1.aircraftid AS f1_aircraftid,
               f2.flight_numer as f2_flight_num, f2.departure_airport AS f2_departure_airport, f2.aircraftid AS f2_aircraftid
          FROM flights WITH TIME (departure_time, arrival_time) f1
                 JOIN
                 flights WITH TIME (departure_time, arrival_time) f2
                     ON f1.arrival_airport = f2.arrival_airport
      )) seq
 ORDER BY arrival_airport, t_b;

-- ********************************************************************************
-- The same queries in the native postgres (not including the final normalization step
-- ********************************************************************************
-- number of aircrafts in the air at the same time
SELECT COUNT(*), departure_time, arrival_time
FROM flights
GROUP BY PERIOD WITH (departure_time, arrival_time);


-- number of aircrafts in the air at the same time with the same destination
SELECT arrival_airport, COUNT(*), departure_time, arrival_time
FROM flights
GROUP BY PERIOD WITH (departure_time, arrival_time) arrival_airport;


-- pairs of aircrafts in the air at the same time with the same destination
SELECT f1.arrival_airport AS arrival_airport,
       f1.flight_numer as f1_flight_num, f1.departure_airport AS f1_departure_airport, f1.aircraftid AS f1_aircraftid,
       f2.flight_numer as f2_flight_num, f2.departure_airport AS f2_departure_airport, f2.aircraftid AS f2_aircraftid
FROM (flights f1 PERIOD JOIN WITH (departure_time, arrival_time, departure_time, arrival_time) AS (d_time, a_time) flights f2 ON f1.arrival_airport = f2.arrival_airport) f;
