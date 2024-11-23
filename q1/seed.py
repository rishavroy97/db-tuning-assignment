import mariadb
import pandas as pd
import sys
from config import db_config

def get_connection():
    try:
        connection = mariadb.connect(**db_config)
        print("Connected to MariaDB!!")
    except mariadb.Error as e:
        print(f"Error connecting to MariaDB: {e}")
        sys.exit(1)
    
    return connection

def create_table(cursor, table_name):
    try:
        cursor.execute(f"""
        CREATE TABLE IF NOT EXISTS {table_name} (
            stocksymbol INT,
            time INT PRIMARY KEY,
            quantity INT,
            price INT
        );
        """)
    except mariadb.Error as e:
        print(f"Error creating table: {e}")
        sys.exit(1)
    

def load_csv_to_db(df, table_name):

    connection = get_connection()
    cursor = connection.cursor()

    create_table(cursor, table_name)
    
    insert_query = f"""
    INSERT INTO {table_name} (stocksymbol, time, quantity, price)
    VALUES (%s, %s, %s, %s)
    """
    
    records = df.values.tolist()
    
    try:
        cursor.executemany(insert_query, records)
        connection.commit()
        print(f"Inserted {len(records)} rows into the table {table_name}.")
    except mariadb.Error as e:
        print(f"Error occurred while inserting records: {e}")
    finally:
        cursor.close()
        connection.close()


if __name__ == '__main__':
    csv_file_path = "trades.csv"

    for chunk in pd.read_csv(csv_file_path, chunksize=100_000):
        load_csv_to_db(chunk, "trade")