----------------------------------------------------------------- Task-1--------------------------------------------------------------------------
-- 1. Create the database named "TicketBookingSystem" 
CREATE DATABASE TicketBookingSystem;
USE TicketBookingSystem;

-- Write SQL scripts to create the mentioned tables with appropriate data types, constraints, and 
-- relationships
-- 1. Venue
-- 2. Event
-- 3. Customers
-- 4. Booking 

-- Create Venue Table
CREATE TABLE Venue (
    venue_id INT PRIMARY KEY, 
    venue_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL
)

-- Create Event Table
CREATE TABLE Event (
    event_id INT PRIMARY KEY, 
    event_name NVARCHAR(100) NOT NULL,
    event_date DATE NOT NULL,
    event_time TIME NOT NULL,
    venue_id INT NOT NULL, 
    total_seats INT NOT NULL CHECK (total_seats > 0),
    available_seats INT NOT NULL CHECK (available_seats >= 0),
    ticket_price DECIMAL(10, 2) NOT NULL CHECK (ticket_price >= 0),
    event_type NVARCHAR(50) CHECK (event_type IN ('Movie', 'Sports', 'Concert')),
    booking_id INT NULL 
)

-- Create Customer Table
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(255) NOT NULL UNIQUE,
    phone_number NVARCHAR(15) NOT NULL,
    booking_id INT NULL, 
    CONSTRAINT CHK_PhoneFormat CHECK (phone_number LIKE '[0-9]%')
)

-- Create Booking Table without foreign key initially
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY, 
    customer_id INT NOT NULL,
    event_id INT NOT NULL,
    num_tickets INT NOT NULL CHECK (num_tickets > 0),
    total_cost DECIMAL(10, 2) NOT NULL CHECK (total_cost >= 0),
    booking_date DATETIME DEFAULT GETDATE()
)
-- 3. Create an ERD (Entity Relationship Diagram) for the database.  

-- 4. Create appropriate Primary Key and Foreign Key constraints for referential integrity.  

-- Venue Foreign Key in Event
ALTER TABLE Event 
ADD CONSTRAINT FK_Event_Venue FOREIGN KEY (venue_id) 
REFERENCES Venue(venue_id)
ON DELETE CASCADE
ON UPDATE CASCADE

-- Customer Foreign Key in Booking
ALTER TABLE Booking 
ADD CONSTRAINT FK_Booking_Customer FOREIGN KEY (customer_id)
REFERENCES Customer(customer_id)
ON DELETE CASCADE
ON UPDATE CASCADE

-- Event Foreign Key in Booking
ALTER TABLE Booking 
ADD CONSTRAINT FK_Booking_Event FOREIGN KEY (event_id)
REFERENCES Event(event_id)
ON DELETE CASCADE
ON UPDATE CASCADE

-- Booking Foreign Key in Event and Customer
ALTER TABLE Customer 
ADD CONSTRAINT FK_Customer_Booking FOREIGN KEY (booking_id) 
REFERENCES Booking(booking_id)

ALTER TABLE Event 
ADD CONSTRAINT FK_Event_Booking FOREIGN KEY (booking_id) 
REFERENCES Booking(booking_id)

-- Tasks 2 
--1. Write a SQL query to insert at least 10 sample records into each table.
-- Insert into Venue table

-- Inserting values into Venue Table
INSERT INTO Venue (venue_id, venue_name, address) VALUES
(1, 'Vijay Talkies', 'Mumbai, Maharashtra'),
(2, 'Indira Gandhi Stadium', 'New Delhi'),
(3, 'Ravindra Natya Mandir', 'Mumbai, Maharashtra'),
(4, 'Pragati Maidan', 'New Delhi'),
(5, 'Chennai Trade Centre', 'Chennai, Tamil Nadu'),
(6, 'Bengaluru Palace', 'Bengaluru, Karnataka'),
(7, 'Jawaharlal Nehru Stadium', 'Kolkata, West Bengal'),
(8, 'Tata Theatre', 'Mumbai, Maharashtra'),
(9, 'Sardar Patel Stadium', 'Ahmedabad, Gujarat'),
(10, 'Mahatma Mandir', 'Gandhinagar, Gujarat');

--query 1
SELECT * FROM Venue;

