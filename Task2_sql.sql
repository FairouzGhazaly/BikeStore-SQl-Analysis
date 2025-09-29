-- 1) Which bike is the most expensive?
SELECT TOP 1 product_name, list_price 
FROM production.products 
ORDER BY list_price DESC;

-- 2) How many total customers does BikeStore have?
SELECT COUNT(*) AS total_customers 
FROM sales.customers;

-- 2) Excluding customers with order status 3 (Rejected orders)
SELECT COUNT(DISTINCT customer_id) AS valid_customers 
FROM sales.orders 
WHERE order_status <> 3;

-- 3) How many stores does BikeStore have?
SELECT COUNT(*) AS total_stores 
FROM sales.stores;

-- 4) What is the total price spent per order?
SELECT order_id, 
       SUM(list_price * quantity * (1 - discount)) AS total_price 
FROM sales.order_items 
GROUP BY order_id;

-- 5) What’s the sales/revenue per store?
SELECT o.store_id, s.store_name, 
       SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS total_revenue
FROM sales.order_items oi
JOIN sales.orders o ON oi.order_id = o.order_id
JOIN sales.stores s ON o.store_id = s.store_id
GROUP BY o.store_id, s.store_name
ORDER BY total_revenue DESC;

-- 6) Which category is most sold?
SELECT c.category_name, 
       SUM(oi.quantity) AS total_sold
FROM sales.order_items oi
JOIN production.products p ON oi.product_id = p.product_id
JOIN production.categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sold DESC;

-- 7) Which category rejected more orders?
SELECT c.category_name, 
       COUNT(o.order_id) AS rejected_orders
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN production.products p ON oi.product_id = p.product_id
JOIN production.categories c ON p.category_id = c.category_id
WHERE o.order_status = 3
GROUP BY c.category_name
ORDER BY rejected_orders DESC;

-- 8) Which bike is the least sold?
SELECT TOP 1 p.product_name, 
       SUM(oi.quantity) AS total_sold
FROM sales.order_items oi
JOIN production.products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold ASC;

-- 9) What’s the full name of a customer with ID 259?
SELECT first_name, last_name 
FROM sales.customers 
WHERE customer_id = 259;

-- 10) What did the customer on question 9 buy and when? What’s the status of this order?
SELECT o.order_id, o.order_date, o.order_status, 
       p.product_name, oi.quantity
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN production.products p ON oi.product_id = p.product_id
WHERE o.customer_id = 259;

-- 11) Which staff processed the order of customer 259? And from which store?
SELECT o.order_id, s.first_name, s.last_name, st.store_name
FROM sales.orders o
JOIN sales.staffs s ON o.staff_id = s.staff_id
JOIN sales.stores st ON s.store_id = st.store_id
WHERE o.customer_id = 259;

-- 12) How many staff does BikeStore have? Who seems to be the lead staff at BikeStore?
SELECT COUNT(*) AS total_staff 
FROM sales.staffs;

-- 13) Which brand is the most liked?
SELECT b.brand_name, COUNT(oi.product_id) AS total_sold
FROM sales.order_items oi
JOIN production.products p ON oi.product_id = p.product_id
JOIN production.brands b ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY total_sold DESC;

-- 14) How many categories does BikeStore have, and which one is the least liked?
SELECT COUNT(*) AS total_categories FROM production.categories;

SELECT c.category_name, COUNT(oi.product_id) AS total_sold
FROM sales.order_items oi
JOIN production.products p ON oi.product_id = p.product_id
JOIN production.categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sold ASC;

-- 15) Which store still has more products of the most liked brand?
SELECT s.store_name, SUM(i.quantity) AS stock_quantity
FROM production.stocks i
JOIN production.products p ON i.product_id = p.product_id
JOIN production.brands b ON p.brand_id = b.brand_id
JOIN sales.stores s ON i.store_id = s.store_id
WHERE b.brand_name = (SELECT TOP 1 brand_name FROM sales.order_items 
                      JOIN production.products ON sales.order_items.product_id = production.products.product_id 
                      JOIN production.brands ON production.products.brand_id = production.brands.brand_id 
                      GROUP BY brand_name ORDER BY COUNT(sales.order_items.product_id) DESC)
GROUP BY s.store_name
ORDER BY stock_quantity DESC;

-- 16) Which state is doing better in terms of sales?
SELECT c.state, SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.customers c ON o.customer_id = c.customer_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY c.state
ORDER BY total_revenue DESC;

-- 17) What’s the discounted price of product id 259?
SELECT product_id, list_price, (list_price * (1 - discount)) AS discounted_price
FROM sales.order_items
WHERE product_id = 259;

-- 18) What’s the product name, quantity, price, category, model year, and brand name of product number 44?
SELECT p.product_name, p.model_year, p.list_price, c.category_name, b.brand_name
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id
JOIN production.brands b ON p.brand_id = b.brand_id
WHERE p.product_id = 44;

-- 19) What’s the zip code of CA?
SELECT DISTINCT state, zip_code
FROM sales.customers
WHERE state = 'CA';

-- 20) How many states does BikeStore operate in?
SELECT COUNT(DISTINCT state) AS total_states
FROM sales.customers;

-- 21) How many bikes under the children category were sold in the last 8 months?
SELECT SUM(oi.quantity) AS total_sold
FROM sales.order_items oi
JOIN production.products p ON oi.product_id = p.product_id
JOIN production.categories c ON p.category_id = c.category_id
JOIN sales.orders o ON oi.order_id = o.order_id
WHERE c.category_name = 'Children' AND o.order_date >= DATEADD(MONTH, -8, GETDATE());

-- 22) What’s the shipped date for the order from customer 523?
SELECT order_id, order_date, shipped_date
FROM sales.orders
WHERE customer_id = 523;

-- 23) How many orders are still pending?
SELECT COUNT(*) AS pending_orders
FROM sales.orders
WHERE order_status = 1; -- Assuming 1 represents 'Pending' status

-- 24) What are the category and brand names of "Electra White Water 3i - 2018"?
SELECT p.product_name, c.category_name, b.brand_name
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id
JOIN production.brands b ON p.brand_id = b.brand_id
WHERE p.product_name = 'Electra White Water 3i - 2018';

