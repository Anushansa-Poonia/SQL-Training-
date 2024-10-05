-- Database
CREATE DATABASE OrderManagementSystem;
USE OrderManagementSystem;

CREATE TABLE Users (
    userId INT PRIMARY KEY IDENTITY(1,1), --primary key
    username VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL, 
    role VARCHAR(10) NOT NULL 
);

CREATE TABLE Products (
    productId INT PRIMARY KEY IDENTITY(1,1), --primary key
    productName VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(10, 2) NOT NULL, -- Price with two decimal places
    quantityInStock INT NOT NULL,
    type VARCHAR(20) NOT NULL, -- Can be 'Electronics' or 'Clothing'
    brand VARCHAR(100) NULL, -- Electronics-specific field, can be NULL
    warrantyPeriod INT NULL, -- Electronics-specific field, can be NULL
    size VARCHAR(10) NULL, -- Clothing-specific field, can be NULL
    color VARCHAR(20) NULL -- Clothing-specific field, can be NULL
);

CREATE TABLE Orders (
    orderId INT PRIMARY KEY IDENTITY(1,1), --primary key
    userId INT NOT NULL, -- Foreign key from Users table
    orderDate DATETIME NOT NULL DEFAULT GETDATE(), -- Default to the current date and time
    FOREIGN KEY (userId) REFERENCES Users(userId) -- Establishing relationship with Users table
);

CREATE TABLE OrderDetails (
    orderDetailId INT PRIMARY KEY IDENTITY(1,1), -- Auto-incremented primary key
    orderId INT NOT NULL, -- Foreign key from Orders table
    productId INT NOT NULL, -- Foreign key from Products table
    quantity INT NOT NULL,
    priceAtOrder DECIMAL(10, 2) NOT NULL, -- The price of the product at the time of ordering
    FOREIGN KEY (orderId) REFERENCES Orders(orderId), -- Establishing relationship with Orders table
    FOREIGN KEY (productId) REFERENCES Products(productId) -- Establishing relationship with Products table
);

-- Sample Users
INSERT INTO Users (username, password, role)
VALUES ('admin', 'admin123', 'Admin'),
       ('john_doe', 'password123', 'User'),
       ('jane_smith', 'mypassword', 'User');

-- Sample Electronics Products
INSERT INTO Products (productName, description, price, quantityInStock, type, brand, warrantyPeriod)
VALUES 
    ('Smartphone', 'Latest model smartphone', 699.99, 50, 'Electronics', 'TechBrand', 24),
    ('Laptop', 'Gaming laptop with high specs', 1299.99, 30, 'Electronics', 'GamerTech', 36);

-- Sample Clothing Products
INSERT INTO Products (productName, description, price, quantityInStock, type, size, color)
VALUES 
    ('T-shirt', 'Comfortable cotton t-shirt', 19.99, 100, 'Clothing', 'M', 'Blue'),
    ('Jeans', 'Stylish denim jeans', 49.99, 75, 'Clothing', 'L', 'Black');

-- Sample Orders
INSERT INTO Orders (userId)
VALUES (2), (3); -- For users 'john_doe' and 'jane_smith'

-- Sample Order Details for john_doe
INSERT INTO OrderDetails (orderId, productId, quantity, priceAtOrder)
VALUES 
    (1, 1, 2, 699.99), -- 2 Smartphones for orderId 1
    (1, 3, 3, 19.99); -- 3 T-shirts for orderId 1

-- Sample Order Details for jane_smith
INSERT INTO OrderDetails (orderId, productId, quantity, priceAtOrder)
VALUES 
    (2, 2, 1, 1299.99), -- 1 Laptop for orderId 2
    (2, 4, 2, 49.99); -- 2 Jeans for orderId 2

-- SELECT statements for verification
SELECT * FROM Users;
SELECT * FROM Products;
SELECT * FROM Orders WHERE userId = 2; -- Assuming john_doe has userId = 2
SELECT * FROM OrderDetails;

SELECT od.orderDetailId, p.productName, od.quantity, od.priceAtOrder
FROM OrderDetails od
JOIN Products p ON od.productId = p.productId
WHERE od.orderId = 1; -- For orderId = 1
