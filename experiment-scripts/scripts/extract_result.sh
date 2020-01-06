#!/bin/bash

DIR=/reproducibility/experiment-scripts

if [ -f "$DIR/result/tpcbih.csv" ];
then
    cat /dev/null > "$DIR/result/tpcbih.csv"
fi;

echo "query,cost" >> $DIR/result/tpcbih.csv
for j in 1 5 6 7 8 9 12 14 19
do
	    l1=q"$j"
		avg1=$(grep 'Avg runtime is' $DIR/result/q"$j".txt | sed -e 's/Avg runtime is [[:space:]]*//g')
		avg2=$(printf "%.4f\n" $avg1)
		l1="$l1,$avg2"
	    echo "$l1" >> $DIR/result/tpcbih.csv
done



if [ -f "$DIR/result/employee.csv" ];
then
    cat /dev/null > "$DIR/result/employee.csv"
fi;

echo "query,cost" >> $DIR/result/employee.csv
for j in join1 join3 join4 agg1 agg2 agg3 diff1 diff2
do
	   l1="$j"	
		avg1=$(grep 'Avg runtime is' $DIR/result/"$j".txt | sed -e 's/Avg runtime is [[:space:]]*//g')
		avg2=$(printf "%.4f\n" $avg1)
		l1="$l1,$avg2"
	    echo "$l1" >> $DIR/result/employee.csv
done


if [ -f "$DIR/result/multiset.csv" ];
then
    cat /dev/null > "$DIR/result/multiset.csv"
fi;

echo "query,cost" >> $DIR/result/multiset.csv
for j in 1k 10k 100k 300k 500k 1000k 3000k
do
	    l1=q"$j"
		avg1=$(grep 'Avg runtime is' $DIR/result/q"$j".txt | sed -e 's/Avg runtime is [[:space:]]*//g')
		avg2=$(printf "%.4f\n" $avg1)
		l1="$l1,$avg2"
	    echo "$l1" >> $DIR/result/multiset.csv
done