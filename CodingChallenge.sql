---------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------Formation of tables---------------------------------------------------------------------------
--Create a databse
CREATE DATABASE eCommerceDB;
USE eCommerceDB;

-- Create the customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    address VARCHAR(255)
);

-- Create the products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2),
    stock_quantity INT
);

-- Create the orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create the order_items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    item_amount DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Create the cart table
CREATE TABLE cart (
    cart_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

--Inserting values in customer table 
INSERT INTO customers (customer_id, first_name, last_name, email, address) VALUES
(1, 'John', 'Doe', 'johndoe@example.com', '123 Main St, City'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '456 Elm St, Town'),
(3, 'Robert', 'Johnson', 'robert@example.com', '789 Oak St, Village'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '101 Pine St, Suburb'),
(5, 'David', 'Lee', 'david@example.com', '234 Cedar St, District'),
(6, 'Laura', 'Hall', 'laura@example.com', '567 Birch St, County'),
(7, 'Michael', 'Davis', 'michael@example.com', '890 Maple St, State'),
(8, 'Emma', 'Wilson', 'emma@example.com', '321 Redwood St, Country'),
(9, 'William', 'Taylor', 'william@example.com', '432 Spruce St, Province'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '765 Fir St, Territory');

SELECT * FROM customers;

--Inserting values in product tables 
INSERT INTO products (product_id, name, description, price, stock_quantity) VALUES
(1, 'Laptop', 'High-performance laptop', 800.00, 10),
(2, 'Smartphone', 'Latest smartphone', 600.00, 15),
(3, 'Tablet', 'Portable tablet', 300.00, 20),
(4, 'Headphones', 'Noise-canceling', 150.00, 30),
(5, 'TV', '4K Smart TV', 900.00, 5),
(6, 'Coffee Maker', 'Automatic coffee maker', 50.00, 25),
(7, 'Refrigerator', 'Energy-efficient', 700.00, 10),
(8, 'Microwave Oven', 'Countertop microwave', 80.00, 15),
(9, 'Blender', 'High-speed blender', 70.00, 20),
(10, 'Vacuum Cleaner', 'Bagless vacuum cleaner', 120.00, 10);

SELECT * FROM products;

--Inserting values in order table;
INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2023-01-05', 1200.00),
(2, 2, '2023-02-10', 900.00),
(3, 3, '2023-03-15', 300.00),
(4, 4, '2023-04-20', 150.00),
(5, 5, '2023-05-25', 1800.00),
(6, 6, '2023-06-30', 400.00),
(7, 7, '2023-07-05', 700.00),
(8, 8, '2023-08-10', 160.00),
(9, 9, '2023-09-15', 140.00),
(10, 10, '2023-10-20', 1400.00);

SELECT * FROM orders;

--Inserting values in order items 
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, item_amount) VALUES
(1, 1, 1, 2, 1600.00),
(2, 1, 3, 1, 300.00),
(3, 2, 2, 3, 1800.00),
(4, 3, 5, 2, 1800.00),
(5, 4, 4, 4, 600.00),
(6, 4, 6, 1, 50.00),
(7, 5, 1, 1, 800.00),
(8, 5, 2, 2, 1200.00),
(9, 6, 10, 2, 240.00),
(10, 6, 9, 3, 210.00);

SELECT * FROM order_items;

--Inserting values in cart 
INSERT INTO cart (cart_id, customer_id, product_id, quantity) VALUES
(1, 1, 1, 2),
(2, 1, 3, 1),
(3, 2, 2, 3),
(4, 3, 4, 4),
(5, 3, 5, 2),
(6, 4, 6, 1),
(7, 5, 1, 1),
(8, 6, 10, 2),
(9, 6, 9, 3),
(10, 7, 7, 2);

SELECT * FROM cart;
---------------------------------------------------------------------Queries-------------------------------------------------------------------------
--1. Update refrigerator product price to 800.
UPDATE products
SET price = 800.00
WHERE name = 'Refrigerator';

--Showing the updated output 
SELECT * FROM products;

---------------------------------------------------------------------------------------------------------------------------------------------------
--2. Remove all cart items for a specific customer (e.g., customer_id = 1).
DELETE FROM cart
WHERE customer_id = 1;

--Showing the updated output 
SELECT *
FROM cart
WHERE customer_id = 1;

---------------------------------------------------------------------------------------------------------------------------------------------------
--3. Retrieve Products Priced Below $100.
SELECT * FROM products
WHERE price < 100;

---------------------------------------------------------------------------------------------------------------------------------------------------
--4. Find Products with Stock Quantity Greater Than 5.
SELECT * FROM products
WHERE stock_quantity > 5;

