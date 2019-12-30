#!/bin/bash
docker build . -f Dockerfile -t iitdbgroup/2019-pvldb-snapshot-temporal-reproducibility-data
docker build . -f Dockerfile -t iitdbgroup/2019-pvldb-snapshot-temporal-reproducibility
