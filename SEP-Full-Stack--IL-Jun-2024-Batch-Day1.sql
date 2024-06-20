USE Northwind
GO
-- another way to use for the database is to select from database on the top

-- SELECT statement: identify which columns we want to retrieve
--1. SELECT all columns and rows

SELECT *
FROM Employees

--2. SELEST a list of columns

SELECT EmployeeID, FirstName, LastName, City, Country
FROM Employees

SELECT e.EmployeeId, e.FirstName, e.LastName, e.City, e.Country
FROM Employees AS E

-- avoid using SELECT *
--1. unnecessary data
--2. Naming conflicts
SELECT *
FROM Employees

SELECT *
FROM Customers

SELECT *
FROM Employees e JOIN Orders o ON e.EmployeeId = o.EmployeeId JOIN Customers c ON o.CustomerId = c.CustomerId

--3. SELECT DISTINCT Value:
--List all the cities that employees are located at

SELECT DISTINCT City
From Employees

--4. SELECT combnined with plain text: retrieve the full name of employee

SELECT FirstName + ' ' + LastName AS FullName
From Employees

-- identifiers: are neams given to the db, tables sp, views, functions and so on.
--1. Regular   i) first charcter: lowercase A-Z, uppercase A-Z, @, #
                -- @: defining or declaring a variable.
                DECLARE @today DateTime
                SELECT @today = GETDATE()
                PRINT @today

                --#: temp tables
                --#: local temp table
                --##: global temp table

                --ii) Subsequent character: a-z, A-Z, 0-9, @, #, $
                --iii) must not be a sql reserve word
                --iv) embedded space is not allowed

--2. Delimited Identifier: [] or " "

SELECT FirstName + ' ' + LastName AS "Full Name"
From Employees

--WHERE statement: filter the records row by row
--1. euqal =
-- Customers who are from Germany

SELECT CustomerId, ContactName, Country
FROM Customers
WHERE Country = 'Germany'

SELECT CustomerId, ContactName, Country
FROM Customers
WHERE Country != 'Germany'

-- Product which price is $18

SELECT ProductId, ProductName, UnitPrice
FROM Products
WHERE UnitPrice = 18

--2. Customer who are not from UK

SELECT CustomerId, ContactName, Country
FROM Customers
WHERE Country <> 'UK'

SELECT CustomerId, ContactName, Country
FROM Customers
WHERE Country != 'UK'

-- IN Operator: retrieve a data among a list of values
-- E.g: Orders that ship to USA AND Canada

SELECT OrderID, CUstomerId, ShipCountry
FROM Orders
WHERE ShipCountry = 'USA' OR ShipCountry = 'Canada'

SELECT OrderID, CUstomerId, ShipCountry
FROM Orders
WHERE ShipCountry IN ('USA', 'Canada')

--BETWEEN operator: retrive a data in a consecutive range
--1. retrevie products whosse price is between 20 and 30

SELECT ProductId, Productname, UnitPrice
FROM Products
WHERE UnitPrice >= 20 AND UnitPrice <= 30

SELECT ProductId, Productname, UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 20 AND 30

-- NOT Operator: display a record if a condition is not true
-- list orders that does not ship to USA to Canada

SELECT OrderID, CustomerID, ShipCountry
FROM Orders
WHERE NOT ShipCountry IN ('USA', 'Canada')

SELECT ProductId, ProductName, UnitPrice
FROM Products
WHERE UnitPrice NOT BETWEEN 20 AND 30

--   Value
--check with employees' region inoformation is empty

SELECT FirstName + ' ' + LastName as [Employee Name], Region
FROM Employees
WHERE Region IS NULL

-- exclude the employees whose region is null

SELECT FirstName + ' ' + lastName AS [Employee Name], Region
FROM Employees
WHERE Region IS NOT NULL

--Null in numerical operation

SELECT *
From TestSalary

-- this table is not exist yet
-- the table should look like 
-- Eid  Salary      Com
-- 1    2000.00     500.00
-- 2    2000.00     NULL
-- 3    1500.00     500.00
-- 4    2000.00     0.00
-- 5    NULL        500.00
-- 6    NULL        NULL

SELECT Eid, Salary, Comm, Salary + Comm AS TotalComensation
FROM TestSalary

-- Eid  Salary      Com         TotalCompensation
-- 1    2000.00     500.00      2500.00
-- 2    2000.00     NULL        NULL
-- 3    1500.00     500.00      2000.00
-- 4    2000.00     0.00        2000.00
-- 5    NULL        500.00      NULL
-- 6    NULL        NULL        NULL 

SELECT Eid, Salary, Comm, IsNull(Salary, 0) + IsNull(Comm, 0) AS TotalComensation
FROM TestSalary

-- Eid  Salary      Com         TotalCompensation
-- 1    2000.00     500.00      2500.00
-- 2    2000.00     NULL        2000.00
-- 3    1500.00     500.00      2000.00
-- 4    2000.00     0.00        2000.00
-- 5    NULL        500.00      500.00
-- 6    NULL        NULL        NULL 

-- LIKE Operator: used to creata a search expressions
-- 1. Work with % wildcard chractrer:

-- retrieve all the employees whose last name starts with D
SELECT FirstName, LastName
FROM Employees
WHERE LastName LIKE 'D%'
-- if someone's lastname is 'D' it will also show up in the table

