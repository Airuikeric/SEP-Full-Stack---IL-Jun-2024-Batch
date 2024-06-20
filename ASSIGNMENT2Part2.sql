-- 14.  List all Products that has been sold at least once in last 27 years.

SELECT DISTINCT p.ProductID, p.ProductName
FROM dbo.Products p
JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID
JOIN dbo.Orders o ON od.OrderID = o.OrderID
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE())
ORDER BY p.ProductID;

-- 15.  List top 5 locations (Zip Code) where the products sold most.

SELECT TOP 5 o.ShipPostalCode AS ZipCode, SUM(od.Quantity) AS TotalQuantitySold
FROM dbo.Orders o
JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.ShipPostalCode
ORDER BY TotalQuantitySold DESC;

-- 16.  List top 5 locations (Zip Code) where the products sold most in last 27 years.

SELECT TOP 5 o.ShipPostalCode AS ZipCode, SUM(od.Quantity) AS TotalQuantitySold
FROM dbo.Orders o
JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE())
GROUP BY o.ShipPostalCode
ORDER BY TotalQuantitySold DESC;

-- 17.   List all city names and number of customers in that city.     

SELECT City, COUNT(*) AS NumberOfCustomers
FROM dbo.Customers
GROUP BY City
ORDER BY City;

-- 18.  List city names which have more than 2 customers, and number of customers in that city

SELECT City, COUNT(*) AS NumberOfCustomers
FROM dbo.Customers
GROUP BY City
HAVING COUNT(*) > 2
ORDER BY NumberOfCustomers DESC, City;

-- 19.  List the names of customers who placed orders after 1/1/98 with order date.

SELECT c.ContactName, o.OrderDate
FROM dbo.Customers c
JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > '1998-01-01'
ORDER BY o.OrderDate;

-- 20.  List the names of all customers with most recent order dates

SELECT c.ContactName, o.MostRecentOrderDate AS OrderDate
FROM dbo.Customers c
JOIN (
    SELECT CustomerID, MAX(OrderDate) AS MostRecentOrderDate
    FROM dbo.Orders
    GROUP BY CustomerID
) o ON c.CustomerID = o.CustomerID
ORDER BY o.MostRecentOrderDate DESC, c.ContactName;

-- 21.  Display the names of all customers  along with the  count of products they bought

SELECT c.ContactName, COUNT(od.ProductID) AS ProductCount
FROM dbo.Customers c
JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName
ORDER BY ProductCount DESC, c.ContactName;

-- 22.  Display the customer ids who bought more than 100 Products with count of products.

SELECT c.CustomerID, COUNT(od.ProductID) AS ProductCount
FROM dbo.Customers c
JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING COUNT(od.ProductID) > 100
ORDER BY ProductCount DESC, c.CustomerID;

/*
23.  List all of the possible ways that suppliers can ship their products. Display the results as below

    Supplier Company Name                Shipping Company Name
*/

SELECT s.CompanyName AS SupplierCompanyName, sh.CompanyName AS ShippingCompanyName
FROM dbo.Suppliers s
JOIN dbo.Products p ON s.SupplierID = p.SupplierID
JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID
JOIN dbo.Orders o ON od.OrderID = o.OrderID
JOIN dbo.Shippers sh ON o.ShipVia = sh.ShipperID
GROUP BY s.CompanyName, sh.CompanyName
ORDER BY s.CompanyName, sh.CompanyName;

-- 24.  Display the products order each day. Show Order date and Product Name.

SELECT o.OrderDate, p.ProductName
FROM dbo.Orders o
JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
JOIN dbo.Products p ON od.ProductID = p.ProductID
ORDER BY o.OrderDate, p.ProductName;

-- 25.  Displays pairs of employees who have the same job title.

SELECT e1.EmployeeID AS Employee1ID, e1.FirstName AS Employee1FirstName, e1.LastName AS Employee1LastName, 
       e2.EmployeeID AS Employee2ID, e2.FirstName AS Employee2FirstName, e2.LastName AS Employee2LastName, 
       e1.Title AS JobTitle
FROM dbo.Employees e1
JOIN dbo.Employees e2 ON e1.Title = e2.Title AND e1.EmployeeID < e2.EmployeeID
ORDER BY e1.Title, e1.EmployeeID, e2.EmployeeID;

-- 26.  Display all the Managers who have more than 2 employees reporting to them.

SELECT e1.EmployeeID AS ManagerID, e1.FirstName AS ManagerFirstName, e1.LastName AS ManagerLastName, COUNT(e2.EmployeeID) AS NumberOfReports
FROM dbo.Employees e1
JOIN dbo.Employees e2 ON e1.EmployeeID = e2.ReportsTo
GROUP BY e1.EmployeeID, e1.FirstName, e1.LastName
HAVING COUNT(e2.EmployeeID) > 2
ORDER BY NumberOfReports DESC, e1.LastName, e1.FirstName;
/*
27.  Display the customers and suppliers by city. The results should have the following columns

City
Name
Contact Name,
Type (Customer or Supplier)
*/

SELECT City, CompanyName AS Name, ContactName, 'Customer' AS Type
FROM dbo.Customers
UNION ALL
SELECT City, CompanyName AS Name, ContactName, 'Supplier' AS Type
FROM dbo.Suppliers
ORDER BY City, Type, Name;