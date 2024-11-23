CREATE TABLE IF NOT EXISTS trade(stocksymbol INT, time INT PRIMARY KEY, quantity INT, price INT);
exec;

stats on;
exec;

LOAD DATA INFILE "./data/trades.csv" INTO TABLE trade FIELDS TERMINATED BY ",";
exec;

-- 1.02 seconds
SELECT stocksymbol, SUM(quantity * price) / SUM(quantity) AS weighted_avg_price FROM trade GROUP BY stocksymbol;
exec;

-- 85 seconds
SELECT stocksymbol, price, avgs(10, price) AS moving_avg_price FROM trade ASSUMING ASC stocksymbol, ASC time;
exec;

-- 85.83 seconds
SELECT stocksymbol, price, sums(10, price * quantity) / sums(10, quantity) AS weighted_moving_avg_price FROM trade ASSUMING ASC stocksymbol, ASC time;
exec;

-- 4.3 seconds
SELECT stocksymbol, max(price - mins(price)) AS max_profit FROM trade ASSUMING ASC stocksymbol, ASC time GROUP BY stocksymbol;
exec;