-- 2. work with [] and % to search in ranges:
--find customers whose postal code starts with number between 0 and 3

SELECT ContactName, PostalCode
FROM Customers
WHERE PostalCode LIKE '[0--3]%'

-- 3. work with NOT

SELECT ContactName, PostalCode
FROM Customers
WHERE PostalCode NOT LIKE '[0--3]%'

-- 4. Work with ^:

SELECT ContactName, PostalCode
FROM Customers
WHERE PostalCode LIKE '^[0--3]%'

-- Customer naem starting from letter A but not followed by l-n

SELECT ContactName, PostalCode
FROM Customers
WHERE ContactName LIKE 'A[^l-n]%'

-- ORDER By statement: is used to sort the result set ascendingly or descendingly

--1. retrieve all customers except those in Boston and sort by name

SELECT ContactName, City
FROM Customers
WHERE City != 'Boston'
ORDER BY ContactName
-- by default it will give me a ascending order

--2. retrieve product name and unit price, and sort by unit price in descending order

SELECT ProductId, productName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC

-- 3. Order by multiple columns
-- this is mroe readble 
SELECT ProductId, ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC, ProductName DESC
-- this will be sorted the UnitPrice first then ProductName

-- another way to do it not reconmend
SELECT ProductId, ProductName, UnitPrice
FROM Products
ORDER BY 3 DESC, 2 DESC
-- numbers are representing from SELECT ...

-- JOIN: used to combine rows from two or more tables based on the related column between them
-- 1. INNER JOIN: return the records that has matching value in both table, and it is default join in sql

-- find employees who have deal with any orders

SELECT e.EmployeeId, e.FirstName + ' ' + e.LastName AS FullName, o.OrderDate
FROM Employees AS e INNER JOIN Orders AS o ON e.EmployeeID = O.EmployeeID

-- get cusotmers information and corresponding order date

SELECT c.CustomerId, c.ContactName, o.OrderDate
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
-- INNER and AS by default can ignore it

-- join multiple tables:
-- get cutomer name, the corresponding employee who is responsible for this order, and the order date

SELECT e.EmployeeId, e.FirstName + ' ' + e.LastName AS FullName, o.OrderDate, c.ContactName
FROM Employees AS e INNER JOIN Orders AS o ON e.EmployeeID = O.EmployeeID JOIN Customers c ON  c.CustomerId = o.CustomerID

-- add detailed information about quantity and price, join  order details

SELECT e.EmployeeId, e.FirstName + ' ' + e.LastName AS FullName, o.OrderDate, c.ContactName, od.UnitPrice, od.Quantity
FROM Employees AS e INNER JOIN Orders AS o ON e.EmployeeID = O.EmployeeID JOIN Customers c ON  c.CustomerId = o.CustomerID
JOIN [Order Details] od ON o.OrderId = od.OrderId

-- 2. OUTER JOIN:

-- 1) LEFT OUTEER JOIN: return all the records from the left table and matching records form the right table and if we can not find any
-- matching records, then it will return null

-- list all customers whether they have made any purchase or 

SELECT c.ContactName, o.OrderID
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerId
Order by O.OrderId DESC

-- JOIN with WHERE
-- customers who never placed any order

SELECT c.ContactName, o.OrderID
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerId
WHERE o.OrderId is NULL
Order by O.OrderId DESC

--2) RIGHT OUTER JOIN: return all the records from the right table and matching records orm the left table and if we can not find any
--matching records, then it will reutrn null

-- list all customers whether they have made any puirchase or not

SELECT c.ContactName, o.OrderID
FROM  Orders o RIGHT JOIN Customers c ON c.CustomerID = o.CustomerId
Order by O.OrderId DESC

-- FULL OUTER JOIN:

-- Match all customers and suppliers by country.
 
SELECT c.ContactName AS Customer, c.Country as CustomerCountry, s.Country AS SupplierCountry, s.ContactName as Supplier
FROM Customers c FULL JOIN Suppliers s ON c.Country = s.Country
Order by CustomerCountry, SupplierCountry

-- 3. CROSS JOIN: cartesian product of two tables

SELECT *
FROM Customers

SELECT *
FROM Orders

SELECT *
FROM Customers CROSS JOIN Orders

-- SELF JOIN: joins a table with itself

-- find employees with the their manager name

SELECT employeeid, firstname, lastname, reportsto
FROM Employees

-- CEO: Anrew
-- Managers: Nacy, Janet, Margaret, Steven, Laura
-- Employees: Michael, Robert, Anne

-- find the manager with SELF JOIN

SELECT e.FirstName + ' ' + e.LastName as Employee, m.FirstName + ' ' + m.LastName AS manager
FROM Employees e JOIN Employees m ON e.ReportsTo = e.EmployeeId

-- Batch Directives

USE Northwind
GO --> batch directive
-- batch mean that we have server sql statement that got submit/excu it together 

CREATE DATABASE JunBatch
GO
USE JunBatch
GO
CREATE TABLE Employee(Id INT, EName varchar(20), Salary money)
-- You are not able to execute all DDL (Data Definition Language) SQL at one time.
-- You can execute SELECT, INSERT, UPDATE, DELETE where there will be no problem.
-- The moment of CREATE, ALTER, DROP should be executed in separate batches.
-- All the DDL should be executed in separate batches.