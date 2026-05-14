-- 1. Tariff-Based Customer Queries

-- 1.1 List the customers who are subscribed to the 'Kobiye Destek' tariff.
-- To find customers using a specific tariff, I joined the CUSTOMERS and TARIFFS tables based on their shared TARIFF_ID column. 
-- This approach allows us to filter the results using the tariff name 'Kobiye Destek' directly from the referenced table. 
-- I selected the core customer details such as ID, name, city, and signup date to provide a clear and comprehensive result set.
SELECT c.CUSTOMER_ID, c.NAME, c.CITY, c.SIGNUP_DATE
FROM CUSTOMERS c
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID
WHERE t.NAME = 'Kobiye Destek';


-- 1.2 Find the newest customer who subscribed to this tariff.
-- I used the exact same table join structure as the previous query to filter specifically for the 'Kobiye Destek' tariff. 
-- To identify the most recent subscriber, I sorted the joined results in descending order based on the customer's signup date. 
-- Finally, by utilizing the 'FETCH FIRST 1 ROWS ONLY' clause, I isolated and retrieved only the single newest record from the top of the sorted list.
SELECT c.CUSTOMER_ID, c.NAME, c.CITY, c.SIGNUP_DATE
FROM CUSTOMERS c
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID
WHERE t.NAME = 'Kobiye Destek'
ORDER BY c.SIGNUP_DATE DESC
FETCH FIRST 1 ROWS ONLY;


-- 2. Tariff Distribution

-- 2.1 Find the distribution of tariffs among the customers.
-- To analyze the distribution of tariffs, I performed a grouping operation based on the tariff names. 
-- I used a LEFT JOIN from the TARIFFS table to the CUSTOMERS table to ensure all available tariffs are listed in the result set, even if they currently have zero active subscribers. 
-- By applying the COUNT aggregate function on the customer IDs, I calculated the total number of users for each tariff and sorted the final output in descending order.
SELECT t.NAME AS TARIFF_NAME, COUNT(c.CUSTOMER_ID) AS TOTAL_CUSTOMERS
FROM TARIFFS t
LEFT JOIN CUSTOMERS c ON t.TARIFF_ID = c.TARIFF_ID
GROUP BY t.NAME
ORDER BY TOTAL_CUSTOMERS DESC;


-- 3. Customer Signup Analysis

-- 3.1 Identify the earliest customers to sign up.
-- Finding the absolute earliest customers requires identifying the minimum signup date present in the entire dataset. 
-- I implemented a subquery within the WHERE clause to dynamically calculate this initial date using the MIN aggregate function. 
-- The main query then retrieves all customer records that perfectly match this minimum date, effectively bypassing any assumptions related to the sequential order of customer IDs.
SELECT CUSTOMER_ID, NAME, CITY, SIGNUP_DATE
FROM CUSTOMERS
WHERE SIGNUP_DATE = (SELECT MIN(SIGNUP_DATE) FROM CUSTOMERS);


-- 3.2 Find the distribution of these earliest customers across different cities, including the total count for each city.
-- This query builds upon the previous logic by focusing specifically on the geographic distribution of our very first cohort of customers. 
-- I utilized the exact same subquery approach to filter the dataset down to only those individuals who signed up on the earliest recorded date. 
-- Subsequently, I applied a GROUP BY clause on the city column and counted the occurrences to determine the density of these pioneer customers in each city.
SELECT CITY, COUNT(CUSTOMER_ID) AS TOTAL_EARLIEST_CUSTOMERS
FROM CUSTOMERS
WHERE SIGNUP_DATE = (SELECT MIN(SIGNUP_DATE) FROM CUSTOMERS)
GROUP BY CITY
ORDER BY TOTAL_EARLIEST_CUSTOMERS DESC;



-- 4. Missing Monthly Records

-- 4.1 Identify the IDs of these missing customers.
-- To identify customers missing from the monthly statistics, I utilized a LEFT JOIN operation connecting the CUSTOMERS table to the MONTHLY_STATS table. 
-- By filtering the results with a WHERE clause checking for NULL values in the monthly stats side, we isolate the specific users who lack current month records. 
-- This approach effectively pinpoints the exact customer IDs affected by the insertion error without impacting the rest of the dataset.
SELECT c.CUSTOMER_ID, c.NAME
FROM CUSTOMERS c
LEFT JOIN MONTHLY_STATS m ON c.CUSTOMER_ID = m.CUSTOMER_ID
WHERE m.ID IS NULL;


