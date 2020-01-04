#!/bin/bash

DATA=/data/tpg
PREFIX=/servers/tpg

LOG=$(mktemp -p /tmp tpg-quickbuild-log.XXX)
echo -e "\n\nSTARTING SERVER (LOG CAN BE FOUND IN '$LOG')...\n\n"
$PREFIX/bin/pg_ctl -D $DATA -l $LOG -o "-F -p 5400" start

# Wait until log file has a size > 0, i.e., server has been started...
while [ ! -s $LOG ]; do
	echo -n -e "\rWaiting for PostgreSQL server to start up..."
done

# Sleeping for 3 seconds to be sure that the server has started up completely
sleep 3
echo -e "\n\nSERVER STARTED!\n\n"

$PREFIX/bin/createdb -p 5400 employees 
echo -e "\n\nDATABASE EMPLOYEES CREATED!\n\n"

#load data into database
$PREFIX/bin/psql -d employees -f /datasets/employee/load.sql -p 5400
echo -e "\n\nDATA LOADED!\n\n"

$PREFIX/bin/pg_ctl -D $DATA -o "-F -p 5400" stop
echo -e "\n\nDATABASE STOPPED!\n\n"

exit 0
