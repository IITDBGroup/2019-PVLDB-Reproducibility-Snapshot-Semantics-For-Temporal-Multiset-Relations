-- number of aircrafts in the air at the same time
  SELECT COUNT(*)
  FROM flights;

  --Postgres Nat
  SELECT COUNT(*), departure_time, arrival_time
  FROM flights
  GROUP BY PERIOD WITH (departure_time, arrival_time);

-- number of aircrafts in the air at the same time with the same destination
  SELECT COUNT(*)
  FROM flights
  GROUP BY arrival_airport;

  --Postgres Nat
  SELECT arrival_airport, COUNT(*), departure_time, arrival_time
  FROM flights
  GROUP BY PERIOD WITH (departure_time, arrival_time) arrival_airport;

-- pairs of aircrafts in the air at the same time with the same destination
  SELECT *
  FROM flights f1 JOIN flights f2 ON f1.arrival_airport = f2.arrival_airport;

  --Postgres Nat
  SELECT *
  FROM (flights f1 PERIOD JOIN WITH (departure_time, arrival_time, departure_time, arrival_time) AS (d_time, a_time) flights f2 ON f1.arrival_airport = f2.arrival_airport) f;



