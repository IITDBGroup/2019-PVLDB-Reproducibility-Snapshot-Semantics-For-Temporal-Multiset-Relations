########################################
# Derived from gprom travis build image which supports all backends
########################################
FROM iitdbgroup/2019-pvldb-snapshot-temporal-reproducibility-data
MAINTAINER Boris Glavic <bglavic@iit.edu>
########################################
# User root
########################################
USER root
########################################
# Clone GProM github repository
########################################
RUN git clone --single-branch --branch temporal https://github.com/IITDBGroup/gprom.git /gprom/src
########################################
# Build GProM
########################################
RUN cd /gprom/src \
	&& make -f Makefile.maintainer \
	&& ./configure --with-oci-headers=/usr/local/oracle/include/oracle/12.2/client64/ --with-oci-lib=/usr/local/oracle/lib/oracle/12.2/client64/lib/ --disable-monetdb  --with-libpq-headers=/usr/include/postgresql --disable-java \
	&& make -j 8 \
	&& make install
########################################
# Clone reproducibility repro
########################################
RUN git clone https://github.com/IITDBGroup/2019-PVLDB-Reproducibility-Snapshot-Semantics-For-Temporal-Multiset-Relations.git /reproducibility
########################################
# Setup workdin
########################################
WORKDIR /reproducibility
########################################
# Setup postgresql
########################################
ADD postgresql.conf /data/postgres/postgresql.conf
ADD postgresql.conf /data/tpg/postgresql.conf
########################################
# Per default start a script that just sleeps
########################################
ADD ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
