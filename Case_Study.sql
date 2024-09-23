--database 
CREATE DATABASE FinanceManagementDB;
USE FinanceManagementDB;
--table 1
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),  -- Start at 1, increment by 1
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT chk_email CHECK (email LIKE '%_@_%._%')  -- Basic email format check
);
--table 2
CREATE TABLE ExpenseCategories (
    category_id INT PRIMARY KEY IDENTITY(1,1),  -- Auto-incrementing & primary key
    category_name VARCHAR(50) NOT NULL UNIQUE    -- Unique names 
);
--table 3
CREATE TABLE Expenses (
    expense_id INT PRIMARY KEY IDENTITY(1,1),   -- Auto-incrementing & primary key
    user_id INT,                                 -- Foreign key for Users table
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),  -- Positive expense amount
    category_id INT,                             -- Foreign key for ExpenseCategories
    date DATE NOT NULL,                         
    description VARCHAR(255),                   
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,  
    FOREIGN KEY (category_id) REFERENCES ExpenseCategories(category_id) ON DELETE SET NULL  
);
--inserting values in table 1
INSERT INTO Users (username, password, email) VALUES
('rahul_mehta', 'password123', 'rahul@example.com'),
('ananya_patel', 'securePass456', 'ananya@example.com'),
('vikas_singh', 'pass789', 'vikas@example.com'),
('deepika_joshi', 'mypassword', 'deepika@example.com'),
('sameer_verma', '1234abc', 'sameer@example.com'),
('isha_sharma', 'secretpass', 'isha@example.com');

SELECT * FROM Users;

--inserting values in table 2
INSERT INTO ExpenseCategories (category_name) VALUES
('Food'),
('Transportation'),
('Utilities'),
('Entertainment'),
('Health'),
('Travel');

SELECT * FROM ExpenseCategories;

--inserting values in table 3
INSERT INTO Expenses (user_id, amount, category_id, date, description) VALUES
(1, 200.00, 1, '2024-09-01', 'Groceries'),
(1, 50.00, 2, '2024-09-03', 'Auto rickshaw fare'),
(2, 500.00, 4, '2024-09-05', 'Movie tickets'),
(3, 300.00, 3, '2024-09-06', 'Electricity bill'),
(4, 1500.00, 5, '2024-09-08', 'Health checkup'),
(5, 800.00, 6, '2024-09-10', 'Train tickets to Delhi');

SELECT * FROM Expenses;