/* =========================================================
   SQL Subqueries Practice
   Description: Practical examples of different types of
   subqueries in MySQL for data analysis scenarios.
   ========================================================= */
USE ecommercedb;

/* =========================================================
   PART 1 – Subquery in WHERE
   ========================================================= */

/* ---------------------------------------------------------
   1) Return customers who made more than 5 orders.
      Show full customer name and number of orders.
   --------------------------------------------------------- */

SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    
    -- Subquery to count number of orders for each customer
    (SELECT COUNT(*) 
     FROM Orders o 
     WHERE o.CustomerID = c.CustomerID) AS OrderCount

FROM Customers c

-- Filter customers who have more than 5 orders
WHERE c.CustomerID IN (
        SELECT CustomerID
        FROM Orders
        GROUP BY CustomerID
        HAVING COUNT(*) > 5
);


/* ---------------------------------------------------------
   2) Return products that have a price greater than
      the average product price.
   --------------------------------------------------------- */

SELECT 
    ProductName,
    Price
FROM Products

-- Compare each product price to overall average price
WHERE Price > (
        SELECT AVG(Price)
        FROM Products
);


/* ---------------------------------------------------------
   3) Return orders where total amount is greater than
      the average order amount.
   --------------------------------------------------------- */

SELECT *
FROM Orders

-- Compare each order to average order value
WHERE TotalAmount > (
        SELECT AVG(TotalAmount)
        FROM Orders
);


/* ---------------------------------------------------------
   4) Return customers who never made any orders.
   --------------------------------------------------------- */

SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName
FROM Customers c

-- NOT EXISTS checks if no related rows exist in Orders
WHERE NOT EXISTS (
        SELECT 1
        FROM Orders o
        WHERE o.CustomerID = c.CustomerID
);


/* ---------------------------------------------------------
   5) Return products that were never ordered.
   --------------------------------------------------------- */

SELECT 
    p.ProductName
FROM Products p

-- Check if product does not exist in OrderDetails
WHERE NOT EXISTS (
        SELECT 1
        FROM OrderDetails od
        WHERE od.ProductID = p.ProductID
);



/* =========================================================
   PART 2 – Subquery in SELECT
   ========================================================= */

/* ---------------------------------------------------------
   6) Show each customer with total number of orders.
      (Subquery inside SELECT)
   --------------------------------------------------------- */

SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS FullName,

    -- Count orders per customer
    (SELECT COUNT(*)
     FROM Orders o
     WHERE o.CustomerID = c.CustomerID) AS OrderCount

FROM Customers c;


/* ---------------------------------------------------------
   7) Show each product with total quantity sold.
      (Subquery inside SELECT)
   --------------------------------------------------------- */

SELECT 
    p.ProductName,

    -- Sum quantity sold for each product
    (SELECT SUM(od.Quantity)
     FROM OrderDetails od
     WHERE od.ProductID = p.ProductID) AS TotalQuantitySold

FROM Products p;



/* =========================================================
   PART 3 – Subquery in FROM (Derived Table)
   ========================================================= */

/* ---------------------------------------------------------
   8) Return top 5 best-selling products
      based on total quantity sold.
   --------------------------------------------------------- */

SELECT *
FROM (
        -- Derived table calculating total sold per product
        SELECT 
            p.ProductID,
            p.ProductName,
            SUM(od.Quantity) AS TotalSold
        FROM OrderDetails od
        INNER JOIN Products p 
            ON p.ProductID = od.ProductID
        GROUP BY p.ProductID, p.ProductName
     ) AS SalesData

ORDER BY TotalSold DESC
LIMIT 5;


/* ---------------------------------------------------------
   9) Calculate total sales per category.
   --------------------------------------------------------- */

SELECT 
    t.CategoryID,
    SUM(t.Total) AS TotalCategorySales
FROM (
        -- Calculate line total for each order item
        SELECT 
            sc.CategoryID,
            (od.Quantity * od.UnitPrice) AS Total
        FROM categories c
        INNER JOIN subcategories sc
			on c.CategoryID = sc.CategoryID
		INNER JOIN Products p
            ON sc.SubcategoryID = p.SubcategoryID
		INNER JOIN orderdetails OD
			ON P.productid = OD.productid
     ) AS t
GROUP BY t.CategoryID;



/* =========================================================
   PART 4 – Correlated Subqueries
   ========================================================= */

/* ---------------------------------------------------------
   10) Return products priced higher than the average
       price of products in the same category.
   --------------------------------------------------------- */

SELECT 
    p.ProductName,
    p.Price,
    c.CategoryName
FROM Products p
LEFT JOIN Subcategories sc
    ON p.SubcategoryID = sc.SubcategoryID
LEFT JOIN Categories c
    ON sc.CategoryID = c.CategoryID

-- Correlated subquery (depends on outer query category)
WHERE p.Price > (
        SELECT AVG(p2.Price)
        FROM Products p2
        LEFT JOIN Subcategories sc2
            ON p2.SubcategoryID = sc2.SubcategoryID
        WHERE sc2.CategoryID = sc.CategoryID
);


/* ---------------------------------------------------------
   11) Return customers whose total spending is higher
       than the average spending of all customers.
   --------------------------------------------------------- */

SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName
FROM Customers c

-- Compare customer's total spending
WHERE (
        SELECT SUM(o.TotalAmount)
        FROM Orders o
        WHERE o.CustomerID = c.CustomerID
      ) > (

        -- Calculate average spending per customer
        SELECT AVG(TotalPerCustomer)
        FROM (
                SELECT SUM(TotalAmount) AS TotalPerCustomer
                FROM Orders
                GROUP BY CustomerID
             ) AS AvgSpending
);



/* =========================================================
   BONUS – Advanced Level
   ========================================================= */

/* ---------------------------------------------------------
   12) For each category, return the most expensive product.
   --------------------------------------------------------- */

SELECT 
    c.CategoryName,
    p.ProductName,
    p.Price

FROM Categories c
INNER JOIN Subcategories sc
    ON c.CategoryID = sc.CategoryID
INNER JOIN Products p
    ON sc.SubcategoryID = p.SubcategoryID

-- Only return product whose price equals
-- the maximum price within the same category
WHERE p.Price = (
        SELECT MAX(p2.Price)
        FROM Products p2
        INNER JOIN Subcategories sc2
            ON p2.SubcategoryID = sc2.SubcategoryID
        WHERE sc2.CategoryID = c.CategoryID
);
