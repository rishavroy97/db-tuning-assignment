import mariadb
import pandas as pd
import random
import sys
from config import db_config

TOTAL_ROWS = 1000000
BATCH_SIZE = 1000

def generate_random_users(start_id, batch_size):
    users = []
    for i in range(start_id, start_id + batch_size):
        name = f"User{i}"
        email = f"user{i}@example.com"
        status = random.choices(
            ['inactive', 'active', 'pending'],
            weights=[0.1, 50, 49.9],
            k=batch_size
        )
        users.append((name, email, status))
    return users


def insert_users():
    try:
        conn = mariadb.connect(**db_config)
        cursor = conn.cursor()

        for batch_start in range(0, TOTAL_ROWS, BATCH_SIZE):
            
            batch_data = generate_random_users(BATCH_SIZE)

            cursor.executemany(
                "INSERT INTO users (name, email, status) VALUES (?, ?, ?)",
                batch_data
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
    insert_users()
