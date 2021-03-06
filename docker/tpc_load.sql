CREATE TABLE time_lineitem
(
    L_ORDERKEY int,
    L_PARTKEY int,
    L_SUPPKEY int,
    L_LINENUMBER int,
    L_QUANTITY FLOAT(53),
    L_EXTENDEDPRICE FLOAT(53),
    L_DISCOUNT FLOAT(53),
    L_TAX FLOAT(53),
    L_RETURNFLAG TEXT,
    L_LINESTATUS TEXT,
    L_SHIPDATE DATE,
    L_COMMITDATE DATE,
    L_RECEIPTDATE DATE,
    L_SHIPINSTRUCT TEXT,
    L_SHIPMODE TEXT,
    L_COMMENT TEXT,
    ACTIVE_TIME_BEGIN DATE,
    ACTIVE_TIME_END DATE,
    PRIMARY KEY (L_ORDERKEY, L_LINENUMBER)
);


CREATE TABLE time_nation
(
    N_NATIONKEY int,
    N_NAME TEXT,
    N_REGIONKEY int,
    N_COMMENT TEXT,
    ACTIVE_TIME_BEGIN DATE,
    ACTIVE_TIME_END DATE,
    PRIMARY KEY (N_NATIONKEY)
);



CREATE TABLE time_orders
(
    O_ORDERKEY int,
    O_CUSTKEY int,
    O_ORDERSTATUS TEXT,
    O_TOTALPRICE FLOAT(53),
    O_ORDERDATE DATE,
    O_ORDERPRIORITY TEXT,
    O_CLERK TEXT,
    O_SHIPPRIORITY int,
    O_COMMENT TEXT,
    ACTIVE_TIME_BEGIN DATE,
    ACTIVE_TIME_END DATE,
    RECEIVABLE_TIME_BEGIN DATE,
    RECEIVABLE_TIME_END DATE,
    PRIMARY KEY (O_ORDERKEY)
);


CREATE TABLE time_customer
(
    C_CUSTKEY int,
    C_NAME TEXT,
    C_ADDRESS TEXT,
    C_NATIONKEY int,
    C_PHONE TEXT,
    C_ACCTBAL FLOAT(53),
    C_MKTSEGMENT TEXT,
    C_COMMENT TEXT,
    VISIBLE_TIME_BEGIN DATE,
    VISIBLE_TIME_END DATE,
    PRIMARY KEY (C_CUSTKEY)
);


CREATE TABLE time_part
(
    P_PARTKEY int,
    P_NAME TEXT,
    P_MFGR TEXT,
    P_BRAND TEXT,
    P_TYPE TEXT,
    P_SIZE int,
    P_CONTAINER TEXT,
    P_RETAILPRICE FLOAT(53),
    P_COMMENT TEXT,
    AVAILABLE_TIME_BEGIN DATE,
    AVAILABLE_TIME_END DATE,
    PRIMARY KEY (P_PARTKEY)
);



CREATE TABLE time_partsupp
(
    PS_PARTKEY int,
    PS_SUPPKEY int,
    PS_AVAILQTY int,
    PS_SUPPLYCOST FLOAT(53),
    PS_COMMENT TEXT,
    VALIDITY_TIME_BEGIN DATE,
    VALIDITY_TIME_END DATE,
    PRIMARY KEY (PS_PARTKEY, PS_SUPPKEY)
);

CREATE TABLE time_region
(
    R_REGIONKEY int,
    R_NAME TEXT,
    R_COMMENT TEXT,
    ACTIVE_TIME_BEGIN DATE,
    ACTIVE_TIME_END DATE,
    PRIMARY KEY (R_REGIONKEY)
);


CREATE TABLE time_supplier
(
    S_SUPPKEY int,
    S_NAME TEXT,
    S_ADDRESS TEXT,
    S_NATIONKEY int,
    S_PHONE TEXT,
    S_ACCTBAL FLOAT(53),
    S_COMMENT TEXT,
    ACTIVE_TIME_BEGIN DATE,
    ACTIVE_TIME_END DATE,
    PRIMARY KEY (S_SUPPKEY)
);

COPY time_part FROM '/datasets/tpcbih/time_part.csv' WITH CSV DELIMITER ',' HEADER;
COPY time_supplier FROM '/datasets/tpcbih/time_supplier.csv' WITH CSV DELIMITER ',' HEADER;
COPY time_partsupp FROM '/datasets/tpcbih/time_partsupp.csv' WITH CSV DELIMITER ',' HEADER;
COPY time_customer FROM '/datasets/tpcbih/time_customer.csv' WITH CSV DELIMITER ',' HEADER;
COPY time_orders FROM '/datasets/tpcbih/time_orders.csv' WITH CSV DELIMITER ',' HEADER;
COPY time_lineitem FROM '/datasets/tpcbih/time_lineitem.csv' WITH CSV DELIMITER ',' HEADER;
COPY time_nation FROM '/datasets/tpcbih/time_nation.csv' WITH CSV DELIMITER ',' HEADER;
COPY time_region FROM '/datasets/tpcbih/time_region.csv' WITH CSV DELIMITER ',' HEADER;

vacuum analyze;
