# Reproducibility Instructions for "Snapshot Semantics for Temporal Multiset Relations"

# Paper

- **title**: Snapshot Semantics for Temporal Multiset Relations
- **abstract**: Snapshot semantics is widely used for evaluating queries over temporal data: temporal relations are seen as sequences of snapshot relations, and queries are evaluated at each snapshot. In this work, we demonstrate that current approaches for snapshot semantics over interval-timestamped multiset relations are subject to two bugs regarding snapshot aggregation and bag difference. We introduce a novel temporal data model based on K-relations that overcomes these bugs and prove it to correctly encode snapshot semantics. Furthermore, we present an efficient implementation of our model as a database middleware and demonstrate experimentally that our approach is competitive with native implementations.
- **reproducibility instructions**: Our reproducibility submission is available as a git repository on github: https://github.com/IITDBGroup/2019-PVLDB-Reproducibility-Snapshot-Semantics-For-Temporal-Multiset-Relations . The `README.md` file contains instructions for the reproducibility committee.

# Information



-    A short description of the hardware needed to run your code and reproduce experiments included in the paper, with detailed specification of unusual or not commercially available hardware. If your hardware is sufficiently specialized, please have plans to allow the reviewers to access your hardware.
-    A short description of any software or data necessary to run your code and reproduce experiments included in the paper, particularly if it is restricted-access (e.g., commercial software without a free demo or academic version). If this is the case, please have plans to allow the reviewers access to any necessary software or data.

# Datasets

We used two datasets in our experiments:

- A MySQL temporal test database from: https://github.com/datacharmer/test_db
- Our version of TPC-BiH (SF1 and SF10), a temporal version of TPC-H. We contacted the authors of this benchmark and they could not make the benchmark data available to us. Thus, we generated data following on the description in reference [25].

In our accompanying technical report we also use a third dataset (*Tourism*). However, this dataset is proprietary and, thus, we can only share the dataset in anonymize form.

# Software

We ran all experiments using our implementation of the rewriting for sequenced temporal queries in [GProM](https://github.com/IITDBGroup/gprom). GProM compiles such queries into SQL code for various backend SQL dialects. In our experiments we used four  backend databases:

- PostgreSQL version
- The version of PostgreSQL with temporal support from
- Oracle (running on our server)
- Teradata (available for free as a VM)

## GProM

[GProM](https://github.com/IITDBGroup/gprom) is a middleware that enhances SQL with new language features such as provenance, uncertainty management, and the temporal extensions presented in this paper.

## PostgreSQL

One of the backends we use is [PostgreSQL](https://www.postgresql.org/).

## Temporal PostgreSQL

We also use [tpg](http://tpg.inf.unibz.it/), an extension of PostgreSQL with native temporal query processing capabilities.

## Oracle

Since Oracle is a proprietary system we cannot directly provide the system. Either follow our instructions for setting up the database or contact us and we will provide access an Oracle installation that can be used in the experiments.

## Teradata

Since Teradata is only available for free as a virtual machine installation, we TODO

# Setup

For your convenience we provide a docker image that contains GPro,  the open source databases used in our experiments preloaded with the datasets used in the experiments, and scripts for running experiments, plotting results, and compiling the paper. To retrieve the image run:

~~~sh
sudo docker pull iitdbgroup/2019-pvldb-snapshot-temporal-reproducibility
~~~

Alternatively you can manually setup the environment. In case this is necessary, please follow the [instructions below](#alternative-manual-setup).

# Run experiments

To the experiments, use the provided docker image. First create a directory of your choice to hold the result:

~~~sh
mkdir -p ~/temporal-results
cd ~/temporal-results
~~~

Start the image which will run the `/entrypoint.sh` script which starts up the two postgres systems and then sleeps:

~~~sh
sudo docker run -d --name seqrepro -v $(pwd):/reproducibility/results -p 6432:5432 -p 6433:5433 iitdbgroup/2019-pvldb-snapshot-temporal-reproducibility
~~~

Note that the `-p` options expose the two postgres servers network ports as ports `6432` (regular postgres) and `6433` (temporal postgres) on your host machine. This is not necessary for running the experiments, but allows you to access the databases from your host, e.g., to explore the loaded data.

Now start a shell inside the container and run the main experiment script:

~~~sh
sudo docker exec -ti seqrepro /bin/bash
root@9bd801801bb9:/reproducibility# ./run-experiments.sh
~~~

The whole experimental evaluation will take about TODO hours depending on your hardware. The script is setup to not overwrite existing files, i.e., an interrupted run can be continued from the last successful experiment.

# Suggestions for additional experiments

## TODO WHAT HERE?

## Running custom temporal queries with gprom




# Appendix

## Alternative Manual Setup

Alternatively, you can manually setup the
