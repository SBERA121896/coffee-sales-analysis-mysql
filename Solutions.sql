-- Coffee Sales --Data Analysis

USE coffe_sales;

SELECT * FROM city;
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM sales;

-- Report and Data Analysis


-- Q.1 Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?
SELECT 
    city_name,
    ROUND((population * 0.25) / 1000000, 2) AS coffee_consumers_in_millions,
    city_rank
FROM
    city
ORDER BY 2 DESC;



-- Q.2 Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales for each cities in the last quarter of 2023?
WITH temp AS (
SELECT 
    city.city_name, sales.total, sales.sale_date
FROM
    customers
        INNER JOIN
    sales ON customers.customer_id = sales.customer_id
        INNER JOIN
    city ON customers.city_id = city.city_id
)SELECT 
    city_name, SUM(total) AS total_revenue
FROM
    temp
WHERE
    sale_date BETWEEN '2023-10-01' AND '2023-12-31'
GROUP BY city_name
	ORDER BY SUM(total) DESC;



-- Q.3 Sales Count for Each Product
-- How many units of each coffee product have been sold?
SELECT 
    products.product_name, COUNT(sales.product_id)
FROM
    sales
        INNER JOIN
    products ON sales.product_id = products.product_id
GROUP BY sales.product_id;



-- Q.4 Average Sales Amount per City
-- What is the average sales amount per customer in each city?
SELECT 
    city.city_name,
    ROUND(SUM(sales.total) / COUNT(DISTINCT customers.customer_id),
            2) AS avg_amount
FROM
    customers
        INNER JOIN
    sales ON customers.customer_id = sales.customer_id
        INNER JOIN
    city ON customers.city_id = city.city_id
GROUP BY city.city_name
ORDER BY ROUND(SUM(sales.total) / COUNT(DISTINCT customers.customer_id),
        2) DESC;




-- Q.5 City Population and Coffee Consumers
-- Provide a list of cities along with their populations and estimated coffee consumers.
SELECT 
    city_name,
    population,
    ROUND((population * 0.25), 2) AS coffee_consumers
FROM
    city;




-- Q.6 Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?
WITH temp AS(
SELECT city.city_name, products.product_name,COUNT(sales.total) AS total,
RANK() OVER(PARTITION BY city.city_name ORDER BY COUNT(sales.total)DESC) AS rnk
FROM customers INNER JOIN city ON customers.city_id=city.city_id
INNER JOIN sales ON customers.customer_id=sales.customer_id
INNER JOIN products ON sales.product_id=products.product_id
GROUP BY city.city_name, products.product_name
)SELECT * FROM temp WHERE rnk<=3;




-- Q.7 Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?
SELECT 
    city.city_name,
    COUNT(DISTINCT sales.customer_id) AS no_of_customers
FROM
    customers
        INNER JOIN
    sales ON customers.customer_id = sales.customer_id
        INNER JOIN
    city ON customers.city_id = city.city_id
GROUP BY city.city_name;




-- Q.8 Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer
SELECT 
    city.city_name,
    ROUND(SUM(sales.total) / COUNT(DISTINCT customers.customer_id),
            2) AS avg_amount,
	ROUND(city.estimated_rent/COUNT(DISTINCT customers.customer_id),
			2) AS avg_rent
FROM
    customers
        INNER JOIN
    sales ON customers.customer_id = sales.customer_id
        INNER JOIN
    city ON customers.city_id = city.city_id
GROUP BY city.city_name,city.estimated_rent
ORDER BY 2 DESC;




-- Q.9 Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly).
WITH temp as(
SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    SUM(total) AS monthly_sale
FROM
    sales
GROUP BY 1 , 2
) SELECT year,month,ROUND(((monthly_sale - LAG(monthly_sale) OVER(ORDER BY year,month))
	/LAG(monthly_sale) OVER(ORDER BY year,month))*100,2) AS growth 
FROM 
	temp;




-- Q.10 Market Potential Analysis
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer
SELECT 
    city.city_name,
    SUM(sales.total) AS total_sales,
    city.estimated_rent,
    COUNT(DISTINCT sales.customer_id) AS total_customers,
    (city.population * 0.25) AS coffee_consumers
FROM
    customers
        INNER JOIN
    sales ON customers.customer_id = sales.customer_id
        INNER JOIN
    city ON customers.city_id = city.city_id
GROUP BY city.city_name , city.estimated_rent , city.population
ORDER BY SUM(sales.total) DESC
LIMIT 3;





-- Rcomendation
-- City1: Pune
-- 	1. Highest total revenue.
--     2. Rent is very low.
--     3. Third most customers, which is 52.
--     
-- City2: Delhi
--     1. Highest number of coffee consumers.
--     2. Second most customers, which is 68.
--     3. Hold 5th position in terms of revenue.
--     
-- City3: Jaipur
-- 	1. Highest number of customers.
--     2. 4th highest revenue.
--     3. Rent is very low.



