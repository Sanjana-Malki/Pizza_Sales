CREATE DATABASE pizza_hut;
USE pizza_hut;

CREATE TABLE orders(
	order_id	INT PRIMARY KEY,
	order_date	DATE NOT NULL,
	order_time	TIME NOT NULL
);

CREATE TABLE order_details(
	order_details_id INT PRIMARY KEY,
	order_id		 INT NOT NULL,
	pizza_id		 TEXT NOT NULL,
	quantity		 INT NOT NULL
);

SELECT * FROM pizzas;
SELECT * FROM pizza_types;
SELECT * FROM orders;
SELECT * FROM order_details;

-- Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;

-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id;

-- Identify the highest-priced pizza.
SELECT 
    p.pizza_type_id, py.name, p.price
FROM
    pizzas p
        JOIN
    pizza_types py ON p.pizza_type_id = py.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Identify the most common pizza size ordered.
SELECT 
    p.size, COUNT(od.order_details_id) AS order_count
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY order_count DESC
LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    py.name, SUM(od.quantity) AS total_quantity
FROM
    pizza_types py
        JOIN
    pizzas p ON py.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY py.name
ORDER BY total_quantity DESC
LIMIT 5;

-- Intermediate
-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    py.category, SUM(od.quantity) AS total_quantity
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types py ON p.pizza_type_id = py.pizza_type_id
GROUP BY py.category;

-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time) AS hours, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY hours;

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name) AS types_of_pizza
FROM
    pizza_types
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity), 0) AS avg_order_per_day
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS quantity
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    py.name, SUM(p.price * od.quantity) AS revenue
FROM
    pizza_types py
        JOIN
    pizzas p ON py.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY py.name
ORDER BY revenue DESC
LIMIT 3;

-- ADVANCE QUERY
-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    py.category,
    ROUND(
        (SUM(od.quantity * p.price) / 
            (SELECT SUM(od2.quantity * p2.price)
             FROM order_details od2
             JOIN pizzas p2 ON p2.pizza_id = od2.pizza_id)
        ) * 100, 2
    ) AS revenue
FROM pizza_types py
JOIN pizzas p ON py.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY py.category
ORDER BY revenue DESC;

-- Analyze the cumulative revenue generated over time.
SELECT order_date,
SUM(revenue) over(order by order_date) as cum_revenue
FROM (SELECT o.order_date,
SUM(od.quantity*p.price) AS revenue
FROM order_details od JOIN pizzas p ON od.pizza_id=p.pizza_id
JOIN orders o ON o.order_id=od.order_id
GROUP BY o.order_date) AS sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT name, revenue, rank_no
FROM (SELECT category, name, revenue,
RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rank_no
FROM 
(SELECT py.category, py.name, SUM(od.quantity*p.price) AS revenue
FROM pizza_types py JOIN pizzas p ON py.pizza_type_id=p.pizza_type_id
JOIN order_details od ON p.pizza_id=od.pizza_id
GROUP BY py.category, py.name) AS A)AS B
WHERE rank_no<=3;

