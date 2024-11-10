CREATE TABLE retail_sales
   
( 
   transactions_id INT PRIMARY KEY,
   sale_date DATE,
   sale_time TIME,
   customer_id	INT,
   gender VARCHAR(15),
   age	INT,
   category VARCHAR(15),
   quantiy int,
   price_per_unit FLOAT,
   cogs	FLOAT,
   total_sale FLOAT
   );

SELECT *
FROM retail_sales;

 
 

-- DATA CLEANING

SELECT *
FROM retail_sales
where transactions_id IS NULL 
   OR sale_date is null
   or sale_time IS null
   OR customer_id is null
   or gender is null
   or age is null
   or category is null
   or quantiy is null
   or price_per_unit is null
   or cogs is null
   or total_sale is null;
   
-- DATA EXPLORATION

-- How many sales we have?
select count(*) as total_sales
from retail_sales;

-- How many unique customers we have?
select count(distinct(customer_id)) as total_customers
from retail_sales;

-- which are the categorires we have?
select distinct (category)
from retail_sales;

-- DATA ANALYSIS / BUISNESS KEY PROBLEMS &ANSWERS

-- Q.1 Write SQL query to retrieve all columns for sales 2022-11-05
select *
from retail_sales
where sale_date = '2022-11-05';

-- 	Q.2 Write a SQL query to calculate the total sales for each category
select category, sum(total_sale) as total_sale, count(*) as total_orders
from retail_sales
group by category;

-- Q.3 Write a SQL query to find the average age of customers who purchased items from the 'beauty' category
select round(avg(age),2) as avg_age
from retail_sales 
where category = 'beauty';

-- Q.4 Write a SQL query to find all the transactions where the total sales is greater than 1000
select *
from retail_sales
where total_sale > 1000;

-- Q.5 Write a SQL query to find total number of transactions made by each gender in each category
select gender, category, count(transactions_id)
from retail_sales
group by gender,category
order by 2;

-- Q.6 Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year.
 select year(sale_date) as 'year' ,
 month(sale_date) as 'month',
 avg(total_sale),
 RANK() OVER (partition by year(sale_date) ORDER BY avg(total_sale) DESC) AS 'rank'
 from retail_sales
 group by 1,2;
 
 
 
 select `year`,`month`, `avg(total_sale)`
 FROM 
(
   select year(sale_date) as 'year' ,
 month(sale_date) as 'month',
 avg(total_sale),
 RANK() OVER (partition by year(sale_date) ORDER BY avg(total_sale) DESC) AS 'rank'
 from retail_sales
 group by 1,2
 
 ) AS t1
 where `rank` =  1;
   
 
 -- Q.7 Write a SQL query to find the top 5 customers based on the highest total_sales
 SELECT customer_id, 
 sum(total_sale) as total_sales
 from retail_sales
 group by customer_id
 order by 2 desc
 limit 5;
 
 -- Q.8 Write a SQL query to find the number of unique customers who purchased items from each category
 select category, count( distinct (customer_id))
 from retail_sales
 group by 1;
 
 
 -- Q.9 Write a AQL query to create each shift and number of orders
 
 select *,
    CASE
       WHEN hour(sale_time ) <12 THEN 'Morning'
       WHEN hour(sale_time ) BETWEEN 12 AND 17 THEN ' Afternoon'
       ELSE 'Evening'
	END as shift
from retail_sales;

WITH hourly_sales 
AS
(
    select *,
    CASE
       WHEN hour(sale_time ) <12 THEN 'Morning'
       WHEN hour(sale_time ) BETWEEN 12 AND 17 THEN ' Afternoon'
       ELSE 'Evening'
	END as shift
from retail_sales
)
SELECT shift , count(*) as total_orders
from hourly_sales
group by shift ;

-- Q.10 Write a SQL query to retrieve all transactions where the category is 'clothing ' and the quantity sold is more than 4 in the month of november 2022
SELECT *,sum(quantiy)
FROM retail_sales 
where 
     category = 'Clothing'
     AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
     and quantiy >= 4
group by 1, 2;
     
-- End of project