#!/bin/bash

DIR=/reproducibility/experiment-scripts/scripts

$DIR/run_gprom.sh
$DIR/run_queries.sh
$DIR/run_aqueries.sh
$DIR/extract_result.sh
