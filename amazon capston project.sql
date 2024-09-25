create database amazon_project;
use amazon_project;

--- data cleaning 
select * from amazon;

--- changing the column name
ALTER TABLE amazon
CHANGE COLUMN `Customer type` customer_type VARCHAR(255);

ALTER TABLE amazon
CHANGE COLUMN `Product line` product_line VARCHAR(255);

ALTER TABLE amazon
CHANGE COLUMN `Unit price` unit_price float;

ALTER TABLE amazon
CHANGE COLUMN `Tax 5%` tax_percentage float;

ALTER TABLE amazon
CHANGE COLUMN `gross margin percentage` gross_margin_percentage float;

ALTER TABLE amazon
CHANGE COLUMN `gross income` gross_income float;

--- adding the data for better analysis 

--- adding the month column 
--- this colum will add the month name on which the purchase is made 

alter table amazon
add column month_name varchar(30);

set sql_safe_updates=0;

update amazon 
set month_name = monthname(date);

--- adding the time_of_day column

alter table amazon
add column time_of_day varchar(30);

update amazon 
set time_of_day = 
case
when time between 5 and 11 then 'morning'
when time between 12 and 16 then 'afternoon'
when time between 17 and 20 then 'evening'
else 'night'
end;

--- adding the day column 

alter table amazon 
add column day_name varchar(30);

update amazon 
set day_name = dayname(date);


--- Exploratory data analysis

--- 1. count of distinct cities in the dataset?
SELECT COUNT(DISTINCT City) AS DistinctCityCount
FROM amazon;

--- 2. corresponding city For each branch
SELECT DISTINCT Branch, City
FROM amazon;

--- 3.  count of distinct product lines in the dataset
SELECT COUNT(DISTINCT Product_Line)
FROM amazon;

--- 4. payment method occurs most frequently
SELECT Payment, COUNT(*) 
FROM amazon
GROUP BY Payment
ORDER BY COUNT(*) DESC
LIMIT 1;

--- 5. highest sales product line
SELECT Product_Line, SUM(TOTAL) AS TotalSales
FROM AMAZON
GROUP BY Product_Line
ORDER BY TotalSales DESC
LIMIT 1;

--- 6. revenue is generated each month
SELECT  MONTH_name, SUM(Total) AS TotalRevenue
FROM amazon
GROUP BY MONTH_name
ORDER BY month_name;

--- 7. In which month did the cost of goods sold reach its peak
SELECT Month_name, SUM(COGS) AS TotalCOGS
FROM amazon
GROUP BY Month_name
ORDER BY TotalCOGS DESC
LIMIT 1;


--- 8. product line generated the highest revenue
SELECT Product_Line, SUM(TOTAL) AS TotalSales
FROM AMAZON
GROUP BY Product_Line
ORDER BY TotalSales DESC
LIMIT 1;

--- 9. In which city was the highest revenue recorded
SELECT city, SUM(TOTAL) AS TotalSales
FROM AMAZON
GROUP BY city
ORDER BY TotalSales DESC
LIMIT 1;

--- 10. product line incurred the highest Value Added Tax
SELECT Product_Line, SUM(TAX_PERCENTAGE) AS TotalVAT
FROM AMAZON
GROUP BY Product_Line
ORDER BY TotalVAT DESC
LIMIT 1;

--- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
SELECT *,
CASE
WHEN Total > (SELECT AVG(Total) FROM AMAZON) THEN 'Good'
ELSE 'Bad'
END AS SalesStatus
FROM AMAZON;

--- 12. the branch that exceeded the average number of products sold
SELECT Branch, SUM(Quantity) AS total_quantity
FROM AMAZON
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM AMAZON);

--- 13. product line is most frequently associated with each gender
SELECT Gender, Product_line, COUNT(*) AS Frequency
FROM AMAZON
GROUP BY Gender, Product_line;

--- 14. average rating for each product line.
SELECT Product_line, AVG(Rating) AS AverageRating
FROM AMAZON
GROUP BY Product_line;

