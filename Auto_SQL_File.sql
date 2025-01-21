-- importing the table 
-- 2.	Identify and handle missing values in critical columns.
SELECT 
    Quantityordered,
    priceeach,
    sales,
    orderlinenumber,
    orderdate,
    productline,
    customername,
    dealsize
FROM
    auto_sales
WHERE
    sales IS NULL OR orderdate IS NULL
        OR dealsize IS NULL; 
-- selecting the table
select * from auto_sales;
--	Data Standardization
alter table auto_sales rename column productline to PRODUCT;
alter table auto_sales drop column ADDRESSLINE1;

-- Normalizing crucial columns.
alter table auto_sales add column DATE text;
-- copying the values in orderdate into date column to have duplicate of the data.
update auto_sales set DATE = ORDERDATE;
-- changing the datatype in the date column 
update auto_sales set DATE = date_format(str_to_date(DATE, '%d/%m/%Y'), '%Y/%m/%d'); 
-- change the datatype of the date column and rename it
alter table auto_sales modify column DATE date; 
alter table auto_sales drop column ORDERDATE;
alter table auto_sales rename column DATE to ORDERDATE;


-- Exploratory Data Analysis (EDA) (SQL)
-- 1.	What are the top-selling product lines, and how much revenue do they generate?
SELECT 
    PRODUCT, SUM(sales)as Total_Revenue
FROM
    auto_sales
GROUP BY PRODUCT
ORDER BY Total_Revenue DESC limit 5;

-- 2.	Which countries or cities contribute the most to total sales?
SELECT 
    CITY, SUM(sales) AS Total_Sales, COUNT(city)
FROM
    auto_sales
GROUP BY city
ORDER BY Total_Sales desc; 

select count(distinct(city)) from auto_sales;

-- 3.	What are the monthly or yearly sales trends?
SELECT 
    DATE_FORMAT(ORDERDATE, '%Y-%m') AS Month, 
    SUM(SALES) AS Total_Sales
FROM auto_sales
GROUP BY DATE_FORMAT(ORDERDATE, '%Y-%m')
ORDER BY Total_Sales desc;

-- Yearly sales trends
SELECT 
    YEAR(ORDERDATE) AS Year, 
    SUM(SALES) AS Total_Sales
FROM auto_sales
GROUP BY YEAR(ORDERDATE)
ORDER BY Year desc;


-- 4.	Who are the top customers contributing the most to revenue?
SELECT 
    customername, SUM(sales) AS Total_sales
FROM
    auto_sales
GROUP BY customername
ORDER BY Total_sales DESC limit 5;
-- 5.	How does deal size (DEALSIZE) impact product line sales?
SELECT 
    DEALSIZE, product, SUM(sales) AS Total_sales
FROM
    auto_sales
GROUP BY dealsize , product
ORDER BY Total_sales desc;