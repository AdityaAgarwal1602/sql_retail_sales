-- SQL Retail Sales Analysis
CREATE DATABASE sql_project_reatil_sales_analysis;


-- Create TABLE
CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);


-- Import the data into the table for cleaning and processing
COPY retail_sales
FROM 'file_location'
DELIMITER ','
CSV HEADER;


--Data Cleaning

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


-- Data Exploration

-- How many sales we have?
	SELECT COUNT(*) AS total_sales_count FROM retail_sales;

-- How many unique customers we have?
	SELECT COUNT(DISTINCT(customer_id)) AS unique_customers FROM retail_sales;

-- How many types of category were sold?
	Select COUNT(DISTINCT(category)) AS categories_sold FROM retail_sales;


-- Data Analysis (Business Key Problems and Answers)

-- Q.1 Display all columns for sales made on '2022-11-05.
	SELECT * 
	FROM retail_sales AS r
	WHERE r.sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
	SELECT * 
	FROM retail_sales AS r
	WHERE r.category='Clothing' 
	AND r.quantity>3
	AND TO_CHAR(r.sale_date,'YYYY-MM')='2022-11';
	
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

	SELECT category, SUM(total_sale) AS total_sales
	FROM retail_sales 
	GROUP BY 1;
	
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

	SELECT ROUND(AVG(age)) AS average_customer_age
	FROM retail_sales
	WHERE category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

	SELECT *
	FROM retail_sales
	WHERE total_sale>1000;
	
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

	SELECT gender, category, COUNT(*) as transaction_count
	FROM retail_sales
	GROUP BY gender, category;
	
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

	SELECT 
		EXTRACT(YEAR FROM sale_date) AS sale_year,
		TO_CHAR(sale_date, 'Mon') AS sale_month, 
		ROUND(AVG(total_sale)::NUMERIC,2) AS average_sale
	FROM retail_sales
	GROUP BY sale_year, sale_month
	ORDER BY sale_year, average_sale DESC, sale_month;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

	SELECT customer_id, SUM(total_sale) AS total_sales
	FROM retail_sales
	GROUP BY customer_id
	ORDER BY total_sales DESC
	LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

	SELECT category, COUNT(DISTINCT(customer_id)) AS customer_count
	FROM retail_sales
	GROUP BY category
	ORDER BY customer_count;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

	SELECT 'Morning' AS shift, COUNT(*) AS number_of_orders
	FROM retail_sales
	WHERE EXTRACT(HOUR FROM sale_time)<=11
	UNION
	SELECT 'Afternoon' AS shift, COUNT(*) AS number_of_orders
	FROM retail_sales
	WHERE EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17
	UNION 
	SELECT 'Evening' AS shift, COUNT(*) AS number_of_orders
	FROM retail_sales
	WHERE EXTRACT(HOUR FROM sale_time)>=18;


-- END OF PROJECT