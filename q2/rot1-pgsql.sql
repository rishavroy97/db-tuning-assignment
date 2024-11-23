CREATE TYPE USER_STATUS AS ENUM ('active', 'inactive', 'pending');

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    status USER_STATUS,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);