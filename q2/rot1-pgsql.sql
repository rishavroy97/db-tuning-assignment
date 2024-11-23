CREATE TYPE USER_STATUS AS ENUM ('active', 'inactive', 'pending');

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    status USER_STATUS,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RULE OF THUMB:
-- if you have very few distinct values in a column of a big table, 
-- then, creating a non-clustered index to that column is not-efective.
-- (Gives similar performance as scanning without any index)

COPY users(name, email, status)
    FROM '/home/rr4577/ads/db-tuning-assignment/q2/users_even.csv'
    DELIMITER ','
    CSV HEADER;

-- success
-- without index (522.729 ms)
\timing on
\pset pager off
SELECT * FROM users WHERE status = 'inactive';

-- with index (596.234 ms)
\timing on
\pset pager off
CREATE INDEX idx_status ON users(status);
SELECT * FROM users WHERE status = 'inactive';

-- Conclusion: Comparable speeds


-- Exception to this rule:
-- If the column with few distinct values (low cardinality column) has an uneven distribution
-- where one of the values is very rare and query searches for this rare value
-- In that case, it helps to have a non-clustered index

DELETE FROM users;

COPY users(name, email, status)
    FROM '/home/rr4577/ads/db-tuning-assignment/q2/users_uneven.csv'
    DELIMITER ','
    CSV HEADER;

-- without index (91.725 ms)
\timing on
\pset pager off
SELECT * FROM users WHERE status = 'inactive';


-- with index (19.000 ms)
\timing on
\pset pager off
CREATE INDEX idx_status ON users(status);
SELECT * FROM users WHERE status = 'inactive';

-- Conclusion: Non-clustered index is faster