CREATE SCHEMA `library`;
use library;

-- Creating tables for the library management system

CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255),
    Author VARCHAR(255),
    Genre VARCHAR(100),
    PublishedYear INT,
    CopiesAvailable INT
);

CREATE TABLE Borrowers (
    BorrowerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    MembershipDate DATE,
    ContactNumber VARCHAR(15),
    Email VARCHAR(100)
);

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    BorrowerID INT,
    LoanDate DATE,
    ReturnDate DATE,
    DueDate DATE,
    Returned BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (BorrowerID) REFERENCES Borrowers(BorrowerID)
);

-- Insert example data

INSERT INTO Books (Title, Author, Genre, PublishedYear, CopiesAvailable)
VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 1925, 3),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 2),
('1984', 'George Orwell', 'Dystopian', 1949, 4),
('Pride and Prejudice', 'Jane Austen', 'Romance', 1813, 5),
('Moby Dick', 'Herman Melville', 'Adventure', 1851, 2),
('War and Peace', 'Leo Tolstoy', 'Historical', 1869, 3),
('The Catcher in the Rye', 'J.D. Salinger', 'Fiction', 1951, 4),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937, 6),
('Brave New World', 'Aldous Huxley', 'Dystopian', 1932, 5),
('Harry Potter and the Philosopher\'s Stone', 'J.K. Rowling', 'Fantasy', 1997, 7),
('The Alchemist', 'Paulo Coelho', 'Adventure', 1988, 8),
('Crime and Punishment', 'Fyodor Dostoevsky', 'Psychological', 1866, 4),
('The Adventures of Sherlock Holmes', 'Arthur Conan Doyle', 'Mystery', 1892, 6),
('Wuthering Heights', 'Emily Bronte', 'Romance', 1847, 3),
('Great Expectations', 'Charles Dickens', 'Fiction', 1861, 5),
('Little Women', 'Louisa May Alcott', 'Fiction', 1868, 6),
('Don Quixote', 'Miguel de Cervantes', 'Adventure', 1615, 2),
('Frankenstein', 'Mary Shelley', 'Horror', 1818, 4),
('The Divine Comedy', 'Dante Alighieri', 'Epic', 1320, 1),
('Dracula', 'Bram Stoker', 'Horror', 1897, 3);

INSERT INTO Borrowers (FirstName, LastName, MembershipDate, ContactNumber, Email)
VALUES
('Alice', 'Smith', '2023-01-10', '1234567890', 'alice.smith@example.com'),
('Bob', 'Johnson', '2023-03-15', '9876543210', 'bob.johnson@example.com'),
('Charlie', 'Brown', '2023-05-20', '4561237890', 'charlie.brown@example.com'),
('Diana', 'Prince', '2023-07-10', '7894561230', 'diana.prince@example.com'),
('Eve', 'Taylor', '2023-08-25', '3216549870', 'eve.taylor@example.com'),
('Frank', 'Wright', '2023-09-12', '6549873210', 'frank.wright@example.com'),
('Grace', 'Hall', '2023-10-01', '9638527410', 'grace.hall@example.com'),
('Henry', 'Adams', '2023-11-03', '7412589630', 'henry.adams@example.com'),
('Ivy', 'Green', '2023-12-01', '8529637410', 'ivy.green@example.com'),
('Jack', 'White', '2023-06-15', '1597534860', 'jack.white@example.com'),
('Kate', 'Black', '2023-04-10', '9517538520', 'kate.black@example.com'),
('Leo', 'King', '2023-02-05', '7539518520', 'leo.king@example.com'),
('Mia', 'Scott', '2023-03-18', '3571592580', 'mia.scott@example.com'),
('Nina', 'Young', '2023-01-25', '8527413690', 'nina.young@example.com'),
('Oscar', 'Brown', '2023-07-07', '6541237890', 'oscar.brown@example.com');

INSERT INTO Loans (BookID, BorrowerID, LoanDate, DueDate, ReturnDate, Returned)
VALUES
(1, 1, '2023-12-01', '2023-12-15', NULL, FALSE),
(2, 2, '2023-11-20', '2023-12-05', '2023-12-02', TRUE),
(3, 3, '2023-12-10', '2023-12-24', NULL, FALSE),
(1, 4, '2023-12-05', '2023-12-20', NULL, FALSE),
(2, 5, '2023-11-25', '2023-12-10', '2023-12-08', TRUE),
(3, 6, '2023-12-01', '2023-12-15', NULL, FALSE),
(1, 7, '2023-11-28', '2023-12-12', NULL, FALSE),
(2, 8, '2023-12-02', '2023-12-16', NULL, FALSE),
(3, 9, '2023-12-03', '2023-12-17', NULL, FALSE),
(1, 10, '2023-12-04', '2023-12-18', NULL, FALSE),
(2, 11, '2023-11-15', '2023-11-30', '2023-11-28', TRUE),
(3, 12, '2023-11-20', '2023-12-05', '2023-12-02', TRUE),
(1, 13, '2023-11-30', '2023-12-14', NULL, FALSE),
(2, 14, '2023-12-01', '2023-12-15', NULL, FALSE),
(3, 15, '2023-12-02', '2023-12-16', NULL, FALSE);

