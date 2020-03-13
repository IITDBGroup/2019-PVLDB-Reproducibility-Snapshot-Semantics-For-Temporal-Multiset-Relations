# Reproducibility Instructions for "Snapshot Semantics for Temporal Multiset Relations"

# Paper

- **title**: Snapshot Semantics for Temporal Multiset Relations
- **abstract**: Snapshot semantics is widely used for evaluating queries over temporal data: temporal relations are seen as sequences of snapshot relations, and queries are evaluated at each snapshot. In this work, we demonstrate that current approaches for snapshot semantics over interval-timestamped multiset relations are subject to two bugs regarding snapshot aggregation and bag difference. We introduce a novel temporal data model based on K-relations that overcomes these bugs and prove it to correctly encode snapshot semantics. Furthermore, we present an efficient implementation of our model as a database middleware and demonstrate experimentally that our approach is competitive with native implementations.
- **reproducibility instructions**: Our reproducibility submission is available as a git repository on github: [https://github.com/IITDBGroup/2019-PVLDB-Reproducibility-Snapshot-Semantics-For-Temporal-Multiset-Relations](https://github.com/IITDBGroup/2019-PVLDB-Reproducibility-Snapshot-Semantics-For-Temporal-Multiset-Relations). The `README.md` file contains instructions for the reproducibility committee.

# Hardware

All runtime experiments were executed on a server with the specs shown below.

| Element          | Description                                                                   |
|------------------|-------------------------------------------------------------------------------|
| CPU              | 2 x AMD Opteron(tm) Processor 4238, 3.3Ghz                                    |
| Caches (per CPU) | L1 (288KiB), L2 (6 MiB), L3 (6MiB)                                            |
| Memory           | 128GB (DDR3 1333MHz)                                                          |
| RAID Controller  | LSI Logic / Symbios Logic MegaRAID SAS 2108 [Liberator] (rev 05), 512MB cache |
| RAID Config      | 4 x 1TB, configured as RAID 5                                                 |
| Disks            | 4 x 1TB 7.2K RPM Near-Line SAS 6Gbps (DELL CONSTELLATION ES.3)                |

For experiments with Oracle and Teradata we will provide access to one of our machines as described below.

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

# Run experiments (Postgres and Temporal Postgres)

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

## Background

For experiments that use our sequenced temporal semantics we use GProM to automatically rewrite queries into the SQL dialect of Postgres or Oracle. Queries using the temporal features of TPG or Teradata and created manually. For these queries we include the SQL scripts.

# Run experiments (Oracle and Teradata)

Since we cannot distribute these systems because of licensing issues, we provide access to the machine we did run the experiments on originally. Please contact Boris Glavic [bglavic@iit.edu](bglavic@iit.edu) or Xing
Niu [xniu7@hawk.iit.edu](xniu7@hawk.iit.edu) for credentials.

## Oracle



## Teradata

# Suggestions for additional experiments

For additional experiments we provide the **flights** dataset that records the actual period in minutes of flights. Each record consists of an identifier (*id*), flight number (*flight_number*), departure airport (*departure_airport*), destination airport (*arrival_airport*), aircraft (*aircraftid*), and actual departure time (*departure_time*) and arrival time (*arrival_time*). The dataset records 57,585 flights over a period of 10 days in November 2014.

For this dataset we provide several example queries, such as *What is the number of aircrafts in air at the same time?* or *Which aircrafts are in the air at the same time and arrive at the same destination?*.

## Running custom temporal queries with gprom

You can use the GProM installation from the docker image to iteratively run queries with snapshot temporal semantics. GProM comes with a CLI client for running queries.
First start a container from the reproducibility image:

~~~sh
sudo docker run -d --rm --name run_gprom iitdbgroup/2019-pvldb-snapshot-temporal-reproducibility
~~~

Then create a bash session inside the container and run GProM and connect to the postgres backend running inside the container:

~~~
sudo docker exec -ti run_gprom /bin/bash
root@9bd801801bb9:/reproducibility# gprom -backend postgres -user postgres -port 5432 -db postgres
~~~

Here we provide some ideas of what queries you could try:

**TODO**


# Appendix

## Alternative Manual Setup

Alternatively, you can manually setup the systems for experiments on your own machine. To run the Postgres experiments you need to install both a regular postgres server and the temporal postgres (TPG) maintained by Anton Dignoes. Furthermore, you need to build GProM with support for Postgres backends (GProM can be compiled to support several backends by linking against the C client libraries of these backends). We provide instructions below.

### Installing GProM

To install GProM from source you should follow the instructions from [https://github.com/IITDBGroup/gprom](https://github.com/IITDBGroup/gprom). Please use the `temporal` branch:

~~~sh
git clone --single-branch --branch temporal https://github.com/IITDBGroup/gprom.git
~~~

### Installing Postgres

You can install Postgres from source or using your package managers (e.g., apt on Ubuntu or homebrew on mac). The directory where the database files are stored is called a "cluster" in Postgres terminology. We provide a separate docker container with the database dumps that you can use to load the data used in the experiments. This dumps can be loaded using the `psql` client (part of a Postgres installation).

### Installing TPG (Temporal Postgres)

Currently, TPG, the temporal extension of Postgres we are using, has to be installed from source (available [here](http://tpg.inf.unibz.it/). Once installed, loading data works just like with regular Postgres. Please follow the instructions from this webpage to install from source.

### Loading data

-- TODO explain

### Running experiments

Clone the reproducibility repository [https://github.com/IITDBGroup/2019-PVLDB-Reproducibility-Snapshot-Semantics-For-Temporal-Multiset-Relations](https://github.com/IITDBGroup/2019-PVLDB-Reproducibility-Snapshot-Semantics-For-Temporal-Multiset-Relations) to get the scripts used to run the experiments and plotting the results. Note that you will have to edit a configuration file to account for the connection settings of your local postgres installation.

-- TODO explain
