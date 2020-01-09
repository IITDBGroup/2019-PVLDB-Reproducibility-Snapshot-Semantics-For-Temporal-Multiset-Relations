#!/bin/bash


DB=$1
QUERY=$2
REPETITIONS=$3
RMREP=$4
#PSQL=/home/oracle/anton/code/postgresql-9.6beta3-temporal/server/bin/psql -p 5400 -d tpg -h localhost -f


i=1;
totalsum=0.0;
while [ ${i} -le ${REPETITIONS} ]
do
echo "${i} of ${REPETITIONS}"

	start=$(date +%s%3N);
	#echo "start is ${start}"

    /servers/tpg/bin/psql -d $DB -p 5433 -h localhost -U postgres -f $QUERY > /dev/null;

	end=$(date +%s%3N);
	#echo "end is ${end}"

	result=$(echo "scale=6;$(( $end - $start ))/1000" | bc);
	echo "runtime is ${result}"

	if [ $i -gt $RMREP ];
        then
                totalsum=`echo $result + $totalsum | bc`
        fi

	i=`expr ${i} + 1`

	#totalsum=`echo $result + $totalsum | bc`
	echo "Current total sum is ${totalsum}"
done

rep=$(($REPETITIONS - $RMREP))
avgsum=`echo $totalsum/$rep | bc -l`
#avgsum=`echo $totalsum/$REPETITIONS | bc -l`
echo "total sum is ${totalsum}"
echo "Avg runtime is ${avgsum}"