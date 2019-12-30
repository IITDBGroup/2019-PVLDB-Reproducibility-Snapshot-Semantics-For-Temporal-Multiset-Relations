/home/perm/postgres11/install/bin/createdb employees -p 5440
/home/perm/postgres11/install/bin/psql employees -p 5440
--create tpch 1gb tables and import data
/home/perm/postgres11/install/bin/psql -d tpch_1g_t -f ddl_1_100page_1.sql -p 5440
--login into tpch_1gb
/home/perm/postgres11/install/bin/psql tpch_1g_t.sql -p 5440

--  Sample employee database for PostgreSQL
--  See changelog table for details
--  Created from MySQL Employee Sample Database (http://dev.mysql.com/doc/employee/en/index.html)
--  Created by Vraj Mohan
--  DISCLAIMER
--  To the best of our knowledge, this data is fabricated, and
--  it does not correspond to real people.
--  Any similarity to existing people is purely coincidental.
--

CREATE TYPE gender AS ENUM('M', 'F');

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      gender 		NULL,
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE   	(dept_name)
);

CREATE TABLE dept_manager (
   dept_no      CHAR(4)         NOT NULL,
   emp_no       INT             NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
);

CREATE INDEX dept_manager_dept_no_idx ON dept_manager(dept_no);

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE INDEX dept_emp_dept_no_idx ON dept_emp(dept_no);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
);


CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
);

\echo 'LOADING departments'
\i /home/perm/xing/data/pgsql-sample-data-master/employee/load_departments.sql
\echo 'LOADING employees'
\i /home/perm/xing/data/pgsql-sample-data-master/employee/load_employees.sql
\echo 'LOADING dept_emp'
\i /home/perm/xing/data/pgsql-sample-data-master/employee/load_dept_emp.sql
\echo 'LOADING dept_manager'
\i /home/perm/xing/data/pgsql-sample-data-master/employee/load_dept_manager.sql
\echo 'LOADING titles'
\i /home/perm/xing/data/pgsql-sample-data-master/employee/load_titles.sql
\echo 'LOADING salaries'
\i /home/perm/xing/data/pgsql-sample-data-master/employee/load_salaries.sql
