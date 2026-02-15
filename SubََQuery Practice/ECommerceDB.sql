CREATE DATABASE ECommerceDB;
USE ECommerceDB;

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

-- Products Table
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL,
    SubcategoryID INT
);

-- Categories Table
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

-- Subcategories Table
CREATE TABLE Subcategories (
    SubcategoryID INT AUTO_INCREMENT PRIMARY KEY,
    SubcategoryName VARCHAR(100) NOT NULL,
    CategoryID INT NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Add foreign key constraint to Products
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Subcategories FOREIGN KEY (SubcategoryID) REFERENCES Subcategories(SubcategoryID);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert sample Categories
INSERT INTO Categories (CategoryName)
VALUES ('Electronics'), ('Accessories');

-- Insert sample Subcategories
INSERT INTO Subcategories (SubcategoryName, CategoryID)
VALUES 
('Laptops', 1),
('Smartphones', 1),
('Headphones', 2),
('Monitors', 1);

-- Insert sample Customers (100)
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address)
SELECT 
    CONCAT('FirstName', id),
    CONCAT('LastName', id),
    CONCAT('user', id, '@example.com'),
    CONCAT('123-456-', LPAD(id, 4, '0')),
    CONCAT(id, ' Sample Street, City, Country')
FROM (
    SELECT @row := @row + 1 AS id
    FROM (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
          UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t1,
         (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
          UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t2,
         (SELECT @row := 0) r
    LIMIT 100
) a;

-- Insert sample Products (100)
INSERT INTO Products (ProductName, Description, Price, StockQuantity, SubcategoryID)
SELECT 
    CONCAT('Product ', id),
    CONCAT('Description for Product ', id),
    ROUND(RAND() * 1000, 2),
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + RAND() * 4)
FROM (
    SELECT @p := @p + 1 AS id
    FROM (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
          UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t1,
         (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
          UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t2,
         (SELECT @p := 0) r
    LIMIT 100
) b;

-- Stored Procedure: Generate 1000 random transactions
DELIMITER //

CREATE PROCEDURE GenerateRandomOrders(IN numberOfOrders INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE randomCustomer INT;
    DECLARE randomProduct INT;
    DECLARE productPrice DECIMAL(10,2);
    DECLARE randomQuantity INT;
    DECLARE orderTotal DECIMAL(10,2);
    DECLARE newOrderID INT;

    WHILE i < numberOfOrders DO
        SET randomCustomer = FLOOR(1 + (RAND() * 100));
        SET orderTotal = 0;

        -- Insert order
        INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
        VALUES (randomCustomer, DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY), 0.00);

        SET newOrderID = LAST_INSERT_ID();

        -- Insert between 1–5 order items
        SET @detailCount = FLOOR(1 + RAND() * 5);
        SET @j = 0;
        WHILE @j < @detailCount DO
            SET randomProduct = FLOOR(1 + (RAND() * 100));
            SELECT Price INTO productPrice FROM Products WHERE ProductID = randomProduct LIMIT 1;
            SET randomQuantity = FLOOR(1 + (RAND() * 5));
            INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
            VALUES (newOrderID, randomProduct, randomQuantity, productPrice);
            SET orderTotal = orderTotal + (randomQuantity * productPrice);
            SET @j = @j + 1;
        END WHILE;

        -- Update order total
        UPDATE Orders SET TotalAmount = orderTotal WHERE OrderID = newOrderID;

        SET i = i + 1;
    END WHILE;
END;
//
DELIMITER ;

-- Call procedure to generate 1000 orders
CALL GenerateRandomOrders(1000);

-- Create view: ProductSalesSummary
CREATE VIEW ProductSalesSummary AS
SELECT 
    P.ProductID,
    P.ProductName,
    SUM(OD.Quantity) AS TotalQuantitySold,
    SUM(OD.Quantity * OD.UnitPrice) AS TotalRevenue
FROM Products P
JOIN OrderDetails OD ON P.ProductID = OD.ProductID
GROUP BY P.ProductID;

-- Create view: TopSpendingCustomers
CREATE VIEW TopSpendingCustomers AS
SELECT 
    C.CustomerID,
    C.FirstName,
    C.LastName,
    SUM(O.TotalAmount) AS TotalSpent
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID
ORDER BY TotalSpent DESC
LIMIT 10;