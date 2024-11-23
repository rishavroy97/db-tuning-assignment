CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    status ENUM('active', 'inactive', 'pending'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- success

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