-- Inserting values into Event Table
INSERT INTO Event (event_id, event_name, event_date, event_time, venue_id, total_seats, available_seats, ticket_price, event_type) VALUES
(1, 'Dilwale Dulhania Le Jayenge', '2024-10-01', '19:00:00', 1, 200, 150, 500.00, 'Movie'),
(2, 'Indian Premier League', '2024-04-15', '20:00:00', 2, 50000, 30000, 1500.00, 'Sports'),
(3, 'Brahmastra Concert', '2024-11-05', '18:00:00', 3, 1000, 500, 1000.00, 'Concert'),
(4, 'A.R. Rahman Live', '2024-12-10', '20:00:00', 4, 2000, 800, 2000.00, 'Concert'),
(5, 'Kabaddi World Cup', '2024-05-20', '19:30:00', 5, 30000, 25000, 800.00, 'Sports'),
(6, 'Sholay - The Musical', '2024-09-30', '17:00:00', 6, 1500, 700, 1200.00, 'Movie'),
(7, 'Bengaluru Food Festival', '2024-10-12', '11:00:00', 7, 1000, 600, 250.00, 'Concert'),
(8, 'Mumbai Marathon', '2024-01-21', '07:00:00', 8, 10000, 9000, 500.00, 'Sports'),
(9, 'Navratri Garba Night', '2024-10-14', '20:00:00', 9, 500, 200, 600.00, 'Concert'),
(10, 'The Great Indian Comedy Show', '2024-11-30', '19:30:00', 10, 300, 100, 400.00, 'Movie');

SELECT * FROM Event;

-- Inserting values into Customer Table (no booking_id column)
INSERT INTO Customer (customer_id, customer_name, email, phone_number) VALUES
(1, 'Rajesh Sharma', 'rajesh.sharma@example.com', '9876543210'),
(2, 'Anita Desai', 'anita.desai@example.com', '8765432109'),
(3, 'Karan Singh', 'karan.singh@example.com', '7654321098'),
(4, 'Priya Gupta', 'priya.gupta@example.com', '6543210987'),
(5, 'Amit Verma', 'amit.verma@example.com', '5432109876'),
(6, 'Nisha Mehta', 'nisha.mehta@example.com', '4321098765'),
(7, 'Rohit Patel', 'rohit.patel@example.com', '3210987654'),
(8, 'Sonia Rao', 'sonia.rao@example.com', '2109876543'),
(9, 'Vijay Reddy', 'vijay.reddy@example.com', '1098765432'),
(10, 'Simran Kaur', 'simran.kaur@example.com', '0987654321');

SELECT * FROM Customer;

-- Inserting values into Booking Table
INSERT INTO Booking (booking_id, customer_id, event_id, num_tickets, total_cost, booking_date) VALUES
(1, 1, 1, 2, 1000.00, '2024-09-15'),
(2, 2, 2, 4, 6000.00, '2024-04-01'),
(3, 3, 3, 1, 1000.00, '2024-11-01'),
(4, 4, 4, 3, 6000.00, '2024-12-01'),
(5, 5, 5, 5, 4000.00, '2024-05-10'),
(6, 6, 6, 1, 1200.00, '2024-09-28'),
(7, 7, 7, 4, 1000.00, '2024-10-01'),
(8, 8, 8, 2, 1000.00, '2024-01-15'),
(9, 9, 9, 3, 1800.00, '2024-10-10'),
(10, 10, 10, 1, 400.00, '2024-11-25');

SELECT * FROM Booking;

-- putting booking_id from booking table into Customer and event table
SELECT booking_id
FROM Booking
UPDATE Event
SET booking_id = b.booking_id
FROM Event e
JOIN Booking b ON e.event_id = b.event_id

UPDATE Customer
SET booking_id = b.booking_id
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id

-- Queries to see data in all tabels 
SELECT * FROM Venue
SELECT * FROM Event
SELECT * From Customer
SELECT * FROM Booking
-------------------------------------------------------------TASK-2-------------------------------------------------------------------------------
--query-2
-- 2. Write a SQL query to list all Events. 
SELECT * FROM Event;

--query 3
-- 3. Write a SQL query to select events with available tickets. 
SELECT * FROM Event
WHERE available_seats > 0;

--query 4
--4 Select Events with Name Partial Match 'cup'
SELECT * FROM Event
WHERE event_name LIKE '%cup%';

--query 5
--5. Write a SQL query to select events with ticket price range is between 1000 to 2500. 
SELECT * FROM Event
WHERE ticket_price BETWEEN 1000 AND 2500;

--query 6
--6. Write a SQL query to retrieve events with dates falling within a specific range. 
SELECT * FROM Event
WHERE event_date BETWEEN '2024-09-01' AND '2024-12-31';

--query 7
--7. Write a SQL query to retrieve events with available tickets that also have "Concert" in their name. 
SELECT * FROM Event
WHERE available_seats > 0
AND event_type = 'Concert';

--query 8
--8. Write a SQL query to retrieve users in batches of 5, starting from the 6th user. 
SELECT * FROM Customer
ORDER BY customer_id
OFFSET 5 ROWS
FETCH NEXT 5 ROWS ONLY;

