CREATE DATABASE IF NOT EXISTS ProLibraryDB;
USE ProLibraryDB;

-- 1. authors
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50)
);

-- 2. books
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT,
    published_year INT,
    genre VARCHAR(50),
    total_copies INT DEFAULT 1,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

-- 3. patrons
CREATE TABLE patrons (
    patron_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    join_date DATE
);

-- 4. loans
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    patron_id INT,
    loan_date DATE,
    due_date DATE,
    return_date DATE NULL,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (patron_id) REFERENCES patrons(patron_id)
);

-- ==========================================
-- insert data
-- ==========================================

-- authors
INSERT INTO authors (author_name, nationality) VALUES 
('Bram Stoker', 'Irish'),
('Oscar Wilde', 'Irish'),
('H.G. Wells', 'British'),
('George Orwell', 'British'),
('Agatha Christie', 'British'),
('Naguib Mahfouz', 'Egyptian'),
('Stephen King', 'American'),
('Leo Tolstoy', 'Russian');

-- books
INSERT INTO books (title, author_id, published_year, genre, total_copies) VALUES 
('Dracula', 1, 1897, 'Horror', 10),
('The Picture of Dorian Gray', 2, 1890, 'Philosophical Fiction', 5),
('The Time Machine', 3, 1895, 'Sci-Fi', 4),
('The Invisible Man', 3, 1897, 'Sci-Fi', 3),
('Animal Farm', 4, 1945, 'Political Satire', 8),
('1984', 4, 1949, 'Dystopian', 12),
('Murder on the Orient Express', 5, 1934, 'Mystery', 7),
('Palace Walk', 6, 1956, 'Drama', 6),
('The Shining', 7, 1977, 'Horror', 9),
('War and Peace', 8, 1869, 'Historical Fiction', 2);

-- (Patrons)
INSERT INTO patrons (first_name, last_name, email, join_date) VALUES 
('Ahmed', 'Mansour', 'ahmed@mail.com', '2020-01-15'),
('Mona', 'Farid', 'mona@mail.com', '2020-03-20'),
('Samy', 'Hassan', 'samy@mail.com', '2021-05-10'),
('Sara', 'Ibrahim', 'sara@mail.com', '2022-02-14'),
('Youssef', 'Ali', 'youssef@mail.com', '2023-11-30'),
('Laila', 'Kamel', 'laila@mail.com', '2019-12-01');

-- loans
INSERT INTO loans (book_id, patron_id, loan_date, due_date, return_date) VALUES 
(1, 1, '2020-07-01', '2020-07-13', NULL),        
(1, 2, '2020-06-25', '2020-07-09', '2020-07-08'), 
(2, 3, '2020-07-05', '2020-07-13', NULL),       
(5, 1, '2023-01-10', '2023-01-24', '2023-01-23'),
(6, 4, '2023-05-15', '2023-05-29', NULL),
(1, 5, '2023-10-01', '2023-10-15', NULL),
(7, 2, '2023-12-01', '2023-12-15', NULL),
(3, 6, '2020-07-10', '2020-07-13', NULL);