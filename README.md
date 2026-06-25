# 🍕 Pizza Sales Analysis (SQL)

## Overview
Analyzed a full year (2015) of pizza restaurant sales data using SQL — covering **21,350 orders**, **48,620 order line items**, and **32 pizza types** across 4 categories.

## Tools Used
- MySQL | SQL (Joins, Aggregations, Subqueries, Window Functions)

## Key Insights
- **Total revenue: $817,860.05** from 21,350 orders.
- **The Greek Pizza** was the highest-priced item ($35.95); **Large (L)** was the most-ordered size (18,526 orders).
- **The Classic Deluxe Pizza** topped sales by quantity (2,453 units); **Thai Chicken Pizza** topped sales by revenue ($43,434).
- **Classic was the top revenue category (26.9%)**, closely followed by Supreme (25.5%), Chicken (24.0%), and Veggie (23.7%).
- **Peak ordering hours** were 12–1 PM and 5–8 PM, averaging **138 pizzas sold per day**.
- Used **window functions** (`RANK() OVER PARTITION BY`, cumulative `SUM() OVER`) to find the top 3 best-selling pizzas by revenue within each category.

## SQL Techniques Used
- Multi-table joins, aggregate functions, subqueries
- Window functions for category-wise ranking and running revenue totals
- Top-N analysis with `GROUP BY` / `ORDER BY` / `LIMIT`

## How to Use
1. Run `pizza_sales.sql` on MySQL to create the `pizza_hut` database and tables.
2. Load the 4 CSVs (`orders`, `order_details`, `pizzas`, `pizza_types`).
3. Run the queries (Basic → Intermediate → Advanced) to reproduce the insights above.

## Author
**Sanjana Malki**
