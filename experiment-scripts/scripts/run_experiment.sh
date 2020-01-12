#!/bin/bash

DIR=/reproducibility/experiment-scripts/scripts
RES=/reproducibility/experiment-scripts/result

$DIR/run_gprom.sh
$DIR/run_queries.sh
$DIR/run_aqueries.sh
$DIR/extract_result.sh
python3 $RES/plot.py
