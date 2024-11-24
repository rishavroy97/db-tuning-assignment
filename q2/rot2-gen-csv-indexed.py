import pandas as pd
import random
from datetime import datetime, timedelta

NUM_ROWS = 10_000_000

def generate_indexed_data(csv_file):
    data = {
        "customer_id": [random.randint(1, 500) for _ in range(NUM_ROWS)],
        "order_date": [(datetime.today() - timedelta(days=random.randint(0, 3650))) for _ in range(NUM_ROWS)],
        "order_amount": [round(random.uniform(10, 1000), 2) for _ in range(NUM_ROWS)]
    }
        
    df = pd.DataFrame(data)
    df.to_csv(csv_file, index_label="id")

if __name__ == '__main__':
    csv_file_path = "orders-indexed.csv"
    generate_indexed_data(csv_file_path)