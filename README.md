# db-tuning-assignment

```
python -m venv hw2
source hw2/bin/activate
pip install -r requirements.txt
```

## Q1. Fractal Stock trades distribution

### Steps

 - Go to q1 directory: `cd q1`
 - Update the DB connection in `config.py`
 - Generate the `trades.csv` file by running `python generate-data.py`
 - Seed the data to the database (Maria DB) by running `python seed.py`
 - Run the Queries from `q1-mariadb.sql`

## Q2. Rule of Thumbs

### Steps

 - Go to q2 directory: `cd ../q2`
 - Update the DB connection in `config.py`