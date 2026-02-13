/**********************************************************************/
/* SQL Queries: Practice your SQL Knowledge! */
/**********************************************************************/

/*
----Schema----
Customers (CustomerID, CustomerName, ContactName, Address, City, PostalCode, Country)
Categories (CategoryID,CategoryName, Description)
Employees (EmployeeID, LastName, FirstName, BirthDate, Photo, Notes)
OrderDetails (OrderDetailID, OrderID, ProductID, Quantity)
Orders (OrderID, CustomerID, EmployeeID, OrderDate, ShipperID)
Products(ProductID, ProductName, SupplierID, CategoryID, Unit, Price)
Shippers (ShipperID, ShipperName, Phone)
*/

/**** Advanced Level *****/
USE RETAILDB;


/**** Advanced Level *****/

/*1. Select customer name together with each order the customer made*/

-- SELECT * FROM customers;
-- SELECT * FROM orders;

SELECT 
    C.CustomerName, 
    O.OrderID, 
    O.OrderDate
FROM 
    customers AS C
LEFT JOIN 
    orders AS O
ON 
    C.CustomerID = O.CustomerID;
    
/*2. Select order id together with name of employee who handled the order*/

SELECT * FROM employees;
SELECT * FROM orders;

SELECT 
	O.OrderID,
    CONCAT(E.FirstName, " ", E.LastName) AS FULLNAME
FROM
	orders AS O
LEFT JOIN
	employees AS E
ON O.EmployeeID = E.EmployeeID;

/*3. Select customers who did not placed any order yet*/

-- SELECT * FROM customers;
-- SELECT * FROM orders;

/*SELECT 
	C.CustomerName 
FROM 
	customers AS C
LEFT JOIN 
	orders AS O
ON 
	C.CustomerID = O.CustomerID
WHERE 
	OrderID IS NULL;*/
    
SELECT 
    C.CustomerName
FROM customers C
WHERE NOT EXISTS (
    SELECT 1
    FROM orders O
    WHERE O.CustomerID = C.CustomerID
);


/*4. Select order id together with the name of products*/

-- SELECT * FROM orders;
-- SELECT * FROM products;
-- SELECT * FROM order_details;
-- I used LEFT JOIN to ensure all orders are returned even if no products are associated
/*SELECT 
    O.OrderID,
    P.ProductName
FROM orders AS O
LEFT JOIN order_details AS OD -- Bridge Table
    ON O.OrderID = OD.OrderID 
LEFT JOIN products AS P 
    ON OD.ProductID = P.ProductID;*/

SELECT 
    O.OrderID,
    P.ProductName,
    OD.Quantity
FROM orders O
INNER JOIN order_details OD
    ON O.OrderID = OD.OrderID
INNER JOIN products P
    ON OD.ProductID = P.ProductID;

    
/*5. Select products that no one bought*/

SELECT
    P.*
FROM PRODUCTS P
LEFT JOIN ORDER_DETAILS OD
    ON P.ProductID = OD.ProductID
WHERE OD.ProductID IS NULL;


/*6. Select customer together with the products that he bought*/

SELECT
    C.CustomerName,
    P.ProductName
FROM customers C
INNER JOIN Orders O -- bridge table
    ON C.CustomerID = O.CustomerID
INNER JOIN Order_details OD -- bridge table
    ON O.Orderid = OD.Orderid
INNER JOIN products P
    ON OD.productid = P.productid
ORDER BY C.CustomerName;

    
/*7. Select product names together with the name of corresponding category*/

SELECT P.ProductName , C.CategoryName
FROM Products P
LEFT JOIN categories C
ON P.CategoryID = C.CategoryID;

/*8. Select orders together with the name of the shipping company*/

SELECT O.OrderID, S.ShipperName
FROM Orders O
-- LEFT JOIN Shippers S -- complete list of orders, even if some don’t have shipping info yet.
INNER JOIN Shippers S -- only care about orders that definitely have a shipper assigned.
ON O.ShipperID = S.ShipperID;

/*9. Select customers with id greater than 50 together with each order they made*/

SELECT C.CustomerID, C.CustomerName, O.OrderID, O.OrderDate
FROM Customers C
INNER JOIN Orders O -- ensures that only customers who actually have orders are included.
ON C.CustomerID = O.CustomerID
WHERE C.CustomerID > 50;

/*10. Select employees together with orders with order id greater than 10400*/

SELECT 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName, 
    o.OrderID, 
    o.OrderDate
FROM Employees e
LEFT JOIN Orders o
ON e.EmployeeID = o.EmployeeID 
   AND o.OrderID > 104000;
-- If an employee has no matching orders, the order columns (OrderID, OrderDate) will be NULL.

/************ Expert Level ************/

/*version 1*/


/*1. Select the most expensive product*/

SELECT ProductName, Price
FROM Products
ORDER BY Price DESC -- sorts products from most expensive to cheapest.
LIMIT 1;

/*2. Select the second most expensive product*/

SELECT ProductName, Price
FROM Products
ORDER BY Price DESC
LIMIT 1 OFFSET 1; -- skips the first row (most expensive) and returns the second row.

/*version 2 (complex)*/
/*3. Select name and price of each product, sort the result by price in decreasing order*/

SELECT ProductName, Price
FROM Products
ORDER BY Price DESC;

/*4. Select 5 most expensive products*/

SELECT ProductName, Price
FROM Products
ORDER BY Price DESC
LIMIT 5;

