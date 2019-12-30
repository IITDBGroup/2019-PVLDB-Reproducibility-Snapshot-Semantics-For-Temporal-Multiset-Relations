#!/bin/bash
#
# Script to compile, run, and populate a temporal PostgreSQL server

# Bash strict mode for easier debugging
# -e Exit on error
# -u Exit when referencing an non-existent env-variable
# -o pipefail: If a command in a pipeline fails, the exit status of the last
#              command that threw a non-zero exit code is returned.
#              Add "|| true" to commands that are allowed to fail.
set -euo pipefail

# Debugging: Uncomment if you like to trace what gets executed.
# set -x

SRCDIR=/tpg/postgresql-9.6beta3-temporal
PREFIX=/servers/tpg
DATA=/data/tpg
DB=tpg

cd $SRCDIR/source
./configure --prefix=$PREFIX
make
make install
cd ..
echo -e "\n\nCOMPILATION OK!\n\n"

$PREFIX/bin/initdb -D $DATA
echo -e "\n\nINITIALIZATION OK!\n\n"

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

$PREFIX/bin/createdb -p 5400 $DB
echo -e "\n\nDATABASE CREATED!\n\n"

$PREFIX/bin/psql -p 5400 -d $DB -f tpg_data.sql
echo -e "\n\nDATABASE POPULATED!\n\n"

$PREFIX/bin/pg_ctl -D $DATA -o "-F -p 5400" stop
echo -e "\n\nDATABASE STOPPED!\n\n"

echo
echo "DONE! The TEMPORAL POSTGRESQL server setup ended with success!"
echo
echo "If you like to start the server and try out TEMPORAL POSTGRES, "
echo "issue the following commands:"
echo
echo "  $PREFIX/bin/pg_ctl -D $DATA -l tpglogfile -o \"-F -p 5400\" start"
echo "  $PREFIX/bin/psql -p 5400 -d tpg"
echo

exit 0
