import pandas as pd
import random

NUM_ROWS = 1000000

def generate_data(file_path):
    data = {
        "name": [f"User{i}" for i in range(1, NUM_ROWS + 1)],
        "email": [f"user{i}@example.com" for i in range(1, NUM_ROWS + 1)],
        "status": random.choice(['active', 'inactive', 'pending'], k=NUM_ROWS)
    }
    
    df = pd.DataFrame(data)
    df.to_csv(file_path, index=False)

if __name__ == "__main__":
    csv_file_path = "users_uneven.csv"
    generate_data(csv_file_path)
