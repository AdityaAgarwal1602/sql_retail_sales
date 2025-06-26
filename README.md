# 🛒 Retail Sales Analysis Using SQL

This project involves end-to-end SQL operations on a **retail sales dataset**, including data cleaning, exploration, and business-oriented data analysis using PostgreSQL.

The following steps are involved:

- **Data Collection and Data Modelling**
- **Data Cleaning**
- **Data Exploration**
- **Data Analysis**

---

## Data Collection and Data Modelling

### &nbsp;&nbsp;&nbsp;&nbsp;Create the database  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Initializes a new PostgreSQL database for the project.
```sql
CREATE DATABASE sql_project_reatil_sales_analysis;
```

### &nbsp;&nbsp;&nbsp;&nbsp;Create retail_sales table  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Defines columns to store retail transaction data including sales amount, category, customer info, etc.
```sql
CREATE TABLE retail_sales (
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
```

### &nbsp;&nbsp;&nbsp;&nbsp;Importing Data  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Replace 'file_location' with the actual CSV file path to import the data.
```sql
COPY retail_sales
FROM 'file_location'
DELIMITER ','
CSV HEADER;
```

## Data Cleaning  
Before analysis, we performed data cleaning to ensure the dataset was accurate and consistent.

### &nbsp;&nbsp;&nbsp;&nbsp;Identify NULL values:
```sql
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
```

### &nbsp;&nbsp;&nbsp;&nbsp;Delete NULL records:
```sql
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
```

## Data Exploration  
We conducted an initial exploration of the dataset to understand its structure and content. Key steps included:

- Counting total number of transactions.
- Identifying the number of unique customers.
- Listing all distinct product categories sold.
These insights helped guide the business questions addressed in the analysis section.

### &nbsp;&nbsp;&nbsp;&nbsp;Total sales records
```sql
SELECT COUNT(*) AS total_sales_count FROM retail_sales;
```

### &nbsp;&nbsp;&nbsp;&nbsp;Unique customers
```sql
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;
```

### &nbsp;&nbsp;&nbsp;&nbsp;Distinct categories
```sql
SELECT COUNT(DISTINCT category) AS categories_sold FROM retail_sales;
```

## Data Analysis (Business Insights)
In this section, we used SQL queries to answer key business questions and derive actionable insights from the dataset.  
Each query is aligned with a real-world use case, helping to convert raw sales data into meaningful business intelligence.

### &nbsp;&nbsp;&nbsp;&nbsp;Q.1 Display all columns for sales made on '2022-11-05'.
```sql
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';
```
### &nbsp;&nbsp;&nbsp;&nbsp;Q.2 Display all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022.
```sql
SELECT * 
FROM retail_sales
WHERE category = 'Clothing' 
  AND quantity > 3
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';
```
### &nbsp;&nbsp;&nbsp;&nbsp;Q.3 Calculate the total sales (total_sale) for each category.
```sql
SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales 
GROUP BY category;
```
### &nbsp;&nbsp;&nbsp;&nbsp;Q.4 Find the average age of customers who purchased items from the 'Beauty' category.
```sql
SELECT ROUND(AVG(age)) AS average_customer_age
FROM retail_sales
WHERE category = 'Beauty';
```
### &nbsp;&nbsp;&nbsp;&nbsp;Q.5 Display all transactions where the total_sale is greater than 1000.
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```
### &nbsp;&nbsp;&nbsp;&nbsp;Q.6 Find the total number of transactions (transaction_id) made by each gender in each category.
```sql
SELECT gender, category, COUNT(*) AS transaction_count
FROM retail_sales
GROUP BY gender, category;
```
### &nbsp;&nbsp;&nbsp;&nbsp;Q.7 Calculate the average sale for each month. Find out best selling month in each year.
```sql
SELECT 
    EXTRACT(YEAR FROM sale_date) AS sale_year,
    TO_CHAR(sale_date, 'Mon') AS sale_month, 
    ROUND(AVG(total_sale)::NUMERIC, 2) AS average_sale
FROM retail_sales
GROUP BY sale_year, sale_month
ORDER BY sale_year, average_sale DESC, sale_month;
```
### &nbsp;&nbsp;&nbsp;&nbsp;Q.8 Find the top 5 customers based on the highest total sales.
```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```
### &nbsp;&nbsp;&nbsp;&nbsp;Q.9 Find the number of unique customers who purchased items from each category.
```sql
SELECT category, COUNT(DISTINCT customer_id) AS customer_count
FROM retail_sales
GROUP BY category
ORDER BY customer_count;
```
### &nbsp;&nbsp;&nbsp;&nbsp;Q.10 Order distribution by shift (Morning <=12, Afternoon Between 12 & 17, Evening >17).
```sql
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
```

## Conclusion

This project demonstrates how SQL can be used to clean, explore, and analyze retail sales data to generate actionable business insights.  
The queries presented cover a wide range of use cases, from customer segmentation to time-based sales trends, and lay the foundation for future visualization or integration into business dashboards.
