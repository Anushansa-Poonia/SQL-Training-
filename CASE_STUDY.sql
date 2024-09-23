-- Database
CREATE DATABASE Finance;
USE Finance;

-- Table 1: Users
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment user_id
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT chk_email CHECK (email LIKE '%_@_%._%')  -- Basic email format check
);

-- Table 2: ExpenseCategories
CREATE TABLE ExpenseCategories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment category_id
    category_name VARCHAR(50) NOT NULL UNIQUE    -- Unique names 
);

-- Table 3: Expenses
CREATE TABLE Expenses (
    expense_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment expense_id
    user_id INT,                                 -- Foreign key for Users table
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),  -- Positive expense amount
    category_id INT,                             -- Foreign key for ExpenseCategories
    date DATE NOT NULL,                         
    description VARCHAR(255),                   
    FOREIGN KEY (user_id) REFERENCES Users(user_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,  -- Cascade on both delete and update for Users table
    FOREIGN KEY (category_id) REFERENCES ExpenseCategories(category_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE   -- Cascade on update and set to NULL on delete for categories
);

-- Inserting values into Users table (no need to provide user_id explicitly)
INSERT INTO Users (username, password, email) VALUES
('rahul_mehta', 'password123', 'rahul@example.com'),
('ananya_patel', 'securePass456', 'ananya@example.com'),
('vikas_singh', 'pass789', 'vikas@example.com'),
('deepika_joshi', 'mypassword', 'deepika@example.com'),
('sameer_verma', '1234abc', 'sameer@example.com'),
('isha_sharma', 'secretpass', 'isha@example.com');

-- View data from Users table
SELECT * FROM Users;

-- Inserting values into ExpenseCategories table (no need to provide category_id explicitly)
INSERT INTO ExpenseCategories (category_name) VALUES
('Food'),
('Transportation'),
('Utilities'),
('Entertainment'),
('Health'),
('Travel');

-- View data from ExpenseCategories table
SELECT * FROM ExpenseCategories;

-- Inserting values into Expenses table
INSERT INTO Expenses (user_id, amount, category_id, date, description) VALUES
(1, 200.00, 1, '2024-09-01', 'Groceries'),
(1, 50.00, 2, '2024-09-03', 'Auto rickshaw fare'),
(2, 500.00, 4, '2024-09-05', 'Movie tickets'),
(3, 300.00, 3, '2024-09-06', 'Electricity bill'),
(4, 1500.00, 5, '2024-09-08', 'Health checkup'),
(5, 800.00, 6, '2024-09-10', 'Train tickets to Delhi');

-- View data from Expenses table
SELECT * FROM Expenses;

--cascade working
--checking integrity
--delete user row
DELETE FROM Users
WHERE user_id = 1;

SELECT * FROM Expenses;