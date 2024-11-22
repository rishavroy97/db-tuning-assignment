import mariadb
import pandas as pd
import sys

def get_connection():
    try:
        connection = mariadb.connect(
            user="",
            password="",
            host="localhost",
            port="",
            unix_socket=""
        )
        print("Connected to MariaDB!!")
    except mariadb.Error as e:
        print(f"Error connecting to MariaDB: {e}")
        sys.exit(1)
    
    return connection

def create_db(cursor):
    db_create_query = "CREATE DATABASE IF NOT EXISTS trades_db;"
    db_use_query = " USE trades_db;"
    
    try:
        cursor.execute(db_create_query)
        cursor.execute(db_use_query)
    except mariadb.Error as e:
        print(f"Error creating DB: {e}")
        sys.exit(1)

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
    
    create_db(cursor)
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
        connection.rollback()
    finally:
        cursor.close()
        connection.close()


if __name__ == '__main__':
    csv_file_path = "trades.csv"

    for chunk in pd.read_csv(csv_file_path, chunksize=100_000):
        load_csv_to_db(chunk, "trade")