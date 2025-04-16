-- Selecting data from the relevant tables, then joining the tables into 1 table called 'sales_data'
SELECT o.order_id,
order_date, 
o.customer_id, 
total_price,
order_item_id,
oi.product_id,
quantity, 
price_at_purchase,
CONCAT(first_name, ' ', last_name) AS name,
p.product_name,
p.category
INTO sales_data
FROM orders AS o
LEFT JOIN order_items AS oi
ON o.order_id = oi.order_id
LEFT JOIN customers AS c
ON o.customer_id = c.customer_id 
LEFT JOIN products AS p
ON oi.product_id = p.product_id;

-- Finding the total revenue from each month using the EXTRACT function and the SUM function. 
SELECT 
EXTRACT(month FROM order_date) AS month,
SUM(total_price) AS monthly_sales
FROM sales_data
GROUP BY month
ORDER BY month;

-- Finding the top performing products using the SUM function and multiplying individual product prices with quantity sold. 
SELECT 
product_name,
SUM(price_at_purchase * quantity) AS total_revenue
FROM sales_data
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Finding the top customers using the SUM function, and grouping by the customer_name. 
SELECT 
name AS customer_name,
SUM(total_price) AS total_spent
FROM sales_data
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- Finding the categories with the highest sales and ranking them from the highest revenue to the lowest. 
SELECT 
  category,
  SUM(price_at_purchase) AS category_sales
FROM sales_data
GROUP BY category
ORDER BY category_sales DESC;

-- Finding the average revenue for each order, rounded to 2 decimal points. 
SELECT 
ROUND(AVG(total_price),2) AS average_order_value
FROM 
(SELECT 
    order_id, 
    MAX(total_price) AS total_price
  FROM sales_data
  GROUP BY order_id) 
AS orders;
