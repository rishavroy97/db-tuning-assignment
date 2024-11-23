CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount NUMERIC(10, 2)
);

-- RULE OF THUMB:
-- Creating a clustered index on the column that is used in the where clause
-- improves performance when compared to a Non-clustered index
-- This is because all the records will probably be on the same page.

COPY orders(customer_id, order_date, order_amount)
    FROM '/home/rr4577/ads/db-tuning-assignment/q2/orders.csv'
    DELIMITER ','
    CSV HEADER;

CREATE INDEX customer_idx ON orders (customer_id);

-- non-clustered index (140.513 ms)
\timing on
\pset pager off
SELECT * FROM orders WHERE customer_id BETWEEN 20 AND 50;


-- clustered index (62.617 ms)
CLUSTER orders USING customer_idx;

\timing on
\pset pager off
SELECT * FROM orders WHERE customer_id BETWEEN 20 AND 50;

-- Conclusion: Doubles the throughput


-- Exception:
-- Non-clustered and clustered index might both give similar performance 
-- if the number of records in the multipoint query are very small 
-- (The multipoint query almost becomes a point query).

DROP INDEX customer_idx;
DELETE FROM orders;

COPY orders(customer_id, order_date, order_amount)
    FROM '/home/rr4577/ads/db-tuning-assignment/q2/orders_exception.csv'
    DELIMITER ','
    CSV HEADER;

CREATE INDEX customer_idx ON orders (customer_id);


-- non-clustered index (140.513 ms)
-- 1.025 ms
\timing on
\pset pager off
SELECT * FROM orders WHERE customer_id = 50;

-- clustered
\timing on
\pset pager off
CLUSTER orders USING customer_idx; -- 6436.156 ms
-- 3.393 ms
SELECT * FROM orders WHERE customer_id = 50;

-- Conclusion: Comparable results