---------------------------------------------------------------------------------------------------------------------------------------------------
--5. Retrieve Orders with Total Amount Between $500 and $1000.
SELECT * FROM orders
WHERE total_amount BETWEEN 500 AND 1000;

---------------------------------------------------------------------------------------------------------------------------------------------------
--6. Find Products which name end with letter ‘r’.
SELECT * FROM products
WHERE name LIKE '%r';

---------------------------------------------------------------------------------------------------------------------------------------------------
--7. Retrieve Cart Items for Customer 5.
SELECT * FROM cart
WHERE customer_id = 5;

---------------------------------------------------------------------------------------------------------------------------------------------------
--8. Find Customers Who Placed Orders in 2023.
SELECT DISTINCT c.*
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE YEAR(o.order_date) = 2023;

---------------------------------------------------------------------------------------------------------------------------------------------------
--9. Determine the Minimum Stock Quantity for Each Product Category.
SELECT name, MIN(stock_quantity) AS min_stock
FROM products
GROUP BY name;

---------------------------------------------------------------------------------------------------------------------------------------------------
--10. Calculate the Total Amount Spent by Each Customer.
SELECT c.customer_id, c.first_name, c.last_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

---------------------------------------------------------------------------------------------------------------------------------------------------
--11. Find the Average Order Amount for Each Customer.
SELECT c.customer_id, c.first_name, c.last_name, AVG(o.total_amount) AS average_order_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

---------------------------------------------------------------------------------------------------------------------------------------------------
--12. Count the Number of Orders Placed by Each Customer.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

---------------------------------------------------------------------------------------------------------------------------------------------------
--13. Find the Maximum Order Amount for Each Customer.
SELECT 
    customer_id,
    MAX(total_amount) AS max_order_amount
FROM 
    orders
GROUP BY 
    customer_id;

---------------------------------------------------------------------------------------------------------------------------------------------------
--14. Get Customers Who Placed Orders Totaling Over $1000
-- Get customers who placed orders totaling over $1000
SELECT DISTINCT
    c.customer_id,
    c.first_Name,
    c.last_Name
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.first_Name, c.last_Name
HAVING 
    SUM(o.total_amount) > 1000;

---------------------------------------------------------------------------------------------------------------------------------------------------
--15. Subquery to Find Products Not in the Cart
SELECT *
FROM products
WHERE product_id NOT IN (
    SELECT product_id 
    FROM cart
);

---------------------------------------------------------------------------------------------------------------------------------------------------
--16. Subquery to Find Customers Who Haven't Placed Orders

-- Insert additional customers who have not placed any orders
INSERT INTO customers (customer_id, first_Name, last_Name, email, address) VALUES
(11, 'Alice', 'Green', 'alice@example.com', '123 Willow St, Town'),
(12, 'Bob', 'White', 'bob@example.com', '456 Maple St, City'),
(13, 'Charlie', 'Black', 'charlie@example.com', '789 Pine St, Village');

--now displaying Customers Who Haven't Placed Orders
SELECT *
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id 
    FROM orders
);
---------------------------------------------------------------------------------------------------------------------------------------------------
--17. Subquery to Calculate the Percentage of Total Revenue for a Product
SELECT 
    p.product_id,
    p.name,
    (SUM(oi.quantity * p.price) / (SELECT SUM(o.total_amount) FROM orders o)) * 100 AS revenue_percentage
FROM 
    products p
JOIN 
    order_items oi ON p.product_id = oi.product_id
GROUP BY 
    p.product_id, p.name;
---------------------------------------------------------------------------------------------------------------------------------------------------
--18. Subquery to Find Products with Low Stock
-- Taking stock threshold less than 15
SELECT *
FROM products
WHERE stock_quantity < 15;

---------------------------------------------------------------------------------------------------------------------------------------------------
--19. Subquery to Find Customers Who Placed High-Value Orders
-- Find customers who placed orders with total amounts over $500
SELECT DISTINCT
    c.customer_id,
    c.first_Name,
    c.last_Name
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
WHERE 
    o.total_amount > 500;
---------------------------------------------------------------------------------------------------------------------------------------------------

--cascading 
-- Alter the orders table to add cascading on delete for customer_id
ALTER TABLE orders
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Alter the order_items table to add cascading on delete for order_id and product_id
ALTER TABLE order_items
ADD CONSTRAINT FK_OrderItems_Orders
FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE order_items
ADD CONSTRAINT FK_OrderItems_Products
FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Alter the cart table to add cascading on delete for customer_id and product_id
ALTER TABLE cart
ADD CONSTRAINT FK_Cart_Customers
FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE cart
ADD CONSTRAINT FK_Cart_Products
FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE ON UPDATE CASCADE;


---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------