# Reproducibility Instructions for "Snapshot Semantics for Temporal Multiset Relations"

## Paper:

- **title**: Snapshot Semantics for Temporal Multiset Relations
- **abstract**: Snapshot semantics is widely used for evaluating queries over temporal data: temporal relations are seen as sequences of snapshot relations, and queries are evaluated at each snapshot. In this work, we demonstrate that current approaches for snapshot semantics over interval-timestamped multiset relations are subject to two bugs regarding snapshot aggregation and bag difference. We introduce a novel temporal data model based on K-relations that overcomes these bugs and prove it to correctly encode snapshot semantics. Furthermore, we present an efficient implementation of our model as a database middleware and demonstrate experimentally that our approach is competitive with native implementations.
- **reproducibility instructions**: Our reproducibility submission is available as a git repository on github: https://github.com/IITDBGroup/2019-PVLDB-Reproducibility-Snapshot-Semantics-For-Temporal-Multiset-Relations . The `README.md` file contains instructions for the reproducibility committee.

## Information

-    A short description of the hardware needed to run your code and reproduce experiments included in the paper, with detailed specification of unusual or not commercially available hardware. If your hardware is sufficiently specialized, please have plans to allow the reviewers to access your hardware.
-    A short description of any software or data necessary to run your code and reproduce experiments included in the paper, particularly if it is restricted-access (e.g., commercial software without a free demo or academic version). If this is the case, please have plans to allow the reviewers access to any necessary software or data.

## Datasets

We used two datasets in our experiments:

- A MySQL temporal test database from: https://github.com/datacharmer/test_db
- Our version of TPC-BiH (SF1 and SF10), a temporal version of TPC-H. We contacted the authors of this benchmark and they could not make the benchmark data available to us. Thus, we generated data following on the description in reference [25].

In our accompanying technical report we also use a third dataset (*Tourism*). However, this dataset is proprietary and, thus, we can only share the dataset in anonymize form

## Software

We ran all experiments using our implementation of the rewriting for sequenced temporal queries in [GProM](https://github.com/IITDBGroup/gprom). GProM compiles such queries into SQL code for various backend SQL dialects. In our experiments we used four  backend databases:

- PostgreSQL version
- The version of PostgreSQL with temporal support from
- Oracle (running on our server)
- Teradata (available for free as a VM)

### GProM

[GProM](https://github.com/IITDBGroup/gprom) is a middleware that enhances SQL with new language features such as provenance, uncertainty management, and the temporal extensions presented in this paper.

### PostgreSQL



### Temporal PostgreSQL



### Oracle

Since Oracle is a proprietary system we cannot directly provide the system. Either follow our instructions for setting up the database or contact us and we will provide access an Oracle installation that can be used in the experiments.

### Teradata

Since Teradata is only available for free as a virtual machine installation, we TODO

## Setup

For your convenience we provide a docker image that contains GProM and the open source databases preloaded with the datasets used in the experiments. To retrieve the image run:

~~~sh
sudo docker pull iitdbgroup/2019-pvldb-snapshot-temporal-reproducibility
~~~




## Alternative Manual Setup

Alternatively, you can manually setup the
