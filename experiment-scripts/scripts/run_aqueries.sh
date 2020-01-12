#!/bin/bash


DIR=/reproducibility/experiment-scripts

if [ ! -d "$DIR/result" ];
then
        mkdir $DIR/result
fi;

#run anton's query
for i in 1k 10k 100k 300k 500k 1000k 3000k
do
         echo -e "running q$i ..."
         $DIR/scripts/time_aquery.sh employees $DIR/queries/pg_nat/"$i".sql 2 1 > $DIR/result/aq"$i".txt
done;

for i in 5 6 7 8 12 14 19 1
do
         echo -e "running q$i ..."
         $DIR/scripts/time_aquery.sh time_tpch_1gb $DIR/queries/pg_nat/q"$i".sql 2 1 > $DIR/result/aq"$i".txt
done;


for i in join1 join3 join4 agg2 agg3 diff1 diff2 agg1 join2 agg_join
do
         echo -e "running $i ..."
         $DIR/scripts/time_aquery.sh employees $DIR/queries/pg_nat/"$i".sql 2 1 > $DIR/result/a"$i".txt
done;