-- 4.2 Find the distribution of these missing customers across different cities.
-- Building upon the previous logic, this query analyzes the geographic impact of the missing monthly records. 
-- I maintained the LEFT JOIN and NULL filtering to isolate the affected customers and then applied a GROUP BY clause on the city column. 
-- Finally, I used the COUNT function to determine how many missing records exist per city, ordering the results to highlight the most affected areas.
SELECT c.CITY, COUNT(c.CUSTOMER_ID) AS MISSING_RECORD_COUNT
FROM CUSTOMERS c
LEFT JOIN MONTHLY_STATS m ON c.CUSTOMER_ID = m.CUSTOMER_ID
WHERE m.ID IS NULL
GROUP BY c.CITY
ORDER BY MISSING_RECORD_COUNT DESC;


-- 5. Usage Analysis

-- 5.1 Find the customers who have used at least 75% of their data limit.
-- To determine high data consumption, I joined the CUSTOMERS, MONTHLY_STATS, and TARIFFS tables to access both usage metrics and package limits. 
-- I implemented a WHERE clause to filter for customers whose data usage is greater than or equal to 75 percent of their specific tariff's data limit. 
-- Additionally, I ensured that tariffs with a zero data limit are dynamically handled by strictly applying the mathematical percentage condition across the active limits.
SELECT c.CUSTOMER_ID, c.NAME, t.NAME AS TARIFF_NAME, m.DATA_USAGE, t.DATA_LIMIT
FROM CUSTOMERS c
JOIN MONTHLY_STATS m ON c.CUSTOMER_ID = m.CUSTOMER_ID
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID
WHERE t.DATA_LIMIT > 0 AND m.DATA_USAGE >= (t.DATA_LIMIT * 0.75);


-- 5.2 Identify the customers who have completely exhausted all of their package limits (data, minutes, and SMS).
-- This query identifies users who have maximized their entire subscription package across all communication channels. 
-- By joining the relevant tables, I compared the actual monthly usage of data, minutes, and SMS against their respective tariff limits simultaneously. 
-- The WHERE clause enforces a strict condition where all three usage metrics must be greater than or equal to the assigned limits to isolate these specific customers.
SELECT c.CUSTOMER_ID, c.NAME, m.DATA_USAGE, m.MINUTE_USAGE, m.SMS_USAGE
FROM CUSTOMERS c
JOIN MONTHLY_STATS m ON c.CUSTOMER_ID = m.CUSTOMER_ID
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID
WHERE m.DATA_USAGE >= t.DATA_LIMIT 
  AND m.MINUTE_USAGE >= t.MINUTE_LIMIT 
  AND m.SMS_USAGE >= t.SMS_LIMIT;



  -- 6. Payment Analysis

-- 6.1 Find the customers who have unpaid fees.
-- To identify customers with outstanding balances, I joined the CUSTOMERS table with the MONTHLY_STATS table using the customer ID. 
-- I applied a WHERE clause to filter specifically for records where the PAYMENT_STATUS indicates missing payments, capturing both 'LATE' and 'UNPAID' statuses. 
-- This provides a direct and accurate list of individuals who require payment follow-ups, along with their core identification details.
SELECT c.CUSTOMER_ID, c.NAME, m.PAYMENT_STATUS
FROM CUSTOMERS c
JOIN MONTHLY_STATS m ON c.CUSTOMER_ID = m.CUSTOMER_ID
WHERE m.PAYMENT_STATUS IN ('LATE', 'UNPAID');


-- 6.2 Find the distribution of all payment statuses across the different tariffs.
-- This query analyzes payment behaviors across different subscription plans by joining the TARIFFS, CUSTOMERS, and MONTHLY_STATS tables. 
-- I used a GROUP BY clause encompassing both the tariff name and the payment status to calculate the frequency of each status category per tariff. 
-- By utilizing the COUNT aggregate function, we can clearly observe whether specific tariffs experience higher volumes of late or paid statuses compared to others.
SELECT t.NAME AS TARIFF_NAME, m.PAYMENT_STATUS, COUNT(c.CUSTOMER_ID) AS STATUS_COUNT
FROM TARIFFS t
JOIN CUSTOMERS c ON t.TARIFF_ID = c.TARIFF_ID
JOIN MONTHLY_STATS m ON c.CUSTOMER_ID = m.CUSTOMER_ID
GROUP BY t.NAME, m.PAYMENT_STATUS
ORDER BY t.NAME, STATUS_COUNT DESC;