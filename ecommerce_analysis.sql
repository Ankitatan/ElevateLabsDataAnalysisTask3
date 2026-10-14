
-- TASK 3: SQL FOR DATA ANALYSIS
-- Database: E-commerce

USE ecommerce_db;

-- 1. Create Customers table
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50)
);

-- 2. Create Orders table
CREATE TABLE IF NOT EXISTS Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    status VARCHAR(30),
    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);

-- 3. Insert sample data
INSERT INTO Customers VALUES
(1, 'Amit Sharma', 'Delhi'),
(2, 'Priya Verma', 'Mumbai'),
(3, 'Rahul Singh', 'Pune'),
(4, 'Neha Gupta', 'Delhi'),
(5, 'Karan Mehta', 'Jaipur');

INSERT INTO Orders VALUES
(101, 1, '2026-01-05', 2500.00, 'Completed'),
(102, 2, '2026-01-08', 1800.00, 'Completed'),
(103, 1, '2026-02-10', 3200.00, 'Completed'),
(104, 3, '2026-02-15', 1200.00, 'Cancelled'),
(105, 4, '2026-03-01', 4500.00, 'Completed'),
(106, 2, '2026-03-05', 2100.00, 'Completed');

-- 4. SELECT, WHERE and ORDER BY
SELECT *
FROM Orders
WHERE amount > 2000
ORDER BY amount DESC;

-- 5. Total revenue from completed orders
SELECT SUM(amount) AS total_revenue
FROM Orders
WHERE status = 'Completed';

-- 6. Average order value
SELECT AVG(amount) AS average_order_value
FROM Orders
WHERE status = 'Completed';

-- 7. Revenue and orders by customer
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(
        CASE WHEN o.status = 'Completed'
             THEN o.amount ELSE 0 END
    ), 0) AS total_revenue
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC;

-- 8. INNER JOIN: customers with orders
SELECT c.customer_name, o.order_id, o.amount
FROM Customers c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id;

-- 9. LEFT JOIN: all customers, including those
-- without orders
SELECT c.customer_name, o.order_id
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id;

-- 10. RIGHT JOIN: all orders, including any
-- without a matching customer
SELECT c.customer_name, o.order_id, o.amount
FROM Customers c
RIGHT JOIN Orders o
    ON c.customer_id = o.customer_id;

-- 11. Subquery: orders above average order amount
SELECT order_id, customer_id, amount
FROM Orders
WHERE amount > (
    SELECT AVG(amount)
    FROM Orders
);

-- 12. View: completed customer sales
CREATE OR REPLACE VIEW Customer_Sales AS
SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(o.amount), 0) AS revenue
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
    AND o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name;

-- Query the view
SELECT *
FROM Customer_Sales
ORDER BY revenue DESC;

-- 13. Indexes for filtering and joins
CREATE INDEX idx_orders_customer
ON Orders(customer_id);

CREATE INDEX idx_orders_status
ON Orders(status);

-- 14. Check query execution plan
EXPLAIN
SELECT order_id, amount
FROM Orders
WHERE status = 'Completed';
