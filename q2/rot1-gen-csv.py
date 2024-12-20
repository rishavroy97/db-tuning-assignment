import pandas as pd
import random

NUM_ROWS = 1000000

def generate_data(file_path):
    data = {
        "name": [f"User{i}" for i in range(1, NUM_ROWS + 1)],
        "email": [f"user{i}@example.com" for i in range(1, NUM_ROWS + 1)],
        "status": [random.choice(['active', 'inactive', 'pending']) for i in range(1, NUM_ROWS + 1)]
    }
    
    df = pd.DataFrame(data)
    df.to_csv(file_path, index=False)

def generate_exception_data(file_path):
    data = {
        "name": [f"User{i}" for i in range(1, NUM_ROWS + 1)],
        "email": [f"user{i}@example.com" for i in range(1, NUM_ROWS + 1)],
        "status": random.choices(
            ['inactive', 'active', 'pending'],
            weights=[0.1, 50, 49.9],
            k=NUM_ROWS
        )
    }
    
    df = pd.DataFrame(data)
    df.to_csv(file_path, index=False)

if __name__ == "__main__":
    csv_file = "users_even.csv"
    generate_data(csv_file)
    
    exception_csv_file = "users_uneven.csv"
    generate_exception_data(exception_csv_file)
