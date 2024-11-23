CREATE TABLE orders (customer_id INT, order_date DATE, order_amount REAL);
exec;

stats on;

LOAD DATA INFILE "/home/rr4577/ads/db-tuning-assignment/q2/orders.csv" INTO TABLE orders FIELDS TERMINATED BY ",";
exec;

CREATE INDEX customer_idx ON orders (customer_id);
exec;

-- non-clustered index
-- 2.515 sec
SELECT * FROM orders WHERE customer_id >= 20 AND customer_id <= 50;
exec;

-- clustered index
CREATE TABLE clustered_orders AS SELECT * FROM orders ORDER BY customer_id;
exec; -- 1.469 sec

-- 2.5265 sec
SELECT * FROM clustered_orders WHERE customer_id >= 20 AND customer_id <= 50;

