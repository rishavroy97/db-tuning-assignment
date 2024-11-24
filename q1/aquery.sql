-- PART 1

CREATE TABLE IF NOT EXISTS trade(stocksymbol INT, time INT, quantity INT, price INT);
exec;

stats on;

LOAD DATA INFILE "/home/rr4577/ads/db-tuning-assignment/q1/trades.csv" INTO TABLE trade FIELDS TERMINATED BY ",";
exec;

-- 2.7 seconds
SELECT stocksymbol, SUM(quantity * price) / SUM(quantity) AS weighted_avg_price FROM trade GROUP BY stocksymbol;
exec;


-- PART 2

-- Restart AQuery and reload Data

CREATE TABLE IF NOT EXISTS trade(stocksymbol INT, time INT, quantity INT, price INT);
exec;

stats on;

LOAD DATA INFILE "/home/rr4577/ads/db-tuning-assignment/q1/trades.csv" INTO TABLE trade FIELDS TERMINATED BY ",";
exec;

-- 114.7 seconds
SELECT stocksymbol, price, avgs(10, price) AS moving_avg_price FROM trade ASSUMING ASC stocksymbol, ASC time;
exec;



-- PART 3

-- Restart AQuery and reload Data

CREATE TABLE IF NOT EXISTS trade(stocksymbol INT, time INT, quantity INT, price INT);
exec;

stats on;

LOAD DATA INFILE "/home/rr4577/ads/db-tuning-assignment/q1/trades.csv" INTO TABLE trade FIELDS TERMINATED BY ",";
exec;

-- 108.9 seconds
SELECT stocksymbol, price, sums(10, price * quantity) / sums(10, quantity) AS weighted_moving_avg_price FROM trade ASSUMING ASC stocksymbol, ASC time;
exec;




-- PART 4

-- Restart AQuery and reload Data

CREATE TABLE IF NOT EXISTS trade(stocksymbol INT, time INT, quantity INT, price INT);
exec;

stats on;

LOAD DATA INFILE "/home/rr4577/ads/db-tuning-assignment/q1/trades.csv" INTO TABLE trade FIELDS TERMINATED BY ",";
exec;

-- 7.6 seconds
SELECT stocksymbol, max(price - mins(price)) AS max_profit FROM trade ASSUMING ASC stocksymbol, ASC time GROUP BY stocksymbol;
exec;