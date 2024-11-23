CREATE TABLE IF NOT EXISTS trade(stocksymbol INT, time INT PRIMARY KEY, quantity INT, price INT);

LOAD DATA INFILE "/home/rr4577/ads/db-tuning-assignment/q1/trades.csv"
INTO TABLE trade
FIELDS TERMINATED BY ","
IGNORE 1 LINES;

-- 45.937 secs
CREATE INDEX ticker ON trade(stocksymbol);

-- Part A
-- 24.234 secs
SET profiling = 1;
SELECT
    stocksymbol,
    SUM(quantity * price) / SUM(quantity) AS weighted_avg_price
FROM
    trade
GROUP BY
    stocksymbol;
SHOW PROFILES;


-- Part B
-- 2 mins 36 secs
SET profiling = 1;
SELECT
    stocksymbol,
    time,
    ROUND(
        AVG(price) OVER (
            PARTITION BY stocksymbol
            ORDER BY time
            ROWS BETWEEN 9 PRECEDING AND CURRENT ROW
        ), 2
    ) AS moving_avg_price
FROM
    trade
ORDER BY
    stocksymbol, time;
SHOW PROFILES;


-- Part C
-- 4 min 32 secs
SET profiling = 1;
WITH weighted_sums AS (
    SELECT
        stocksymbol,
        time,
        SUM(quantity * price) OVER (
            PARTITION BY stocksymbol
            ORDER BY time
            ROWS BETWEEN 9 PRECEDING AND CURRENT ROW
        ) AS weighted_sum_price,
        SUM(quantity) OVER (
            PARTITION BY stocksymbol
            ORDER BY time
            ROWS BETWEEN 9 PRECEDING AND CURRENT ROW
        ) AS sum_quantity
    FROM
        trade
)
SELECT
    stocksymbol,
    time,
    weighted_sum_price / NULLIF(sum_quantity, 0) AS weighted_moving_avg_price
FROM
    weighted_sums
ORDER BY
    stocksymbol, time;
SHOW PROFILES;


-- Part D
-- 5 mins 45 secs
SET profiling = 1;
WITH min_price_before AS (
    SELECT
        stocksymbol,
        time,
        price,
        MIN(price) OVER (
            PARTITION BY stocksymbol
            ORDER BY time
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS min_price_up_to
    FROM
        trade
),
best_trade AS (
    SELECT
        stocksymbol,
        MAX(price - min_price_up_to) AS max_profit
    FROM
        min_price_before
    WHERE
        min_price_up_to IS NOT NULL
    GROUP BY
        stocksymbol
)
SELECT
    stocksymbol,
    max_profit
FROM
    best_trade;
SHOW PROFILES;