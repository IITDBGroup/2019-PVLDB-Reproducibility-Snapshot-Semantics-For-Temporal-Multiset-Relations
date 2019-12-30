########################################
# Derived from gprom travis build image which supports all backends
########################################
FROM iitdbgroup/gprom_travis
MAINTAINER Boris Glavic <bglavic@iit.edu>
########################################
# Install extra packages for experiments
########################################
RUN apt-get -y update && apt-get install -y \
    ghostscript \
    gnuplot \
    python3 \
    postgresql \
    python3-pip \
    sudo \
    wget \
	&& rm -rf /var/lib/apt/lists/*
########################################
# Clone and install temporal postgres
########################################
ADD tpg_quickbuild.sh /scripts/tpg-install.sh
RUN mkdir -p /tpg /servers /data \
    && chown -R postgres /tpg /servers /scripts/tpg-install.sh /data
USER postgres
RUN cd /tpg \
    && wget http://tpg.inf.unibz.it/downloads/postgresql-9.6beta3-temporal.tar.gz \
    && tar xzf postgresql-9.6beta3-temporal.tar.gz \
    && /scripts/tpg-install.sh
########################################
# Setup clusters for normal postgres
########################################
RUN mkdir -p /data/postgres \
    && /usr/lib/postgresql/9.5/bin/initdb -D /data/postgres
########################################
# Load data
########################################

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
	&& ./configure --with-oci-headers=/usr/local/oracle/include/oracle/12.2/client64/ --with-oci-lib=/usr/local/oracle/lib/oracle/12.2/client64/lib/ --disable-monetdb  \
	&& make \
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
# Per default start a script that just sleeps
########################################
ADD ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
