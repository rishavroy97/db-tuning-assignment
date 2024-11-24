CREATE TABLE orders (id INT, customer_id INT, order_date DATE, order_amount NUMERIC(10, 2));

-- RULE OF THUMB:
-- Creating a clustered index on the column that is used in the where clause
-- improves performance when compared to a Non-clustered index
-- This is because all the records will probably be on the same page.

LOAD DATA INFILE '/home/rr4577/ads/db-tuning-assignment/q2/orders-indexed.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(id, customer_id, order_date, order_amount);


-- non-clustered index
CREATE INDEX order_idx ON orders (id); -- 44.399 sec

-- 14.375 sec
SET profiling = 1;
SELECT * FROM orders where id BETWEEN 2000001 AND 3000000;
SHOW PROFILES;

-- clustered index
DROP INDEX order_idx ON orders;

ALTER TABLE orders ADD PRIMARY KEY (id); -- 1 min 6.074 sec

-- 3.045 sec
SET profiling = 1;
SELECT * FROM orders where id BETWEEN 2000001 AND 3000000;
SHOW PROFILES;

-- Conclusion: Clustered index performs a much faster search than non clustered index


-- Exception:
-- Non-clustered and clustered index might both give similar performance 
-- if the number of records in the multipoint query are very small 
-- (The multipoint query almost becomes a point query).

DELETE FROM orders;
ALTER TABLE orders DROP PRIMARY KEY;

LOAD DATA INFILE '/home/rr4577/ads/db-tuning-assignment/q2/orders-indexed.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(id, customer_id, order_date, order_amount);


-- non-clustered index
CREATE INDEX order_idx ON orders (id); -- 44.114 sec

-- 0.008 sec
SET profiling = 1;
SELECT * FROM orders where id BETWEEN 2000001 AND 2000100;
SHOW PROFILES;

-- clustered
DROP INDEX order_idx ON orders;

ALTER TABLE orders ADD PRIMARY KEY (id); -- 1 min 8.739 sec

-- 0.005 sec
SET profiling = 1;
SELECT * FROM orders where id BETWEEN 2000001 AND 2000100;
SHOW PROFILES;

-- Conclusion: Comparable results