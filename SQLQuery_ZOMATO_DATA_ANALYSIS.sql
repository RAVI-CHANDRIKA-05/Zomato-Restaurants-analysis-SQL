/*
    Filename: SQLQuery_ZOMATO_DATA_ANALYSIS.sql
    Author: RAVI CHANDRIKA B
    Date: 05/04/2022
    Description:This SQL file contains some queries for EDA on ZOMATO DATASET
*/



-- Let's have a look at the data. This query will retrieve all the data from the table.
-- HOW MANY ROWS ARE IN THE DATASET
SELECT COUNT(*) AS Number_Of_Columns 
FROM information_schema.columns WHERE table_name='ZOMATO_DATASET_INDIA' 
--------------------------------------------------------------------------------------------------------------------------------------
-- Now let's find out the number of rows.
SELECT COUNT(*) AS Number_Of_Rows
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
--------------------------------------------------------------------------------------------------------------------------------------
-- Let's have a look at the data. This query will retrieve all the data from the table.
SELECT * FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
--------------------------------------------------------------------------------------------------------------------------------------
-- Get top 10 cities with average cost for 2 people and also number of entries for each city
SELECT TOP 10 
	city,
	ROUND(AVG(average_cost_for_two),2) AS avg_cost_for_2, 
	ROUND(AVG(aggregate_rating),2) AS avg_rating,
	COUNT(*) AS total_enteries
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
GROUP BY city
ORDER BY avg_cost_for_2 DESC

--------------------------------------------------------------------------------------------------------------------------------------
-- Get bottom 10 cities with average cost for 2 people and also number of entries for each city
SELECT TOP 10 
	city,
	ROUND(AVG(average_cost_for_two),2) AS avg_cost_for_2, 
	ROUND(AVG(aggregate_rating),2) AS avg_rating,
	COUNT(*) AS total_enteries
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
GROUP BY city
ORDER BY avg_cost_for_2 ASC
--------------------------------------------------------------------------------------------------------------------------------------
-- Cities ranked as per the most number of locations Zomato is in operation
SELECT TOP 10 
	city,
	COUNT(DISTINCT(locality)) AS No_of_localities 
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
GROUP BY city
ORDER BY No_of_localities DESC
--------------------------------------------------------------------------------------------------------------------------------------
--Let’s check out the Top 10 restaurant chains 
SELECT TOP 10 
	name,
	COUNT(*) AS No_of_outlets 
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
GROUP BY name
ORDER BY No_of_outlets DESC
--------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA 
ADD establishment_cleaned VARCHAR(100)

UPDATE ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA SET
	establishment_cleaned = TRIM('['']' FROM establishment)

-- Popular Casual Dining places and their ratings in Bangalore
SELECT TOP 5 
	name,
	ROUND(AVG(aggregate_rating),2) AS avg_rating,
	COUNT(aggregate_rating) AS numberofratings
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
WHERE city='Bangalore' AND  establishment_cleaned = 'Casual Dining'
GROUP BY name
ORDER BY numberofratings DESC
--------------------------------------------------------------------------------------------------------------------------------------
-- Popular Bars and their ratings in Bangalore
SELECT TOP 5 
	name,
	ROUND(AVG(aggregate_rating),2) AS avg_rating,
	COUNT(aggregate_rating) AS numberofratings
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
WHERE city='Bangalore' AND establishment_cleaned = 'Bar'
GROUP BY name
ORDER BY numberofratings DESC
--------------------------------------------------------------------------------------------------------------------------------------
SELECT TOP 5 
	name,
	ROUND(AVG(aggregate_rating),2) AS avg_rating
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
WHERE establishment_cleaned = 'Lounge'
GROUP BY name
ORDER BY avg_rating DESC
--------------------------------------------------------------------------------------------------------------------------------------
--Let’s check out the Top 10 restaurant chains in Bangalore
SELECT TOP 10 
	name,
	COUNT(*) AS No_of_outlets 
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
WHERE city='Bangalore'
GROUP BY city, name
ORDER BY No_of_outlets DESC
--------------------------------------------------------------------------------------------------------------------------------------
--Let’s check out the Top 10 establishments and ratings in Bangalore
SELECT TOP 10 
	establishment_cleaned,
	COUNT(*) AS No_of_outlets,
	ROUND(AVG(aggregate_rating),2) AS avg_rating
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
WHERE city='Bangalore'
GROUP BY city, establishment_cleaned
ORDER BY avg_rating DESC
--------------------------------------------------------------------------------------------------------------------------------------
--where can we find the best Pizza in Bangalore, also those restaurants having at least 10 ratings given for them

SELECT name, AVG(aggregate_rating) AS avg_rating
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
WHERE city='Bangalore' AND cuisines LIKE '%Pizza%' AND rating_text = 'Excellent'
GROUP BY city, name
HAVING COUNT(aggregate_rating) >= 10
ORDER BY avg_rating DESC
--------------------------------------------------------------------------------------------------------------------------------------
--Top rated Pure Veg restaurants in Bangalore, also those having at least 10 ratings given for them
SELECT TOP 5 name,locality, AVG(aggregate_rating) AS avg_rating
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
WHERE city='Bangalore' AND establishment_cleaned = 'Casual Dining' AND highlights LIKE '%Pure Veg%' AND rating_text = 'Excellent' 
GROUP BY city, name, locality
HAVING COUNT(aggregate_rating) >= 10
ORDER BY avg_rating DESC
--------------------------------------------------------------------------------------------------------------------------------------
