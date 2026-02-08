

# Q8. Listwise Deletion 
# Remove all rows where Region is missing.

#Tasks:
# 1. Identify affected rows
# 2. Show the dataset after deletion
# 3. Mention how many records were lost

CREATE TABLE Customer_Sales (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    City VARCHAR(50),
    Monthly_Sales DECIMAL(10, 2), -- NULL allows for missing values
    Income DECIMAL(10, 2),        -- NULL allows for missing values
    Region VARCHAR(50)            -- NULL allows for missing values
);


INSERT INTO Customer_Sales (Customer_ID, Name, City, Monthly_Sales, Income, Region)
VALUES 
(101, 'Rahul Mehta', 'Mumbai', 12000, 65000, 'West'),
(102, 'Anjali Rao', 'Bengaluru', NULL, NULL, 'South'),
(103, 'Suresh Iyer', 'Chennai', 15000, 72000, 'South'),
(104, 'Neha Singh', 'Delhi', NULL, NULL, 'North'),
(105, 'Amit Verma', 'Pune', 18000, 58000, NULL),
(106, 'Karan Shah', 'Ahmedabad', NULL, 61000, 'West'),
(107, 'Pooja Das', 'Kolkata', 14000, NULL, 'East'),
(108, 'Riya Kapoor', 'Jaipur', 16000, 69000, 'North');

select * from customer_sales;

SELECT * FROM Customer_Sales 
WHERE Region IS NULL;

SELECT * FROM Customer_Sales 
WHERE Region IS NOT NULL;

SELECT COUNT(*) AS Records_Lost 
FROM Customer_Sales 
WHERE Region IS NULL;


#Q9. Imputation 
#Handle missing values in Monthly_Sales using:

#Tasks:

# 1. Apply forward fill
# 2. Show before vs after values
# 3. Explain why forward fill is suitable here


SELECT Customer_ID, Name, Monthly_Sales
FROM Customer_sales
ORDER BY Customer_ID;

SELECT
    Customer_ID,
    Name,
    Monthly_Sales AS Before_Imputation,
    LAST_VALUE(Monthly_Sales) IGNORE NULLS
        OVER (ORDER BY Customer_ID
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
        AS After_Forward_Fill
FROM Customer_sales
ORDER BY Customer_ID;

# 3. Why Forward Fill is Suitable Here

# - Monthly sales often follow sequential or time-based patterns
# - The previous customer’s sales value provides a reasonable estimate
# - Prevents data loss compared to deletion
# - Maintains trend continuity in sales analysis
# - Simple and effective for small gaps in numeric data

# Q10. Flagging Missing Data
# Create a flag column for missing Income.

# Tasks:

# 1. Create Income_Missing_Flag (0 = present, 1 = missing)
# 2. Show updated dataset
# 3. Count how many customers have missing income

ALTER TABLE Customer_sales
ADD Income_Missing_Flag INT;

set sql_safe_updates = 0 ;
UPDATE Customer_sales
SET Income_Missing_Flag =
    CASE
        WHEN Income IS NULL THEN 1
        ELSE 0
    END;
    
    SELECT
    Customer_ID,
    Name,
    Income,
    Income_Missing_Flag
FROM Customer_sales
ORDER BY Customer_ID;

SELECT COUNT(*) AS Missing_Income_Count
FROM Customer_sales
WHERE Income_Missing_Flag = 1;




