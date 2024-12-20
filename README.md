# db-tuning-assignment

```
python -m venv hw2
source hw2/bin/activate
pip install -r requirements.txt
```

## Q1. Fractal Stock trades distribution

### Steps

 - Go to q1 directory: `cd q1`
 - Generate the `trades.csv` file by running `python generate-data.py`
 - Load the CSV file into the database
 - Run the Queries from `aquery.sql`

## Q2. Rule of Thumbs

### Steps

 - Go to q2 directory: `cd ../q2`

#### Rule of Thumb 1

 - Generate data for Rule of Thumb 1 by running `rot1-gen-csv.py`
 - Run the queries from `rot1-mariadb.sql` in MariaDB
 - Run the queries from `rot1-pgsql.sql` in PostgreSQL

#### Rule of Thumb 2

 - Generate data for Rule of Thumb 1 by running `rot2-gen-csv.py`
 - Run the queries from `rot2-mariadb.sql` in MariaDB
 - Run the queries from `rot2-pgsql.sql` in PostgreSQL
