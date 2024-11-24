CREATE TABLE IF NOT EXISTS trade(stocksymbol INT, time INT PRIMARY KEY, quantity INT, price INT);

COPY trade(stocksymbol, time, quantity, price)
FROM '/home/rr4577/ads/db-tuning-assignment/q1/trades.csv'
DELIMITER ','
CSV HEADER;

-- Time: 22104.535 ms (00:22.105)
CREATE INDEX ticker_time ON trade(stocksymbol, time);
-- Time: 112790.118 ms (01:52.790)
CLUSTER trade USING ticker_time;

-- Part A
-- Time: 4330.421 ms (00:04.330)
\timing on
\pset pager off
SELECT
    stocksymbol,
    SUM(quantity * price) / SUM(quantity) AS weighted_avg_price
FROM
    trade
GROUP BY
    stocksymbol;


-- Part B
-- Time: 33788.963 ms (00:33.789)
\timing on
\pset pager off
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


-- Part C
-- Time: 24460.666 ms (00:24.461)
\timing on
\pset pager off
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


-- Part D
-- Time: 15745.815 ms (00:15.746)
\timing on
\pset pager off
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