USE SAMPLE;
SELECT * FROM CUSTOMER;
SELECT * FROM ORDERS;
SELECT * FROM AGENTS;
-- -------------------------------------------------------------------------------------------------------
-- -------------------------------------------- Task Solution --------------------------------------------
-- -------------------------------------------------------------------------------------------------------
-- Q.1: selects the "Customer Name" and "City" columns from the "Customers" table.
SELECT 
	CUST_NAME,
	CUST_CITY 
FROM 
	CUSTOMER;
-- -------------------------------------------------------------------------------------------------------
-- Q.2: What is the number of different (distinct) customer countries?
SELECT 
	COUNT(DISTINCT(CUST_COUNTRY)) AS "Country_Count"
FROM 
	CUSTOMER;
-- -------------------------------------------------------------------------------------------------------
-- Q.3: selects all the customers from the country "London", in the "Customers" table:
SELECT 
	*
FROM 
	CUSTOMER
WHERE
	CUST_COUNTRY = "London";
-- -------------------------------------------------------------------------------------------------------
-- Q.4: Show the Customer information with code C00015.
SELECT 
	*
FROM
	CUSTOMER
WHERE 
	CUST_CODE = "C00015";
-- -------------------------------------------------------------------------------------------------------
-- Q.5: selects all fields from "Customers" where country is "USA" or "India".
SELECT 
	*
FROM
	CUSTOMER
WHERE 
	CUST_COUNTRY IN ("USA", "India");
	-- CUST_COUNTRY = "USA" OR CUST_COUNTRY = "India" -- ALTERNATIVE 
-- -------------------------------------------------------------------------------------------------------
-- Q.6: selects all fields from "Customers" where city is NOT "Bangalore"
SELECT 
	*
FROM
	CUSTOMER
WHERE 
	CUST_COUNTRY != "Bangalore";
	-- CUST_COUNTRY <> "Bangalore"; -- ALTERNATIVE 
	-- CUST_COUNTRY NOT IN ("Bangalore"); -- ALTERNATIVE 
-- -------------------------------------------------------------------------------------------------------
-- Q.7: selects all customers from the "Customers" table, sorted DESCENDING by the "city" column.
SELECT 
	*
FROM
	CUSTOMER
ORDER BY
	CUST_CITY DESC;
-- -------------------------------------------------------------------------------------------------------
-- Q.8: finds the biggest amount of order:
SELECT 
	MAX(ORD_AMOUNT) AS "BIGGETSAMOUNT"
FROM
	ORDERS;
-- -------------------------------------------------------------------------------------------------------
-- Q.9: finds the number of orders.
SELECT 
	COUNT(*) AS NUMBER_OF_ORDER
FROM
	ORDERS;
-- -------------------------------------------------------------------------------------------------------
-- Q.10: finds the average amount of all orders.
SELECT
	ROUND(AVG(ORD_AMOUNT)) AS AVG_AMOUNT_OF_ALL
FROM
	ORDERS;
-- -------------------------------------------------------------------------------------------------------
-- Q.11: selects all customers with a Customer Name starting with "m".
SELECT 
	*
FROM
	CUSTOMER
WHERE 
	CUST_NAME LIKE "M%";
-- -------------------------------------------------------------------------------------------------------
-- Q.12: selects all customers with a Customer Name starting with "s".
SELECT 
	*
FROM
	CUSTOMER
WHERE 
	CUST_NAME LIKE "S%";
-- -------------------------------------------------------------------------------------------------------
-- Q.13: selects all customers that are in "Australia", "USA" or "UK".
SELECT 
	*
FROM
	CUSTOMER
WHERE 
	CUST_COUNTRY IN ("Australia", "USA", "UK");
	-- CUST_COUNTRY = "Australia" OR CUST_COUNTRY = "USA" OR CUST_COUNTRY = "UK" -- ALTERNATIVE 
-- -------------------------------------------------------------------------------------------------------
-- Q.14: selects orders in January.
SELECT
	*
FROM 
	ORDERS
WHERE
	MONTHNAME(ORD_DATE) = "January";
    -- MONTH(ORD_DATE) = 1 -- ALTERNATIVE
-- -------------------------------------------------------------------------------------------------------
-- Q.15: selects the customers with amount payment between 1000 and 4000.
SELECT 
	*
FROM
	CUSTOMER
WHERE 
	PAYMENT_AMT BETWEEN 1000 AND 4000;
-- -------------------------------------------------------------------------------------------------------
-- Q.16: selects all orders with customer information.
SELECT
	*
FROM 
	ORDERS AS O
LEFT JOIN 
	CUSTOMER AS C
ON 
	O.CUST_CODE = C.CUST_CODE;
-- -------------------------------------------------------------------------------------------------------
-- Q.17: select all customers, and any orders information they might have.
SELECT
	*
FROM 
	CUSTOMER AS C
LEFT JOIN 
	ORDERS AS O
ON 
	C.CUST_CODE = O.CUST_CODE;
-- -------------------------------------------------------------------------------------------------------
-- Q.18: lists the number of customers in each country.
SELECT 
	COUNT(*) AS "NUM_OF_CUSTOMER", CUST_COUNTRY
FROM
	CUSTOMER
GROUP BY
	CUST_COUNTRY
ORDER BY 
	NUM_OF_CUSTOMER DESC;
-- -------------------------------------------------------------------------------------------------------
-- Q.19: lists the number of orders sent by each agent.
SELECT 
	COUNT(*) AS NUM_OF_ORDER , AGENT_CODE
FROM
	ORDERS
GROUP BY
	AGENT_CODE
ORDER BY
	NUM_OF_ORDER DESC;
-- -------------------------------------------------------------------------------------------------------
-- Q.20: lists the number of customers in each country. Only include countries with more than 5 customers.
SELECT 
	COUNT(*) AS "NUM_OF_CUSTOMER", CUST_COUNTRY
FROM
	CUSTOMER
GROUP BY
	CUST_COUNTRY
HAVING 
	NUM_OF_CUSTOMER > 5;
-- -------------------------------------------------------------------------------------------------------
-- -------------------------------------------- SAMIR HENDAWY --------------------------------------------
-- -------------------------------------------------------------------------------------------------------