#!/bin/bash


DIR=/reproducibility/experiment-scripts

if [ ! -d "$DIR/result" ];
then
        mkdir $DIR/result
fi;

#run gprom query
for i in 1 5 6 7 8 9 12 14 19
do
         echo -e "running q$i ..."
         $DIR/scripts/time_query.sh time_tpch_1gb $DIR/gprom_queries/q"$i".sql 2 1 > $DIR/result/q"$i".txt
done;


for i in 1k 10k 100k 300k 500k 1000k 3000k
do
         echo -e "running q$i ..."
         $DIR/scripts/time_query.sh employees $DIR/gprom_queries/q"$i".sql 2 1 > $DIR/result/q"$i".txt
done;


for i in join1 join3 join4 agg1 agg2 agg3 diff1 diff2 join2 agg_join
do
         echo -e "running $i ..."
         $DIR/scripts/time_query.sh employees $DIR/gprom_queries/"$i".sql 2 1 > $DIR/result/"$i".txt
done;
