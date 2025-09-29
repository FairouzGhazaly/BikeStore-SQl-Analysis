-- Insert data into customers
INSERT INTO customers (customer_id, first_name, last_name, phone, email, street, city, state, zip_code) VALUES
(1, 'John', 'Doe', '1234567890', 'john.doe@email.com', '123 Elm St', 'New York', 'NY', '10001'),
(2, 'Jane', 'Smith', '9876543210', 'jane.smith@email.com', '456 Oak St', 'Los Angeles', 'CA', '90001'),
(3, 'Alice', 'Johnson', '5556667777', 'alice.j@email.com', '789 Pine St', 'Chicago', 'IL', '60601');

-- Insert data into stores
INSERT INTO stores (store_id, store_name, phone, email, street, city, state, zip_code) VALUES
(1, 'Downtown Store', '1112223333', 'downtown@email.com', '12 Main St', 'New York', 'NY', '10001'),
(2, 'Westside Store', '4445556666', 'westside@email.com', '34 Market St', 'Los Angeles', 'CA', '90001');

-- Insert data into staffs
INSERT INTO staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id) VALUES
(1, 'Michael', 'Brown', 'michael.b@email.com', '1112233445', 1, 1, NULL),
(2, 'Sarah', 'Wilson', 'sarah.w@email.com', '5556677889', 1, 1, 1);

-- Insert data into orders
INSERT INTO orders (order_id, customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id) VALUES
(1, 1, 'Shipped', '2024-03-01', '2024-03-05', '2024-03-04', 1, 1),
(2, 2, 'Pending', '2024-03-02', '2024-03-06', NULL, 2, 2);

-- Insert data into categories
INSERT INTO categories (category_id, category_name) VALUES
(1, 'Electronics'),
(2, 'Clothing');

-- Insert data into brands
INSERT INTO brands (brand_id, brand_name) VALUES
(1, 'Apple'),
(2, 'Nike');

-- Insert data into products
INSERT INTO products (product_id, product_name, brand_id, category_id, model_year, list_price) VALUES
(1, 'iPhone 15', 1, 1, 2024, 999.99),
(2, 'Air Jordans', 2, 2, 2023, 199.99);

-- Insert data into stocks
INSERT INTO stocks (store_id, product_id, quantity) VALUES
(1, 1, 50),
(2, 2, 100);

-- Insert data into order_items
INSERT INTO order_items (order_id, item_id, product_id, quantity, list_price, discount) VALUES
(1, 1, 1, 1, 999.99, 0),
(2, 1, 2, 2, 199.99, 10);

-------------------------------------------------------------------------------------------------
-- UPDATE EXISTING DATA

-- Update a customer's phone number
UPDATE customers
SET phone = '1122334455'
WHERE customer_id = 1;

-- Update order status to 'Completed'
UPDATE orders
SET order_status = 'Completed', shipped_date = GETDATE()
WHERE order_id = 2;

-- Increase product price for Apple products by 10%
UPDATE products
SET list_price = list_price * 1.10
WHERE brand_id = 1;

-- Assign a manager to staff members
UPDATE staffs
SET manager_id = 1
WHERE staff_id = 2;

----------------------------------------------------------------------------------------
-- DELETE RECORDS

-- Delete a customer who canceled their account
DELETE FROM customers
WHERE customer_id = 3;

------------------------------------------------------------------------------
-- SELECT QUERIES 

-- Retrieve all orders with customer information
SELECT o.order_id, c.first_name, c.last_name, o.order_status, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Retrieve total sales per store
SELECT s.store_name, SUM(oi.quantity * oi.list_price * (1 - oi.discount/100)) AS total_sales
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN stores s ON o.store_id = s.store_id
GROUP BY s.store_name;

-- Get the best-selling products
SELECT p.product_name, SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;

-- Show available stock in each store
SELECT s.store_name, p.product_name, stk.quantity
FROM stocks stk
JOIN stores s ON stk.store_id = s.store_id
JOIN products p ON stk.product_id = p.product_id
ORDER BY s.store_name, p.product_name;

-- Get the number of orders per customer
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders DESC;