-- Complex queries for meaningful reports

-- 1. List overdue books with borrower details
SELECT 
    l.LoanID,
    b.Title AS BookTitle,
    CONCAT(br.FirstName, ' ', br.LastName) AS BorrowerName,
    l.DueDate,
    DATEDIFF(NOW(), l.DueDate) AS DaysOverdue
FROM 
    Loans l
JOIN 
    Books b ON l.BookID = b.BookID
JOIN 
    Borrowers br ON l.BorrowerID = br.BorrowerID
WHERE 
    l.DueDate < NOW() AND l.Returned = FALSE;

-- 2. Identify the most borrowed books
SELECT 
    b.BookID,
    b.Title,
    COUNT(l.LoanID) AS TimesBorrowed
FROM 
    Loans l
JOIN 
    Books b ON l.BookID = b.BookID
GROUP BY 
    b.BookID
ORDER BY 
    TimesBorrowed DESC
LIMIT 5;

-- 3. Generate borrower history report
SELECT 
    br.BorrowerID,
    CONCAT(br.FirstName, ' ', br.LastName) AS BorrowerName,
    b.Title AS BookTitle,
    l.LoanDate,
    l.ReturnDate
FROM 
    Loans l
JOIN 
    Borrowers br ON l.BorrowerID = br.BorrowerID
JOIN 
    Books b ON l.BookID = b.BookID
ORDER BY 
    br.BorrowerID, l.LoanDate;

-- 4. Calculate average loan duration per book
SELECT 
    b.BookID,
    b.Title,
    AVG(DATEDIFF(l.ReturnDate, l.LoanDate)) AS AvgLoanDuration
FROM 
    Loans l
JOIN 
    Books b ON l.BookID = b.BookID
WHERE 
    l.Returned = TRUE
GROUP BY 
    b.BookID;

-- 5. List borrowers with multiple overdue loans
SELECT 
    br.BorrowerID,
    CONCAT(br.FirstName, ' ', br.LastName) AS BorrowerName,
    COUNT(l.LoanID) AS OverdueLoans
FROM 
    Loans l
JOIN 
    Borrowers br ON l.BorrowerID = br.BorrowerID
WHERE 
    l.DueDate < NOW() AND l.Returned = FALSE
GROUP BY 
    br.BorrowerID
HAVING 
    COUNT(l.LoanID) > 1;

-- 6. Identify the genres with the most borrowed books
SELECT 
    b.Genre,
    COUNT(l.LoanID) AS TimesBorrowed
FROM 
    Loans l
JOIN 
    Books b ON l.BookID = b.BookID
GROUP BY 
    b.Genre
ORDER BY 
    TimesBorrowed DESC;

-- 7. Find books that are currently unavailable (all copies are loaned out)
SELECT 
    b.BookID,
    b.Title,
    b.CopiesAvailable,
    COUNT(l.LoanID) AS CopiesLoaned
FROM 
    Books b
LEFT JOIN 
    Loans l ON b.BookID = l.BookID AND l.Returned = FALSE
GROUP BY 
    b.BookID
HAVING 
    b.CopiesAvailable = COUNT(l.LoanID);

-- 8. Calculate the total number of books loaned per borrower
SELECT 
    br.BorrowerID,
    CONCAT(br.FirstName, ' ', br.LastName) AS BorrowerName,
    COUNT(l.LoanID) AS TotalBooksLoaned
FROM 
    Loans l
JOIN 
    Borrowers br ON l.BorrowerID = br.BorrowerID
GROUP BY 
    br.BorrowerID;

-- 9. Determine the longest loan duration
SELECT
    l.LoanID,
    b.Title AS BookTitle,
    CONCAT(br.FirstName, ' ', br.LastName) AS BorrowerName,
    DATEDIFF(l.ReturnDate, l.LoanDate) AS LoanDuration
FROM 
    Loans l
JOIN 
    Books b ON l.BookID = b.BookID
JOIN 
    Borrowers br ON l.BorrowerID = br.BorrowerID
WHERE 
    l.Returned = TRUE
ORDER BY 
    LoanDuration DESC
LIMIT 1;

-- 10. List books and their current availability status
SELECT 
    b.BookID,
    b.Title,
    b.CopiesAvailable,
    CASE 
        WHEN COUNT(l.LoanID) < b.CopiesAvailable THEN 'Available'
        ELSE 'Not Available'
    END AS AvailabilityStatus
FROM 
    Books b
LEFT JOIN 
    Loans l ON b.BookID = l.BookID AND l.Returned = FALSE
GROUP BY 
    b.BookID;