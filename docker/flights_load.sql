CREATE TABLE tmp (
id int,
flight_number int,
departure_airport VARCHAR,
arrival_airport VARCHAR,
aircraftid int,
departure_time VARCHAR,
arrival_time VARCHAR
);

\echo 'LOADING flights'
\copy tmp FROM '/datasets/flights/flights.tsv' 
delete from tmp where departure_time is NULL or arrival_time is NULL;

DROP TABLE IF EXISTS flights;
CREATE TABLE flights AS 
SELECT id, 
       flight_number, 
       departure_airport, 
       arrival_airport, 
       aircraftid, 
       to_timestamp(departure_time, 'YYYY-MM-DD HH24:MI') as departure_time, 
       to_timestamp(arrival_time, 'YYYY-MM-DD HH24:MI') as arrival_time
FROM tmp;

DROP TABLE tmp;

vacuum analyze;
