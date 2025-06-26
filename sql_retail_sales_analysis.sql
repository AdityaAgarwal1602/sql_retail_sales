-- SQL Retail Sales Analysis

-- Step 1: Create Database
CREATE DATABASE sql_project_retail_sales_analysis;

-- Step 2: Create Table
CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

-- Step 3: Import the Data
COPY retail_sales
FROM 'file_location'
DELIMITER ','
CSV HEADER;

-- Step 4: Data Cleaning

-- Find NULL values
SELECT * FROM retail_sales 
WHERE transactions_id IS NULL OR
	  sale_date IS NULL OR
	  sale_time IS NULL OR
	  customer_id IS NULL OR
	  gender IS NULL OR
	  age IS NULL OR
	  category IS NULL OR
	  quantity IS NULL OR
	  price_per_unit IS NULL OR
	  cogs IS NULL OR
	  total_sale IS NULL;

-- Remove NULL values
DELETE FROM retail_sales 
WHERE transactions_id IS NULL OR
	  sale_date IS NULL OR
	  sale_time IS NULL OR
	  customer_id IS NULL OR
	  gender IS NULL OR
	  age IS NULL OR
	  category IS NULL OR
	  quantity IS NULL OR
	  price_per_unit IS NULL OR
	  cogs IS NULL OR
	  total_sale IS NULL;

-- Step 5: Data Exploration

-- Total sales records
SELECT COUNT(*) AS total_sales_count FROM retail_sales;

-- Unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;

-- Distinct product categories
SELECT COUNT(DISTINCT category) AS categories_sold FROM retail_sales;

-- Step 6: Data Analysis (Business Questions)

-- Q1: Sales on 2022-11-05
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2: Clothing sales with quantity > 3 in Nov-2022
SELECT * 
FROM retail_sales
WHERE category = 'Clothing' 
  AND quantity > 3
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Q3: Total sales by category
SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales 
GROUP BY category;

-- Q4: Average age of customers in 'Beauty' category
SELECT ROUND(AVG(age)) AS average_customer_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5: Transactions with total_sale > 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6: Transaction count by gender and category
SELECT gender, category, COUNT(*) AS transaction_count
FROM retail_sales
GROUP BY gender, category;

-- Q7: Average sale per month + best-selling month
SELECT 
	EXTRACT(YEAR FROM sale_date) AS sale_year,
	TO_CHAR(sale_date, 'Mon') AS sale_month, 
	ROUND(AVG(total_sale)::NUMERIC, 2) AS average_sale
FROM retail_sales
GROUP BY sale_year, sale_month
ORDER BY sale_year, average_sale DESC, sale_month;

-- Q8: Top 5 customers by total sales
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q9: Unique customers per category
SELECT category, COUNT(DISTINCT customer_id) AS customer_count
FROM retail_sales
GROUP BY category
ORDER BY customer_count;

-- Q10: Order shift distribution
SELECT 'Morning' AS shift, COUNT(*) AS number_of_orders
FROM retail_sales
WHERE EXTRACT(HOUR FROM sale_time) <= 11
UNION
SELECT 'Afternoon' AS shift, COUNT(*) AS number_of_orders
FROM retail_sales
WHERE EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17
UNION 
SELECT 'Evening' AS shift, COUNT(*) AS number_of_orders
FROM retail_sales
WHERE EXTRACT(HOUR FROM sale_time) >= 18;

-- END OF PROJECT
