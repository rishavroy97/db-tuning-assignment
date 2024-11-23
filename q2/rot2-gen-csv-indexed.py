import pandas as pd

df = pd.read_csv("orders.csv")
df.to_csv("orders-indexed.csv", index_label="id")