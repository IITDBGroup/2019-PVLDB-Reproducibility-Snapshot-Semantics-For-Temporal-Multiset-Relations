/home/perm/postgres11/install/bin/createdb time_tpch_1gb -p 5440
#/home/perm/postgres11/install/bin/psql time_tpch_1gb -p 5440
/home/perm/postgres11/install/bin/psql -d time_tpch_1gb -f myload.sql -p 5440
