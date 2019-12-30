#!/bin/bash
########################################
# Start both postgres servers (ports 5432 and 5433)
########################################
sudo -u postgres /servers/tpg/bin/pg_ctl -D $DATA -l tpglogfile -o \"-F -p 5433\" start
sudo -u postgres /usr/lib/postgresql/9.5/bin/pg_ctl -D $DATA -l tpglogfile -o \"-F -p 5432\" start
########################################
# Sleep to allow user to connect and run commands in bash
########################################
while [[ true ]]; do
    sleep 10
done
