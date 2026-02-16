## MySql-Projects

### Built with
- **SQL Languages:** MySQL, PostgreSQL
- **Tools:** MySQL Workbench

---

### Projects List

#### 1. [Instagram Clone Project](https://github.com/SamirHendawy/MySql-Projects/tree/main/Instagram%20Clone%20Project)
A complex MySQL project mimicking an Instagram database to perform deep data analysis. It addresses real-world business scenarios and technical challenges.

**Key Analysis Performed:**
* **User Engagement:** Finding the oldest users and identifying the most popular registration days.
* **Inactive User Tracking:** Identifying users who have never posted or commented.
* **Bot Detection:** Identifying accounts that liked every single photo (potential bots).
* **Advanced Metrics:** Using **CTEs** and subqueries to calculate engagement percentages.

#### 2. [RetailDB Analysis (Advanced & Expert)](https://github.com/SamirHendawy/MySql-Projects/tree/main/SQLRetailDBQueries)
A comprehensive deep-dive into E-commerce data using a multi-table schema. This project focuses on business intelligence, revenue reporting, and advanced retrieval techniques.

**Key Technical Challenges:**
* **Advanced Subqueries:** Utilizing **Nested Subqueries** in the `WHERE` clause and using `WHERE EXISTS` to filter customer order history effectively.
* **Ranking & Window Functions:** Implementing `RANK() OVER()` to identify specific product price tiers without using traditional `LIMIT` clauses.
* **Revenue Analytics:** Calculating total spending per customer and total shipping value using complex aggregations.
* **Data Handling:** Using `COALESCE` to manage `NULL` values in financial reports and performing 4-way table joins (Customers -> Orders -> Details -> Products).

#### 3. [Subquery Practice (Mastering Nested Queries)](https://github.com/SamirHendawy/MySql-Projects/tree/main/subquery-practice)
A dedicated module for mastering the versatility of **Subqueries** in MySQL. This project demonstrates how to solve complex analytical problems by nesting queries within various clauses.

**Key Technical Scenarios:**
* **Subqueries in SELECT & WHERE:** Creating dynamic columns and advanced filtering based on aggregate data (e.g., customers with more than 5 orders).
* **Derived Tables (FROM Clause):** Using subqueries to generate temporary tables for multi-step data processing.
* **Correlated Subqueries:** Implementing logic where the inner query depends on the outer query (e.g., identifying products priced above their specific category average).
* **Logical Filtering:** Efficiently using `EXISTS` and `NOT EXISTS` to find orphan records and inactive accounts.

#### 4. [Simple Task](https://github.com/SamirHendawy/MySql-Projects/tree/main/simple%20task)
A practical collection of SQL queries designed to handle fundamental data requests and database operations.
* **Content:** Includes the complete Dataset and a solution script.
* **Scope:** Contains **20 solved queries** covering filtering, aggregations, table joins, and grouping logic.

---

#### 5. [Library Management System](https://github.com/SamirHendawy/MySql-Projects/tree/main/Library-Management-System)
A robust database solution for managing library assets and tracking patron activity. This project focuses on inventory accuracy and real-time availability logic.

**Key Technical Challenges:**
* **Real-time Availability Logic:** Using **CTEs** and mathematical operations to calculate "Net Available" books by subtracting active loans (where `return_date IS NULL`) from total physical inventory.
* **Complex Data Aggregation:** Implementing `GROUP BY` and `HAVING` clauses to filter library decades (e.g., 1890s) while ensuring only titles with at least one physical copy on the shelf are displayed.
* **Transaction Management:** Handled the lifecycle of a book from entry (`INSERT`), to borrowing (`INSERT` into loans), and final return (`UPDATE` return dates).
* **Patron Engagement Reporting:** Used `LEFT JOIN` and `COUNT()` to identify inactive patrons, ensuring those with zero loans are included in the engagement report.

---

## 👨‍💻 Connect with Me

I’m a Data Analyst passionate about turning complex data into visual stories. Feel free to reach out for collaboration or questions:

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/samir-hendawy-530124231)
[![Kaggle](https://img.shields.io/badge/Kaggle-Profile-00AFEF?style=for-the-badge&logo=kaggle&logoColor=white)](https://www.kaggle.com/samerhendawy)