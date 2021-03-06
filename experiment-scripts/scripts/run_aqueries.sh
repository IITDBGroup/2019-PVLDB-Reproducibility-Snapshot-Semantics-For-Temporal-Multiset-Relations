#!/bin/bash


DIR=/reproducibility/experiment-scripts

if [ ! -d "$DIR/result" ];
then
        mkdir $DIR/result
fi;

#run anton's query
echo -e "run pg_nat ..."
for i in 1k 10k 100k 300k 500k 1000k 3000k
do
         if [ ! -f "$DIR/result/aq$i.txt" ];
         then
            echo -e "running q$i ..."
            $DIR/scripts/time_aquery.sh employees $DIR/queries/pg_nat/$i.sql 100 5 > $DIR/result/aq_temp.txt
            mv $DIR/result/aq_temp.txt $DIR/result/aq$i.txt
         fi;            
done;

for i in 6 12 19
do
         if [ ! -f "$DIR/result/aq$i.txt" ];
         then
            echo -e "running q$i ..."
            $DIR/scripts/time_aquery.sh time_tpch_1gb $DIR/queries/pg_nat/q$i.sql 100 5 > $DIR/result/aq_temp.txt
            mv $DIR/result/aq_temp.txt $DIR/result/aq$i.txt
         fi;            
done;

for i in 5 7 8 14 1
do
         if [ ! -f "$DIR/result/aq$i.txt" ];
         then
            echo -e "running q$i ..."
            $DIR/scripts/time_aquery.sh time_tpch_1gb $DIR/queries/pg_nat/q$i.sql 10 2 > $DIR/result/aq_temp.txt
            mv $DIR/result/aq_temp.txt $DIR/result/aq$i.txt
         fi;            
done;


for i in join1 join3 join4 agg2 agg3 diff1 diff2
do
         if [ ! -f "$DIR/result/a$i.txt" ];
         then
            echo -e "running $i ..."
            $DIR/scripts/time_aquery.sh employees $DIR/queries/pg_nat/"$i".sql 100 10 > $DIR/result/aq_temp.txt
            mv $DIR/result/aq_temp.txt $DIR/result/a$i.txt
         fi;         
done;


for i in join2 agg1 agg_join
do
         if [ ! -f "$DIR/result/a$i.txt" ];
         then
            echo -e "running $i ..."
            $DIR/scripts/time_aquery.sh employees $DIR/queries/pg_nat/"$i".sql 10 2 > $DIR/result/aq_temp.txt
            mv $DIR/result/aq_temp.txt $DIR/result/a$i.txt
         fi;         
done;


