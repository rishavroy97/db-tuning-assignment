import fractal
import random
import pandas as pd

NUM_TRADES = 10_000_000
QUANTITY_MIN = 100
QUANTITY_MAX = 10_000
PRICE_MIN = 50
PRICE_MAX = 500
PRICE_VARIATION_MIN = 1
PRICE_VARIATION_MAX = 5

def get_next_price(curr_price: int) -> int:
    variation = int(random.uniform(PRICE_VARIATION_MIN, PRICE_VARIATION_MAX))
    new_price = curr_price + random.choice([-variation, variation])
    return max(PRICE_MIN, min(PRICE_MAX, new_price))

def generate_trade_data():
    stock_symbols = fractal.gen()

    stock_prices = {symbol: int(random.uniform(PRICE_MIN, PRICE_MAX)) for symbol in set(stock_symbols)}

    trades = []
    # Table trade(stocksymbol, time, quantity, price)
    for i in range(1, NUM_TRADES + 1):    
        stock_symbol = random.choice(stock_symbols)
        time = i
        quantity = random.randint(QUANTITY_MIN, QUANTITY_MAX)
        price = stock_prices[stock_symbol]
        
        trades.append((stock_symbol, time, quantity, price))
        
        # update stock_prices
        next_price = get_next_price(price)
        stock_prices[stock_symbol] = next_price
        
    return pd.DataFrame(trades, columns=["stocksymbol", "time", "quantity", "price"])
    
        
if __name__ == "__main__":
    df = generate_trade_data()
    df.to_csv("trades.csv", index=False)