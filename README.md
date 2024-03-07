EDA on Zomato Dataset in SSMS

# Introduction

SQL stands for Structured Query Language. It is the standard language to
interact with databases and a data analyst uses to manipulate and gain insights
from the data. For this project, I will try to process, and analyze the Zomato’s
Dataset from [Kaggle](<https://www.kaggle.com/datasets/rabhar/zomato-restaurants-in-india?resource=download>)

# Dataset

So now let’s get the **shape** of the data, this will return all the rows and
columns present in the table.

The dataset has **211944** rows and **27** columns.

![](images/1dbcc905e416ed3c5aa1b538fc9f5b93.png)![](images/1b7127e55577e2730b992539bea08454.png)

# Let’s answer some questions

### Get top 10 cities with average cost for 2 people and also number of entries for each city

### 1. Get top 10 cities with average cost for 2 people and also number of entries for each city
~~~~sql
SELECT TOP 10 
	city,
	ROUND(AVG(average_cost_for_two),2) AS avg_cost_for_2, 
	ROUND(AVG(aggregate_rating),2) AS avg_rating,
	COUNT(*) AS total_enteries
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
GROUP BY city
ORDER BY avg_cost_for_2 DESC
~~~~
### ![](images/4bde20ed1a319d765d344b3c00afb029.png)

### 2. Get bottom 10 cities with average cost for 2 people and also number of entries for each city
~~~~sql
SELECT TOP 10 
	city,
	ROUND(AVG(average_cost_for_two),2) AS avg_cost_for_2, 
	ROUND(AVG(aggregate_rating),2) AS avg_rating,
	COUNT(*) AS total_enteries
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
GROUP BY city
ORDER BY avg_cost_for_2 ASC
~~~~
![](images/74023b9e07632cb6f9240e1e5c4b3466.png)

### 3. Cities ranked as per the most number of locations Zomato is in operation
~~~~sql
SELECT TOP 10 
	city,
	COUNT(DISTINCT(locality)) AS No_of_localities 
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
GROUP BY city
ORDER BY No_of_localities DESC
~~~~
![](images/3fbaa422fb4ad15acb8d9311551d47b8.png)

### 4. Let’s check out the Top 10 restaurant chains
~~~~sql
SELECT TOP 10 
	name,
	COUNT(*) AS No_of_outlets 
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
GROUP BY name
ORDER BY No_of_outlets DESC
~~~~
![](images/e767130c3da92e222b43e47d555c56c7.png)

### 5. Popular Casual Dining places and their ratings in Bangalore
~~~~sql
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
~~~~
![](images/80e39d268a25e73598505c2c766459b5.png)

### 6. Popular Bars and their ratings in Bangalore
~~~~sql
SELECT TOP 5 
	name,
	ROUND(AVG(aggregate_rating),2) AS avg_rating,
	COUNT(aggregate_rating) AS numberofratings
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
WHERE city='Bangalore' AND establishment_cleaned = 'Bar'
GROUP BY name
ORDER BY numberofratings DESC
~~~~
![](images/5263013351474513ab8d81e371d4c232.png)

### 7. Let’s check out the Top 10 restaurant chains in Bangalore
~~~~sql
SELECT TOP 10 
	name,
	COUNT(*) AS No_of_outlets 
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
WHERE city='Bangalore'
GROUP BY city, name
ORDER BY No_of_outlets DESC
~~~~
![](images/42b54599599baf18a2e1e1a721a4345a.png)

### 8. Let’s check out the Top 10 establishments and ratings in Bangalore
~~~~sql
	establishment_cleaned,
	COUNT(*) AS No_of_outlets,
	ROUND(AVG(aggregate_rating),2) AS avg_rating
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
WHERE city='Bangalore'
GROUP BY city, establishment_cleaned
ORDER BY avg_rating DESC
~~~~
![](images/a67fc6c7f6b018ce58a00b9bd779553e.png)

### 9. where can we find the best Pizza in Bangalore, also those restaurants having at least 10 ratings given for them
~~~~sql
SELECT name, AVG(aggregate_rating) AS avg_rating
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
WHERE city='Bangalore' AND cuisines LIKE '%Pizza%' AND rating_text = 'Excellent'
GROUP BY city, name
HAVING COUNT(aggregate_rating) >= 10
ORDER BY avg_rating DESC
~~~~
![](images/f2778d315505d5c20a3f80225108ad66.png)

### 10. Top rated Pure Veg restaurants in Bangalore, also those having at least 10 ratings given for them
~~~~sql
SELECT TOP 5 name,locality, AVG(aggregate_rating) AS avg_rating
FROM ZOMATO_DATABASE_EDA..ZOMATO_DATASET_INDIA
WHERE city='Bangalore' AND establishment_cleaned = 'Casual Dining' AND highlights LIKE '%Pure Veg%' AND rating_text = 'Excellent' 
GROUP BY city, name, locality
HAVING COUNT(aggregate_rating) >= 10
ORDER BY avg_rating DESC
~~~~
![](images/d4db35ef9f1d748bbc2fce9ffc8e0c1b.png)