--query 9
--9 Write a SQL query to retrieve bookings details contains booked no of ticket more than 4.
SELECT * FROM Booking
WHERE num_tickets > 4;

--query 10
--10. Write a SQL query to retrieve customer information whose phone number end with ‘000’
SELECT * FROM Customer
WHERE phone_number LIKE '%000';

--query 11
--11.  Write a SQL query to retrieve the events in order whose seat capacity more than 15000. 
SELECT * FROM Event
WHERE total_seats > 15000
ORDER BY total_seats DESC;

--query 12
--12.  Write a SQL query to select events name not start with x , y , z .
SELECT * FROM Event
WHERE event_name NOT LIKE 'x%' 
AND event_name NOT LIKE 'y%' 
AND event_name NOT LIKE 'z%';


----------------------------------------------------------------TASK-3----------------------------------------------------------------------------
-- Tasks 3 Aggregate functions, Having, Order By, GroupBy and Joins:
--query 1
--1. Write a SQL query to List Events and Their Average Ticket Prices. 
SELECT event_name, AVG(ticket_price) AS avg_ticket_price
FROM Event
GROUP BY event_name;

--query 2
--2. Write a SQL query to Calculate the Total Revenue Generated by Events.
SELECT e.event_name, SUM(b.total_cost) AS total_revenue
FROM Booking b
JOIN Event e ON b.event_id = e.event_id
GROUP BY e.event_name;

--query-3
--3. Write a SQL query to find the event with the highest ticket sales.
SELECT TOP 1 e.event_name, SUM(b.num_tickets) AS total_tickets_sold
FROM Booking b
JOIN Event e ON b.event_id = e.event_id
GROUP BY e.event_name
ORDER BY total_tickets_sold DESC;

--query-4
--4. Write a SQL query to Calculate the Total Number of Tickets Sold for Each Event.
SELECT e.event_name, SUM(b.num_tickets) AS total_tickets_sold
FROM Booking b
JOIN Event e ON b.event_id = e.event_id
GROUP BY e.event_name;

--query-5
--5. Write a SQL query to Find Events with No Ticket Sales. 
SELECT e.event_name
FROM Event e
LEFT JOIN Booking b ON e.event_id = b.event_id
WHERE b.booking_id IS NULL

--query-6
--6. Write a SQL query to Find the User Who Has Booked the Most Tickets. 
SELECT TOP 1 c.customer_name, SUM(b.num_tickets) AS total_tickets
FROM Booking b
JOIN Customer c ON b.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_tickets DESC

--query-7
--7. Write a SQL query to List Events and the total number of tickets sold for each month. 
SELECT e.event_name, DATEPART(MONTH, b.booking_date) AS month, SUM(b.num_tickets) AS total_tickets_sold
FROM Booking b
JOIN Event e ON b.event_id = e.event_id
GROUP BY e.event_name, DATEPART(MONTH, b.booking_date)

--query-8
--8. Write a SQL query to calculate the average Ticket Price for Events in Each Venue. 
SELECT v.venue_name, AVG(e.ticket_price) AS avg_ticket_price
FROM Event e
JOIN Venue v ON e.venue_id = v.venue_id
GROUP BY v.venue_name

--query-9
--9. Write a SQL query to calculate the total Number of Tickets Sold for Each Event Type. 
SELECT e.event_type, SUM(b.num_tickets) AS total_tickets_sold
FROM Booking b
JOIN Event e ON b.event_id = e.event_id
GROUP BY e.event_type

--query-10
--10. Write a SQL query to calculate the total Revenue Generated by Events in Each Year. 
SELECT YEAR(e.event_date) AS year, SUM(b.total_cost) AS total_revenue
FROM Booking b
JOIN Event e ON b.event_id = e.event_id
GROUP BY YEAR(e.event_date)

--query-11
--11. Write a SQL query to list users who have booked tickets for multiple events.
SELECT c.customer_name, COUNT(DISTINCT b.event_id) AS events_booked
FROM Booking b
JOIN Customer c ON b.customer_id = c.customer_id
GROUP BY c.customer_name
HAVING COUNT(DISTINCT b.event_id) > 1

--query-12
--12. Write a SQL query to calculate the Total Revenue Generated by Events for Each User. 
SELECT c.customer_name, SUM(b.total_cost) AS total_revenue
FROM Booking b
JOIN Customer c ON b.customer_id = c.customer_id
GROUP BY c.customer_name

