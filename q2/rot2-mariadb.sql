CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount NUMERIC(10, 2)
);

-- RULE OF THUMB:
-- Creating a clustered index on the column that is used in the where clause
-- improves performance when compared to a Non-clustered index
-- This is because all the records will probably be on the same page.

LOAD DATA INFILE '/home/rr4577/ads/db-tuning-assignment/q2/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(customer_id, order_date, order_amount);

CREATE INDEX customer_idx ON orders (customer_id);

-- non-clustered index (147.914 ms)
SET profiling = 1;
SELECT * FROM orders WHERE customer_id BETWEEN 20 AND 50;
SHOW PROFILES;

-- clustered index (66.661 ms)
DROP INDEX customer_idx ON orders;

ALTER TABLE orders DROP PRIMARY KEY;
ALTER TABLE orders ADD PRIMARY KEY (customer_id);

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
-- 2.827 ms
\timing on
\pset pager off
SELECT * FROM orders WHERE customer_id = 50;

-- clustered
\timing on
\pset pager off
CLUSTER orders USING customer_idx; -- 6313.804 ms
-- 3.779 ms
SELECT * FROM orders WHERE customer_id = 50;

-- Conclusion: Comparable results