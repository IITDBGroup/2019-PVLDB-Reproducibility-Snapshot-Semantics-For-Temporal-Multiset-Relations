#!/bin/bash

DATA=/data/postgres
PREFIX=/usr/lib/postgresql/9.5

LOG=$(mktemp -p /tmp pg-load-data-log.XXX)
echo -e "\n\nSTARTING SERVER (LOG CAN BE FOUND IN '$LOG')...\n\n"
$PREFIX/bin/pg_ctl -D $DATA -l $LOG -o "-F -p 5400" start

# Wait until log file has a size > 0, i.e., server has been started...
while [ ! -s $LOG ]; do
	echo -n -e "\rWaiting for PostgreSQL server to start up..."
done

# Sleeping for 3 seconds to be sure that the server has started up completely
sleep 3
echo -e "\n\nSERVER STARTED!\n\n"

#create employees database
$PREFIX/bin/createdb -p 5400 employees 
echo -e "\n\nDATABASE employees CREATED!\n\n"

#load data into database
$PREFIX/bin/psql -d employees -f /datasets/employee/load.sql -p 5400
echo -e "\n\nDATA LOADED!\n\n"


#create tpc-bih database
$PREFIX/bin/createdb -p 5400 time_tpch_1gb 
echo -e "\n\nDATABASE time_tpch_1gb CREATED!\n\n"

#load data into database
$PREFIX/bin/psql -d time_tpch_1gb -f /datasets/tpcbih/tpc_load.sql -p 5400
echo -e "\n\nDATA LOADED!\n\n"


$PREFIX/bin/pg_ctl -D $DATA -o "-F -p 5400" stop
echo -e "\n\nDATABASE STOPPED!\n\n"

exit 0
