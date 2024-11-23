import mariadb
import pandas as pd
import random
import sys
from config import db_config

TOTAL_ROWS = 1000000
BATCH_SIZE = 1000

def get_connection():
    try:
        connection = mariadb.connect(**db_config)
        print("Connected to MariaDB!!")
    except mariadb.Error as e:
        print(f"Error connecting to MariaDB: {e}")
        sys.exit(1)
    
    return connection

def generate_user_dataframe(start_id, num_rows):
    data = {
        "name": [f"User{i}" for i in range(start_id, start_id + num_rows)],
        "email": [f"user{i}@example.com" for i in range(start_id, start_id + num_rows)],
        "status": random.choices(
            ['inactive', 'active', 'pending'],
            weights=[0.1, 50, 49.9],
            k=num_rows
        )
    }
    return pd.DataFrame(data)


def insert_dataframe_in_batches():
    try:
        conn = mariadb.connect(**db_config)
        cursor = conn.cursor()

        for batch_start in range(0, TOTAL_ROWS, BATCH_SIZE):
            
            batch_df = generate_user_dataframe(batch_start, BATCH_SIZE)
            data_tuples = batch_df.to_records(index=False).tolist()

            cursor.executemany(
                "INSERT INTO users (name, email, status) VALUES (?, ?, ?)",
                data_tuples
            )
            conn.commit()
            print(f"Inserted batch starting at row {batch_start}")

        print("All data inserted successfully.")
        cursor.close()
        conn.close()

    except mariadb.Error as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    insert_dataframe_in_batches()