--query-13
--13. Write a SQL query to calculate the Average Ticket Price for Events in Each Category and Venue. 
SELECT e.event_type, v.venue_name, AVG(e.ticket_price) AS avg_ticket_price
FROM Event e
JOIN Venue v ON e.venue_id = v.venue_id
GROUP BY e.event_type, v.venue_name

--query-14
--14. Write a SQL query to list Users and the Total Number of Tickets They've Purchased in the Last 30 Days.  
SELECT c.customer_name, SUM(b.num_tickets) AS total_tickets_purchased
FROM Booking b
JOIN Customer c ON b.customer_id = c.customer_id
WHERE b.booking_date >= DATEADD(DAY, -30, GETDATE())
GROUP BY c.customer_name

---------------------------------------------------------------Task-4-----------------------------------------------------------------------------
--Tasks4  Subquery and its types 

--query-1
--1. Calculate the Average Ticket Price for Events in Each Venue Using a Subquery. 
SELECT v.venue_name, 
       (SELECT AVG(e.ticket_price)
        FROM Event e
        WHERE e.venue_id = v.venue_id) AS avg_ticket_price
FROM Venue v

--query-2
--2. Find Events with More Than 50% of Tickets Sold using subquery. 
SELECT e.event_name
FROM Event e
WHERE (SELECT SUM(b.num_tickets)
       FROM Booking b
       WHERE b.event_id = e.event_id) > (e.total_seats * 0.5)

--query-3
--3. Calculate the Total Number of Tickets Sold for Each Event.
SELECT e.event_name, 
       (SELECT SUM(b.num_tickets)
        FROM Booking b
        WHERE b.event_id = e.event_id) AS total_tickets_sold
FROM Event e

--query-4
--4. Find Users Who Have Not Booked Any Tickets Using a NOT EXISTS Subquery. 
SELECT c.customer_name
FROM Customer c
WHERE NOT EXISTS (SELECT 1 
                  FROM Booking b 
                  WHERE b.customer_id = c.customer_id)

--query-5
--5. List Events with No Ticket Sales Using a NOT IN Subquery.
SELECT e.event_name
FROM Event e
WHERE e.event_id NOT IN (SELECT b.event_id 
                         FROM Booking b)

--query-6
--6. Calculate the Total Number of Tickets Sold for Each Event Type Using a Subquery in the FROM Clause. 
SELECT event_type, SUM(total_tickets_sold) AS Total_event_sales
FROM (SELECT e.event_type, SUM(b.num_tickets) AS total_tickets_sold
      FROM Event e
      JOIN Booking b ON e.event_id = b.event_id
      GROUP BY e.event_type) AS subquery
GROUP BY event_type

--query-7
--7. Find Events with Ticket Prices Higher Than the Average Ticket Price Using a Subquery in the WHERE Clause. 
SELECT e.event_name, e.ticket_price
FROM Event e
WHERE e.ticket_price > (SELECT AVG(ticket_price)
                        FROM Event)

--query-8
--8. Calculate the Total Revenue Generated by Events for Each User Using a Correlated Subquery. 
SELECT c.customer_name, 
       (SELECT SUM(b.total_cost)
        FROM Booking b
        WHERE b.customer_id = c.customer_id) AS total_revenue
FROM Customer c

--query-9
--9. List Users Who Have Booked Tickets for Events in a Given Venue Using a Subquery in the WHERE Clause. 
SELECT c.customer_name
FROM Customer c
WHERE EXISTS (SELECT 1
              FROM Booking b
              JOIN Event e ON b.event_id = e.event_id
              WHERE b.customer_id = c.customer_id
              AND e.venue_id = 1)

--query-10
--10. Calculate the Total Number of Tickets Sold for Each Event Category Using a Subquery with GROUP BY.
SELECT e.event_type, 
       SUM(t.total_tickets_sold) AS total_tickets_sold
FROM Event e
JOIN 
    (SELECT b.event_id, SUM(b.num_tickets) AS total_tickets_sold
     FROM Booking b
     GROUP BY b.event_id) t
ON e.event_id = t.event_id
GROUP BY e.event_type

--query-11
--11. Find Users Who Have Booked Tickets for Events in each Month Using a Subquery with DATE_FORMAT. 
SELECT c.customer_name, 
       (SELECT COUNT(b.booking_id)
        FROM Booking b
        WHERE b.customer_id = c.customer_id
        AND MONTH(b.booking_date) = 9) AS tickets_booked
FROM Customer c

--query-12
--12. Calculate the Average Ticket Price for Events in Each Venue Using a Subquery
SELECT v.venue_name, 
       (SELECT AVG(e.ticket_price)
        FROM Event e
        WHERE e.venue_id = v.venue_id) AS avg_ticket_price
FROM Venue v