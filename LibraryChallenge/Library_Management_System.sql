/*******************************************************************************
    Project: Library Management System
    Author: Samir Hendawy
    Date: 2026
    Description: Comprehensive SQL scripts for library operations including 
                 inventory tracking, loan management, and statistical reporting.
*******************************************************************************/
-- 1.1. Database Initialization
USE ProLibraryDB;

/*******************************************************
    SECTION 1.2: General Inventory Overview
    Goal: Quick stats for the Librarian dashboard
*******************************************************/

-- [Query] Get the absolute total of physical books owned by the library
-- This sums up all copies of every title in the 'books' table.
SELECT 
    SUM(total_copies) AS Total_Physical_Inventory 
FROM books;

-- [Query] Get the total number of books currently "In the Wild"
-- This counts all active loans that haven't been marked as returned yet.
SELECT 
    COUNT(loan_id) AS Active_Loans_Count
FROM loans
WHERE return_date IS NULL;

/*******************************************************
    SECTION 1.3: Inventory & Availability
    Goal: Calculate real-time book availability
*******************************************************/

-- [Query] Calculate available copies (Total Inventory - Active Loans)
WITH LibraryStats AS (
    SELECT 
        (SELECT SUM(total_copies) FROM books) AS TotalInventory,
        (SELECT COUNT(*) FROM loans WHERE return_date IS NULL) AS ActiveLoans
)
SELECT 
    TotalInventory, 
    ActiveLoans, 
    (TotalInventory - ActiveLoans) AS NetAvailableOnShelf
FROM LibraryStats;


/*******************************************************
    SECTION 2: Data Management
    Goal: Add new records and handle transactions
*******************************************************/

-- [Query] Add a new book title to the catalog
INSERT INTO books (title, author_id, published_year, genre, total_copies)
VALUES ('Learning SQL', 1, 2024, 'Educational', 5);

   -- We skip 'book_id' because it is Auto-Incremented.
   -- We mapped each value to its specific column to avoid errors.
   
-- [Query] Record a new loan (Check-out)
-- Note: Setting due date to 14 days from today
INSERT INTO loans (book_id, patron_id, loan_date, due_date)
VALUES (1, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY));

-- [Query] Process a return (Check-in)
UPDATE loans 
SET return_date = CURDATE() 
WHERE loan_id = 1;

/*******************************************************
    SECTION 3: Operational Reports
    Goal: Daily library tasks and patron engagement
*******************************************************/

-- [Query] Due Back List: Find books due on a specific date (e.g., July 13, 2020)
-- Purpose: Contact patrons who need to return books
SELECT 
    b.title, 
    CONCAT(p.first_name, ' ', p.last_name) AS PatronName, 
    p.email, 
    l.due_date
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id
LEFT JOIN patrons p ON l.patron_id = p.patron_id
WHERE l.due_date = '2020-07-13';

-- [Query] Target Audience: Identify 10 patrons with the fewest loans
-- Purpose: Marketing and encouragement campaigns
SELECT 
    p.patron_id, 
    CONCAT(p.first_name, ' ', p.last_name) AS FullName,
    COUNT(l.loan_id) AS TotalCheckouts
FROM patrons p 
LEFT JOIN loans l ON p.patron_id = l.patron_id 
GROUP BY p.patron_id, p.first_name, p.last_name
ORDER BY TotalCheckouts ASC 
LIMIT 10;

   -- LEFT JOIN ensures we see patrons with ZERO loans.
   -- ORDER BY numcheck ASC puts the people who borrow the least at the top.
   -- LIMIT 10 narrows it down to our target group.


/*******************************************************
    SECTION 4: Research & Analytics
    Goal: Historical data and popularity trends
*******************************************************/

-- [Query] Rare/Vintage Find: Available books from the 1890s
-- Requirement: Must have at least 1 copy currently on shelf
SELECT 
    b.title, 
    b.published_year,
    b.total_copies
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id AND l.return_date IS NULL
WHERE b.published_year BETWEEN 1890 AND 1899
GROUP BY b.book_id, b.title, b.published_year, b.total_copies
HAVING b.total_copies > COUNT(l.loan_id);

   -- ncluded 'total_copies' in both SELECT and GROUP BY to fix Error 1054.
   -- 'BETWEEN 1890 AND 1899' covers the entire decade (1890s).
   -- he HAVING clause ensures only books with at least one physical copy on the shelf are shown.
   -- The 'LEFT JOIN' and 'COUNT' check how many copies are currently out.

-- [Query] Publishing Trends: Count of books published per year
SELECT 
    published_year, 
    COUNT(book_id) AS BookCount 
FROM books 
GROUP BY published_year
ORDER BY published_year DESC;

-- [Query] Popularity Contest: Top 5 most borrowed books of all time
SELECT 
    b.book_id,
    b.title, 
    COUNT(l.loan_id) AS CheckoutFrequency
FROM books b
JOIN loans l ON b.book_id = l.book_id
GROUP BY b.book_id, b.title
ORDER BY CheckoutFrequency DESC 
LIMIT 5;

/* - COUNT(l.loan_id): We count the total number of times a book was borrowed, 
     regardless of whether it has been returned yet.
   - ORDER BY DESC: This sorts the results so the highest numbers (most popular) 
     appear at the top.
   - LIMIT 5: Restricts the output to exactly the top five titles as requested.
*/