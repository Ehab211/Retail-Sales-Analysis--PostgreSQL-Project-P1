-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- Select ALL ROWS
SELECT * FROM retail_sales;

-- COUNT ALL ROWS
SELECT COUNT(*) FROM retail_sales;

-- Data Cleaning
-- DELETE NULL VALUES (DATA CLEANING)
delete from retail_sales where 
		transactions_id is null
		OR sale_date is null
		OR sale_time is null
		OR customer_id is null
		OR gender is null
		OR age is null
		OR category is null
		OR quantity is null
		OR price_per_unit is null
		OR cogs is null
		OR total_sale is null;

-- DATA EXPLORATION
-- How many sales we have right
SELECT COUNT(*) AS Total_Sale FROM retail_sales;

-- How many unique coustomer we have right
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- How many unique category we have right
SELECT COUNT(DISTINCT category) FROM retail_sales;

-- what category we have right
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- 1- Write a SQL query to retrieve all columns for sales made on '2022-11-05':
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05'; 

-- 2- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022:
SELECT * FROM retail_sales 
WHERE category = 'Clothing' 
AND quantity > 3 
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- 3- Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,
	SUM(total_sale) AS total_sale_amount,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;

-- 4- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 'category' AS label, 'Beauty' AS value
UNION
SELECT 'average_age_of_customers' AS label, ROUND(AVG(age), 0)::text AS value
FROM retail_sales
WHERE category = 'Beauty';

-- 5- Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- 6- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT gender, category, COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY gender, category;

-- 7-Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
       year,
       month,
       avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    ROUND(AVG(total_sale)::NUMERIC, 2) AS avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY year, month
) as t1
WHERE rank = 1

-- 8- Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id, sum (total_sale) as total_sales from retail_sales
group by customer_id
order by total_sales desc
limit 5

-- 9- Write a SQL query to find the number of unique customers who purchased items from each category.:
select category, count (DISTINCT customer_id) as number_of_unique_customers from retail_sales
group by category
order by number_of_unique_customers desc

--10 - Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
AS
(
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders    
FROM hourly_sale
GROUP BY shift
ORDER BY
    CASE shift
        WHEN 'Morning' THEN 1
        WHEN 'Afternoon' THEN 2
        ELSE 3
    END;
-------- END OF PROJECT --------
