#!/bin/bash


DIR=/reproducibility/experiment-scripts

if [ ! -d "$DIR/result" ];
then
        mkdir $DIR/result
fi;

#run gprom query
echo -e "run pg_sql ..."
for i in 1k 10k 100k 300k 500k 1000k 3000k
do
         if [ ! -f "$DIR/result/q$i.txt" ];
         then
            echo -e "running q$i ..."
            $DIR/scripts/time_query.sh employees $DIR/gprom_queries/q$i.sql 100 5 > $DIR/result/q_temp.txt
            mv $DIR/result/q_temp.txt $DIR/result/q$i.txt
         fi;            
done;


for i in 1 5 6 7 8 9 12 14 19
do         
         if [ ! -f "$DIR/result/q$i.txt" ];
         then
            echo -e "running q$i ..."
            $DIR/scripts/time_query.sh time_tpch_1gb $DIR/gprom_queries/q$i.sql 100 5 > $DIR/result/q_temp.txt
            mv $DIR/result/q_temp.txt $DIR/result/q$i.txt
         fi;
done;



for i in join1 join3 join4 agg1 agg2 agg3 diff1 diff2
do
         if [ ! -f "$DIR/result/q$i.txt" ];
         then
            echo -e "running $i ..."
            $DIR/scripts/time_query.sh employees $DIR/gprom_queries/$i.sql 100 5 > $DIR/result/q_temp.txt
            mv $DIR/result/q_temp.txt $DIR/result/$i.txt
         fi;                
done;

for i in join2 agg_join
do
         if [ ! -f "$DIR/result/q$i.txt" ];
         then
            echo -e "running $i ..."
            $DIR/scripts/time_query.sh employees $DIR/gprom_queries/$i.sql 10 2 > $DIR/result/q_temp.txt
            mv $DIR/result/q_temp.txt $DIR/result/$i.txt
         fi;                
done;