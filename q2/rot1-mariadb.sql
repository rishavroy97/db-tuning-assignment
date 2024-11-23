CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    status ENUM('active', 'inactive', 'pending'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RULE OF THUMB:
-- if you have very few distinct values in a column of a big table, 
-- then, creating a non-clustered index to that column is not-efective.
-- (Gives similar performance as scanning without any index)

-- success
-- without index (2.254 sec)
SET profiling = 1;
SELECT * FROM users WHERE status = 'inactive';
SHOW PROFILES;

-- with index (2.224 sec)
CREATE INDEX idx_status ON users(status);
SET profiling = 1;
SELECT * FROM users WHERE status = 'inactive';
SHOW PROFILES;

-- Conclusion: Comparable speeds

-- Exception to this rule:
-- If the column with few distinct values (low cardinality column) has an uneven distribution
-- where one of the values is very rare and query searches for this rare value
-- In that case, it helps to have a non-clustered index

-- failure
-- without index (0.624 sec)
SET profiling = 1;
SELECT * FROM users WHERE status = 'inactive';
SHOW PROFILES;

-- with index (0.013 sec)
CREATE INDEX idx_status ON users(status);
SET profiling = 1;
SELECT * FROM users WHERE status = 'inactive';
SHOW PROFILES;

-- Conclusion: Non-clustered index is faster