/*5. Select 5 most expensive products without the most expensive (in final 4 products)*/

SELECT ProductName, Price
FROM Products
ORDER BY Price DESC
LIMIT 4 OFFSET 1;

/*6. Select name of the cheapest product (only name) without using LIMIT and OFFSET*/

SELECT ProductName
FROM (
    SELECT ProductName,
    RANK() OVER(ORDER BY Price ASC) AS rnk
    FROM Products
) t
WHERE rnk = 1;

/*7. Select name of the cheapest product (only name) using subquery*/

SELECT ProductName
FROM Products
WHERE Price = (SELECT MIN(Price) FROM Products); -- SubQery in WHERE clause.

/*8. Select number of employees with LastName that starts with 'D'*/

SELECT COUNT(*) AS COUNT_
FROM 
	Employees
WHERE 
	LastName LIKE "D%"; -- IF NEED CASE Senesitve LIKE BINARY 'D%';

/*9. Select customer name together with the number of orders made by the corresponding customer 
sort the result by number of orders in decreasing order*/

SELECT 
	c.CustomerName,
    COUNT(o.OrderID) AS NumberOfOrders
FROM 
	customers c
LEFT JOIN orders O
ON C.customerid = O.customerid
GROUP BY c.customerid, c.CustomerName
ORDER BY NumberOfOrders DESC;

/*10. Add up the price of all products*/

SELECT SUM(Price) AS TOTALPRICE FROM Products;

/*11. Select orderID together with the total price of  that Order, order the result by total price of order in increasing order*/

SELECT 
    O.orderid,  -- The unique identifier for each order
    COALESCE(SUM(OD.Quantity * P.Price), 0) AS TotalAmount
    -- Multiply the quantity of each product in the order by its price,
    -- then sum these values to get the total order amount.
    -- COALESCE ensures that if there are no order details (NULL), it returns 0 instead.
FROM orders O  -- The main table containing all orders
-- Join with order details to get the products and quantities for each order
LEFT JOIN Order_details OD 
    ON O.orderid = OD.orderid
    -- LEFT JOIN ensures we keep all orders even if they have no order details
-- Join with products to get the price of each product
LEFT JOIN Products P
    ON OD.productid = P.productid
    -- This allows us to calculate the total by multiplying quantity with product price
GROUP BY O.orderid
-- Group by order ID so that the SUM is calculated per order
ORDER BY TotalAmount ASC;
-- Sort the results by the total amount in ascending order

/*12. Select customer who spend the most money*/

SELECT 
    c.customerid,                                     
	c.customername,  
    COALESCE(SUM(OD.Quantity * P.Price), 0) AS TotalAmount  -- Calculate total spending; 0 if no orders
FROM customers C
LEFT JOIN orders O  
    ON C.customerid = O.customerid                  -- Join to get all orders for each customer
LEFT JOIN Order_details OD 
    ON O.orderid = OD.orderid                       -- Join to get the products and quantities in orders
LEFT JOIN Products P
    ON OD.productid = P.productid                   -- Join to get product prices for total calculation
GROUP BY c.customerid, c.customername  -- Aggregate totals per customer
ORDER BY TotalAmount DESC                            -- Sort so the highest spender comes first
LIMIT 1;                                             -- Return only the top customer

/*13. Select customer who spend the most money and lives in Canada*/

SELECT 
    c.customerid,                                
    c.customername,                                  
    COALESCE(SUM(OD.Quantity * P.Price), 0) AS TotalAmount  
FROM customers C
LEFT JOIN orders O  
    ON C.customerid = O.customerid                  
LEFT JOIN Order_details OD 
    ON O.orderid = OD.orderid                         
LEFT JOIN Products P
    ON OD.productid = P.productid                    
WHERE C.Country = "Canada"                           -- Filter customers in Canada **before aggregation**
GROUP BY c.customerid, c.customername                -- Aggregate totals per customer
ORDER BY TotalAmount DESC                             -- Sort by highest spender
LIMIT 1;                                             -- Return only the top customer

/*14. Select customer who spend the second most money*/


SELECT 
    c.customerid,                                     
    c.customername,                                 
    COALESCE(SUM(OD.Quantity * P.Price), 0) AS TotalAmount  -- Total money spent; 0 if no orders
FROM customers C
LEFT JOIN orders O  
    ON C.customerid = O.customerid                   
LEFT JOIN Order_details OD 
    ON O.orderid = OD.orderid                       
LEFT JOIN Products P
    ON OD.productid = P.productid                   
GROUP BY c.customerid, c.customername               
ORDER BY TotalAmount DESC                            
LIMIT 1 OFFSET 1;                                    -- Skip the top spender and get the second-highest


/*15. Select shipper together with the total price of proceed orders*/

SELECT 
    s.Shipperid,                                      -- Shipper's unique ID
    s.Shippername,                                    -- Shipper's name
    COALESCE(SUM(OD.Quantity * P.Price), 0) AS TotalAmount  -- Total value of all orders processed by this shipper; 0 if none
FROM Shippers s
LEFT JOIN orders O  
    ON s.Shipperid = O.Shipperid                   -- Join to get all orders handled by the shipper
LEFT JOIN Order_details OD 
    ON O.orderid = OD.orderid                       -- Join to get products and quantities in each order
LEFT JOIN Products P
    ON OD.productid = P.productid                   -- Join to get product prices for total calculation
GROUP BY s.Shipperid, s.Shippername;               -- Aggregate total order amount per shipper

                        
