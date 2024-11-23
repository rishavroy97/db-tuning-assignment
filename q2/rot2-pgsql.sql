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

COPY users(name, email, status)
    FROM '/home/rr4577/ads/db-tuning-assignment/q2/orders.csv'
    DELIMITER ','
    CSV HEADER;

CREATE INDEX customer_idx ON orders (customer_id);

-- non-clustered index
SELECT * FROM orders WHERE customer_id = 50;


-- clustered index
CLUSTER orders USING customer_idx;
SELECT * FROM orders WHERE customer_id = 50;