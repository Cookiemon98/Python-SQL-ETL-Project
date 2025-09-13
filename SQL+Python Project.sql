-- CREATE DATABASE IF NOT EXISTS sql_python_project;
-- USE sql_python_project;
-- DROP TABLE IF EXISTS df_orders;

-- CREATE TABLE df_orders (
-- order_id int primary key
-- ,order_date date
-- ,ship_mode varchar(20)
-- ,segment varchar(20)
-- ,country varchar(20)
-- ,city varchar(20)
-- ,state varchar(20)
-- ,postal_code varchar(20)
-- ,region varchar(20)
-- ,category varchar(20)
-- ,sub_category varchar(20)
-- ,product_id varchar(50)
-- ,quantity int
-- ,discount decimal (7,2)
-- ,sale_price decimal (7,2)
-- ,profit decimal (7,2))

-- SELECT *
-- FROM df_orders;

-- Top 10 higest revenue generating products
-- SELECT product_id, SUM(sale_price) AS Revenue
-- FROM df_orders
-- GROUP BY product_id
-- ORDER BY Revenue DESC
-- LIMIT 10;


-- Top 5 higest selling products in each region
-- WITH CTE AS (
-- SELECT region, product_id, SUM(sale_price) AS Revenue, row_number() OVER (PARTITION BY region ORDER BY region, SUM(sale_price) DESC) AS row_num
-- FROM df_orders
-- GROUP BY region, product_id)
-- SELECT *
-- FROM CTE
-- WHERE row_num BETWEEN 1 AND 5
-- ;


-- Month over Month comparios of sales for 2022 and 2023
-- WITH CTE2 AS (WITH CTE AS (
-- SELECT DISTINCT YEAR(order_date) AS FY, MONTH(order_date) AS Mon, SUM(sale_price) AS Revenue
-- FROM df_orders
-- GROUP BY FY , Mon)
-- SELECT Mon,
-- SUM(CASE WHEN FY = 2022 THEN Revenue ELSE 0 END) AS "2022_",
-- SUM(CASE WHEN FY = 2023 THEN Revenue ELSE 0 END) AS "2023_"
-- FROM CTE
-- GROUP BY Mon
-- ORDER BY Mon) 
-- SELECT Mon, 2022_, 2023_, (2023_-2022_) AS Diff, CONCAT(ROUND(((2023_-2022_)/2022_)*100,2),"%") AS "%change"
-- FROM CTE2
-- ;



-- Each Category which month has the highest sales
-- WITH CTE AS (SELECT category, DATE_FORMAT(order_date, '%Y%m') AS Mon, SUM(sale_price) AS Revenue, RANK() OVER (PARTITION BY category ORDER BY SUM(sale_price) DESC) AS Ran
-- FROM df_orders
-- GROUP BY category, Mon
-- ORDER BY category, Revenue DESC)
-- SELECT *
-- FROM CTE
-- WHERE Ran =1;



-- Which subcategory has the highest growth by profit in 2023 compared to 2022

-- WITH CTE2 AS (WITH CTE AS (SELECT YEAR(order_date) AS FY, sub_category, SUM(sale_price) AS Revenue
-- FROM df_orders
-- GROUP BY FY, sub_category
-- ORDER BY sub_category)
-- SELECT sub_category, 
-- 	SUM((CASE WHEN FY=2022 THEN Revenue ELSE 0 END)) AS Sales_2022,
--     SUM((CASE WHEN FY=2023 THEN Revenue ELSE 0 END)) AS Sales_2023
-- FROM CTE
-- GROUP BY sub_category
-- ORDER BY sub_category)
-- SELECT *, (Sales_2023 - Sales_2022) AS Diff, ROUND(((Sales_2023 - Sales_2022)*100/Sales_2022),2) AS Growth
-- FROM CTE2
-- ORDER BY Growth DESC;