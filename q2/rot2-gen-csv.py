import pandas as pd
import random
from datetime import datetime, timedelta

NUM_ROWS = 1000000

def generate_data(file_path):
    data = {
        "customer_id": [random.randint(1, 500) for _ in range(NUM_ROWS)],
        "order_date": [(datetime.today() - timedelta(days=random.randint(0, 3650))) for _ in range(NUM_ROWS)],
        "order_amount": [round(random.uniform(10, 1000), 2) for _ in range(NUM_ROWS)]
    }
    
    df = pd.DataFrame(data)
    df.to_csv(file_path, index=False)

def generate_exception_data(file_path):
    data = {
        "customer_id": [random.randint(1, 100000) for _ in range(NUM_ROWS)],
        "order_date": [(datetime.today() - timedelta(days=random.randint(0, 3650))) for _ in range(NUM_ROWS)],
        "order_amount": [round(random.uniform(10, 1000), 2) for _ in range(NUM_ROWS)]
    }
    
    df = pd.DataFrame(data)
    df.to_csv(file_path, index=False)

if __name__ == "__main__":
    csv_file = "orders.csv"
    generate_data(csv_file)
    
    exception_csv_file = "orders_exception.csv"
    generate_exception_data(exception_csv_file)