--- 15. Count the sales occurrences for each time of day on every weekday.
select time_of_day, day_name, count(*)
from amazon 
group by  time_of_day, day_name 
order by  count(*) ;

--- 16. customer type contributing the highest revenue.
SELECT Customer_Type, SUM(Total) AS TotalRevenue
FROM amazon
GROUP BY Customer_Type
ORDER BY TotalRevenue DESC
limit 1 ;

--- 17. the city with the highest VAT percentage.
SELECT City, SUM(tax_percentage) AS TotalVAT, SUM(total) AS TotalSalesAmount
FROM amazon
GROUP BY City;

--- 18. customer type with the highest VAT payments.
SELECT Customer_Type, SUM(tax_percentage) AS TotalVATPayments
FROM amazon
GROUP BY Customer_Type
ORDER BY TotalVATPayments DESC
LIMIT 1;

--- 19. count of distinct customer types in the dataset
SELECT COUNT(DISTINCT CustomerType) 
FROM amazon;

--- 20. count of distinct payment methods in the dataset
SELECT COUNT(DISTINCT Payment)
FROM amazon;

--- 21. Which customer type occurs most frequently?
SELECT Customer_Type, COUNT(*) AS Frequency
FROM amazon
GROUP BY Customer_Type
ORDER BY Frequency DESC
LIMIT 1;

--- 22. customer type with the highest purchase frequency.
SELECT Customer_Type, COUNT(*) 
FROM amazon
GROUP BY Customer_Type
ORDER BY COUNT(*)  DESC
LIMIT 1;

--- 23. Determine the predominant gender among customers.
SELECT Gender, COUNT(*) AS GenderCount
FROM amazon
GROUP BY Gender
ORDER BY GenderCount DESC
LIMIT 1;

--- 24.  the distribution of genders within each branch.
SELECT Branch, Gender, COUNT(*) AS GenderCount
FROM amazon
GROUP BY Branch, Gender
ORDER BY Branch, Gender;

--- 25. the time of day when customers provide the most ratings.
SELECT Time_Of_Day, COUNT(*) AS RatingCount
FROM amazon
GROUP BY Time_Of_Day
ORDER BY RatingCount DESC
LIMIT 1;

--- 26. the time of day with the highest customer ratings for each branch.
SELECT Branch, Time_Of_Day, COUNT(*) AS RatingCount
FROM amazon
GROUP BY Branch, Time_Of_Day
ORDER BY Branch, RatingCount DESC;

--- 27. the day of the week with the highest average ratings.
SELECT Day_name, sum(rating) AS AvgRating
FROM amazon
GROUP BY Day_name
ORDER BY AvgRating DESC
LIMIT 1;

--- 28. the day of the week with the highest average ratings for each branch.
SELECT Branch, day_name, AVG(Rating) AS AvgRating
FROM amazon
GROUP By Branch, day_name
ORDER BY Branch, AvgRating DESC;

--- The end















select * from amazon;
SELECT count(*)
FROM amazon;

SELECT name
FROM amazon;


SELECT  Product_line, round(sum(total)), round(AVG(Rating), 2) AS AverageRating, round(SUM(TAX_PERCENTAGE))AS TotalVAT
FROM AMAZON
GROUP BY Product_line
order by sum(total), TotalVAT desc;

select branch, product_line, round(sum(total)) from amazon 
group by Branch, product_line 
order by sum(total) desc;


SELECT City, round(SUM(total)) AS TotalSalesAmount
FROM amazon
GROUP BY City;


select day_name, round(sum(total)) from amazon 
group by day_name
order by sum(total) desc
limit 1 ;

select time_of_day, count(Quantity) from amazon 
group by time_of_day 
order by count(Quantity) desc ;


SELECT gender, round(sum(Total))AS TotalRevenue
FROM amazon
GROUP BY gender
ORDER BY TotalRevenue DESC
limit 2;

