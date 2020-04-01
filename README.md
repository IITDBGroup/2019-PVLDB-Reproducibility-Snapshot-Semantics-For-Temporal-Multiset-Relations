# Reproducibility Instructions for "Snapshot Semantics for Temporal Multiset Relations"

# Paper

- **title**: Snapshot Semantics for Temporal Multiset Relations
- **pdf link**: [http://www.vldb.org/pvldb/vol12/p639-dignoes.pdf](http://www.vldb.org/pvldb/vol12/p639-dignoes.pdf)
- **abstract**: Snapshot semantics is widely used for evaluating queries over temporal data: temporal relations are seen as sequences of snapshot relations, and queries are evaluated at each snapshot. In this work, we demonstrate that current approaches for snapshot semantics over interval-timestamped multiset relations are subject to two bugs regarding snapshot aggregation and bag difference. We introduce a novel temporal data model based on K-relations that overcomes these bugs and prove it to correctly encode snapshot semantics. Furthermore, we present an efficient implementation of our model as a database middle-ware and demonstrate experimentally that our approach is competitive with native implementations.
- **reproducibility instructions**: Our reproducibility submission is available as a git repository hosted on github: [https://github.com/IITDBGroup/2019-PVLDB-Reproducibility-Snapshot-Semantics-For-Temporal-Multiset-Relations](https://github.com/IITDBGroup/2019-PVLDB-Reproducibility-Snapshot-Semantics-For-Temporal-Multiset-Relations). The `README.md` file contains instructions for the reproducibility committee.

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

For experiments with Oracle and Teradata we provide access to one of our machines as described below (credentials are shared through the reproducibility submission only).

# Datasets

We used two datasets in our experiments:

- A MySQL temporal test database from: https://github.com/datacharmer/test_db
- Our version of TPC-BiH (SF1 and SF10), a temporal version of TPC-H. We contacted the authors of this benchmark and they could not make the benchmark data available to us. Thus, we generated data following on the description in reference [25].

In our accompanying technical report we also use a third dataset (*Tourism*). However, this dataset is proprietary and, thus, we can not share it. Instead we provide a dataset *Flights* for additional experiment and ad hoc queries.

# Software

We ran all experiments using the implementation of our rewriting for sequenced temporal queries in [GProM](https://github.com/IITDBGroup/gprom). GProM compiles such queries into SQL code for various backend SQL dialects. In our experiments we used four  backend databases:

- PostgreSQL version
- The version of PostgreSQL with temporal support from [http://tpg.inf.unibz.it/](http://tpg.inf.unibz.it/)
- Oracle (running on our server)
- Teradata (available for free as a VM)

Everything needed to run experiments with the two PostgreSQL versions is available as a docker image. We provide access to Oracle and Teradata on one of our machines (only for the reproducibility committee).

## GProM

[GProM](https://github.com/IITDBGroup/gprom) is a middleware that enhances SQL with new language features such as provenance, uncertainty management, and the temporal extensions presented in this paper. A short description of how to use the sequenced temporal features can be found [here](https://github.com/IITDBGroup/gprom/wiki/temporal).

## PostgreSQL

One of the backends we use is [PostgreSQL](https://www.postgresql.org/).

## Temporal PostgreSQL

We also use [tpg](http://tpg.inf.unibz.it/), an extension of PostgreSQL with native temporal query processing capabilities.

## Oracle

Since Oracle is a proprietary system we cannot directly provide the system. See instructions below or contact us and we will provide access to an Oracle installation that can be used in the experiments (only for the reproducibility committee).

## Teradata

Teradata is available for free as a virtual machine installation that we used in our experiments. We provide access to a running version on one of our servers (only for the reproducibility committee).

# Setup

For your convenience we provide a docker image that contains GProM,  the open source databases used in our experiments preloaded with the datasets used in the experiments, and scripts for running experiments and plotting results. To retrieve the image run (*note that this images is several GB large, so it may take a while*):

~~~sh
sudo docker pull iitdbgroup/2019-pvldb-snapshot-temporal-reproducibility
~~~

Alternatively you can manually setup the environment. In case this is necessary, please follow the [instructions below](#alternative-manual-setup).

# Run experiments (Postgres and Temporal Postgres)

To run the experiments, use the provided docker image. First create a directory on your host machine to store the results:

~~~sh
mkdir -p ~/temporal-results
cd ~/temporal-results
~~~

Start the image which will run the `/entrypoint.sh` script which starts up the two postgres systems and then sleeps:

**WARNING: the following command starts the container with 110GB of memory to get an equivalent environment as used in our experiments. If you do not have access to a machine with this amount of memory, then you can use an alternative image as described below for which postgres is setup to use less memory. However, the observed query runtimes may significantly differ from the runtimes reported in our paper.**

~~~sh
sudo docker run -M 110G -d --name seqrepro -v $(pwd):/reproducibility/results -p 6432:5432 -p 6433:5433 iitdbgroup/2019-pvldb-snapshot-temporal-reproducibility
~~~

Note that the `-p` options expose the two postgres servers network ports as ports `6432` (regular postgres) and `6433` (temporal postgres) on your host machine. This is not necessary for running the experiments, but allows you to access the databases from your host, e.g., to explore the loaded data.

Now start a shell inside the container and run the main experiment script:

~~~sh
sudo docker exec -ti seqrepro /bin/bash
root@9bd801801bb9:/reproducibility# cd /reproducibility/experiment-scripts/scripts
root@9bd801801bb9:/reproducibility# ./run-experiment.sh
~~~

The whole experimental evaluation will take about 5 days depending on your hardware. The script is setup to not overwrite existing files, i.e., an interrupted run can be continued from the last successful experiment by repeating the last steps described above to create a container and run the script.

## Lower Memory Images

We provide an additional image `iitdbgroup/2019-pvldb-snapshot-temporal-reproducibility:4GB` which only requires 4GB of memory. If you have to you can use this instead. You can also manually change the memory requirements by editing the `postgresql.conf` file the image such that the two postgres installations use less memory.

## Background

For experiments that use our sequenced temporal semantics we use GProM to automatically rewrite queries into the SQL dialect of Postgres or Oracle. Queries using the temporal features of TPG or Teradata and created manually. For these queries we include the SQL scripts.

# Run experiments (Oracle and Teradata)

Since we cannot distribute these systems because of licensing issues, we provide access to the machine we did run the experiments on originally. Please contact Boris Glavic [bglavic@iit.edu](bglavic@iit.edu) or Xing
Niu [xniu7@hawk.iit.edu](xniu7@hawk.iit.edu) for credentials.

- **If multiple persons are running the reproducibility experiments, please ensure that you are never running more than one instance of the Oracle and Teradata experiments  at the same time.**
- **Please contact us before starting these experiments since our servers are also used for other unrelated experiments.**

## Oracle

We are running the Oracle experiments on one of our server (`ligeti.cs.iit.edu`).

<!-- TODO -->
1. Login to ligeti server: `ssh reproduce@ligeti.cs.iit.edu`
2. Go to the scripts folder: `cd /home/reproduce/temporal_paper_reproducibility/scripts`
3. Run `./run_queries.sh` to run the experiment and the result is in the result folder under path `/home/reproduce/temporal_paper_reproducibility/result` (`tpcbih.csv`, `employee.csv` and `multiset.csv`).

**These experiments take roughly take 3 days to finish on our hardware.**

## Teradata

We are using a virtual machine to run the Teradata experiments that is running on our server.

1. Forward port: `ssh -f -N -L 5900:localhost:5900 reproduce@debussy.cs.iit.edu`
2. Connect to the virtual machine remotely using a VNC viewer. Since we forwarded the VNC port to your local host, you need to connect to `localhost` or `127.0.0.1` (e.g., using VNC viewer, `ip:localhost`).
3. Go to the scripts folder: `cd /root/Desktop/xing/scripts`
4. Run `./run.sh` to run the experiment and the result could be found in the `result` folder (`employee.csv` and `multiset.csv`)
5. Please let us know if you have any problems with this setup

**These experiments take roughly take 1 day to finish on our hardware.**


# Suggestions for additional experiments

For additional experiments we provide the **flights** dataset that records the actual duration of flights as a period in minutes. Each record consists of an identifier (*id*), flight number (*flight_number*), departure airport (*departure_airport*), destination airport (*arrival_airport*), aircraft (*aircraftid*), and actual departure time (*departure_time*) and arrival time (*arrival_time*). The dataset records 57,585 flights over a period of 10 days in November 2014.

For this dataset we provide several example queries, such as *What is the number of aircrafts in air at the same time?* or *Which aircrafts are in the air at the same time and arrive at the same destination?*.

## Running custom temporal queries with GProM

You can use the GProM installation from the docker image to interactively run
queries with snapshot temporal semantics. GProM comes with a CLI client for
running queries.  First start a container from the reproducibility image:

~~~sh
sudo docker run -d --rm --name run_gprom iitdbgroup/2019-pvldb-snapshot-temporal-reproducibility
~~~

Then create a bash session inside the container and run GProM and connect to the postgres backend running inside the container:

~~~sh
sudo docker exec -ti run_gprom /bin/bash
root@9bd801801bb9:/reproducibility# gprom -backend postgres -host 127.0.0.1 -user postgres -port 5432 -db time_flights
~~~

The repository contains some example queries you could try in [SQL script](datasets/flights/queries.sql). For instance, to count the number of flights in the air at each time (ordered by time =t_b=):

~~~sh
SELECT * FROM (SEQUENCED TEMPORAL (SELECT COUNT(*) FROM flights WITH TIME (departure_time, arrival_time))) seq ORDER BY t_b;
~~~

**Note that per default in GProM every line you enter is interpreted as a query. If you want to split a query over multiple lines (a line ending in `;` finishes the current query), then enter `\m`.**

# Appendix

## Alternative Manual Setup

Alternatively, you can manually setup the systems for experiments on your own machine. To run the Postgres experiments you need to install both a regular postgres server and the temporal postgres (TPG) maintained by Anton Dignös. Furthermore, you need to build GProM with support for Postgres backends (GProM can be compiled to support several backends by linking against the C client libraries of these backends). We provide instructions below.

### Installing GProM

To install GProM from source you should follow the instructions from [https://github.com/IITDBGroup/gprom](https://github.com/IITDBGroup/gprom). Please use the `temporal` branch:

~~~sh
git clone --single-branch --branch temporal https://github.com/IITDBGroup/gprom.git
~~~

### Installing Postgres

You can install Postgres from source or using your package managers (e.g., apt on Ubuntu or homebrew on mac). The directory where the database files are stored is called a "cluster" in Postgres terminology. We provide a separate docker container with the database dumps that you can use to load the data used in the experiments. This dumps can be loaded using the `psql` client (part of a Postgres installation).

### Installing TPG (Temporal Postgres)

Currently, TPG, the temporal extension of Postgres we are using, has to be installed from source (available [here](http://tpg.inf.unibz.it/). Once installed, loading data works just like with regular Postgres. Please follow the instructions from this webpage to install from source.

### Create Postgres clusters

You need to create clusters (Postgres speak for the directory storing the database files) for both installations. Have a look at `docker/tpg_quickbuild.sh` and use `initdb` for the other normal postgres installation.

### Postgres configuration files

We provide a configuration file for postgres to be used for both installations. Please copy `docker/postgresql.conf` into the clusters you have created.

### Loading data

This part consists of two steps. First extracting the data from the docker container and then importing it into the two postgres installations. For that start up a container from the image and use `pg_dump` to dump out both databases and then load them into your local installations ([Postgres documentation](https://www.postgresql.org/docs/9.5/backup-dump.html)).


### Running experiments

Clone the reproducibility repository [https://github.com/IITDBGroup/2019-PVLDB-Reproducibility-Snapshot-Semantics-For-Temporal-Multiset-Relations](https://github.com/IITDBGroup/2019-PVLDB-Reproducibility-Snapshot-Semantics-For-Temporal-Multiset-Relations) to get the scripts used to run the experiments and plotting the results. Note that you will have to edit a configuration file to account for the connection settings of your local postgres installation.

#### Starting up Postgres

Please run the both Postgres installation. The temporal one should listen on port `5433` and standard Postgres on `5432`.

#### Adapt the experiment scripts

You may have to change paths in the experiment scripts in `experiment-scripts/scripts`.

#### Running the experiments script

Run `experiment-scripts/run_experiment.sh`. Note that this can take several days to run depending on your hardware. Experiments can be restarted and continued from where you left of as explained above.
