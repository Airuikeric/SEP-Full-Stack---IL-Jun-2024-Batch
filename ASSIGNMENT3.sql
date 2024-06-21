-- 1.      List all cities that have both Employees and Customers.

SELECT DISTINCT e.City
FROM Employees e JOIN Customers c ON e.City = c.city
WHERE e.City IS NOT NULL AND c.City IS NOT NULL;

-- 2.      List all cities that have Customers but no Employee.
-- a. Use sub-query

SELECT DISTINCT City
FROM Customers 
WHERE City IS NOT NULL AND City NOT IN  (SELECT City FROM Employees WHERE City IS NOT NULL);

-- b.      Do not use sub-query

SELECT DISTINCT c.City
FROM Customers c LEFT JOIN Employees e ON c.City = e.City
WHERE e.City IS NULL AND c.City IS NOT NULL;

-- 3.      List all products and their total order quantities throughout all orders.

SELECT p.ProductID, p.ProductName, SUM(od.Quantity) AS TotalOrderQuantity
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalOrderQuantity DESC; 

-- 4.      List all Customer Cities and total products ordered by that city.

SELECT c.City, SUM(od.Quantity) AS TotalProductsOrdered
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE c.City IS NOT NULL
GROUP BY c.City
ORDER BY TotalProductsOrdered DESC;  

-- 5.      List all Customer Cities that have at least two customers.
-- a.      Use union

SELECT City
FROM Customers
WHERE City IS NOT NULL
GROUP BY City
HAVING COUNT(CustomerID) >= 2

UNION ALL

SELECT City
FROM Customers
WHERE City IS NOT NULL
GROUP BY City
HAVING COUNT(CustomerID) >= 2;

-- b.      Use sub-query and no union

SELECT City
FROM Customers
WHERE City IS NOT NULL
GROUP BY City
HAVING COUNT(CustomerID) >= 2;

-- 6.      List all Customer Cities that have ordered at least two different kinds of products.

SELECT c.City
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE c.City IS NOT NULL
GROUP BY c.City
HAVING COUNT(DISTINCT p.ProductID) >= 2;

-- 7.      List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.

SELECT DISTINCT c.CustomerID, c.ContactName, c.City AS CustomerCity, o.ShipCity
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.City IS NOT NULL AND o.ShipCity IS NOT NULL
AND c.City <> o.ShipCity;

-- 8.      List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

SELECT TOP 5 
    p.ProductID,
    p.ProductName,
    AVG(p.UnitPrice) AS AvgPrice,
    SUM(od.Quantity) AS TotalQuantity
INTO #TopProducts
FROM 
    [Order Details] od
    JOIN Products p ON od.ProductID = p.ProductID
GROUP BY 
    p.ProductID, p.ProductName
ORDER BY 
    TotalQuantity DESC;

SELECT 
    p.ProductID,
    c.City,
    SUM(od.Quantity) AS CityTotalQuantity
INTO #CityProductQuantity
FROM 
    Products p
    JOIN [Order Details] od ON p.ProductID = od.ProductID
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY 
    p.ProductID, c.City;

SELECT 
    tp.ProductID,
    tp.ProductName,
    tp.AvgPrice,
    cpq.City,
    cpq.CityTotalQuantity
FROM 
    #TopProducts tp
    JOIN #CityProductQuantity cpq ON tp.ProductID = cpq.ProductID
WHERE 
    cpq.CityTotalQuantity = (
        SELECT MAX(cpq2.CityTotalQuantity)
        FROM #CityProductQuantity cpq2
        WHERE cpq2.ProductID = tp.ProductID
    )
ORDER BY 
    tp.TotalQuantity DESC;

DROP TABLE #TopProducts;
DROP TABLE #CityProductQuantity;

--  9.      List all cities that have never ordered something but we have employees there.
-- a.      Use sub-query

SELECT DISTINCT e.City
FROM Employees e
WHERE e.City IS NOT NULL
AND e.City NOT IN (
    SELECT DISTINCT c.City
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE c.City IS NOT NULL
);

-- b.      Do not use sub-query

SELECT DISTINCT e.City
FROM Employees e
LEFT JOIN (
    SELECT DISTINCT c.City
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE c.City IS NOT NULL
) co ON e.City = co.City
WHERE e.City IS NOT NULL
AND co.City IS NULL;

-- 10.  List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, 
-- and also the city of most total quantity of products ordered from. (tip: join  sub-query)

SELECT TOP 1 
    EmployeeCity AS City
FROM (
    SELECT 
        e.City AS EmployeeCity,
        COUNT(o.OrderID) AS TotalOrders
    FROM 
        Employees e
        JOIN Orders o ON e.EmployeeID = o.EmployeeID
    WHERE 
        e.City IS NOT NULL
    GROUP BY 
        e.City
) AS EmployeeOrderCounts
ORDER BY 
    TotalOrders DESC;

SELECT TOP 1 
    CustomerCity AS City
FROM (
    SELECT 
        c.City AS CustomerCity,
        SUM(od.Quantity) AS TotalQuantity
    FROM 
        Customers c
        JOIN Orders o ON c.CustomerID = o.CustomerID
        JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE 
        c.City IS NOT NULL
    GROUP BY 
        c.City
) AS CustomerOrderQuantities
ORDER BY 
    TotalQuantity DESC;

SELECT 
    eoc.EmployeeCity AS City
FROM (
    SELECT TOP 1 
        e.City AS EmployeeCity,
        COUNT(o.OrderID) AS TotalOrders
    FROM 
        Employees e
        JOIN Orders o ON e.EmployeeID = o.EmployeeID
    WHERE 
        e.City IS NOT NULL
    GROUP BY 
        e.City
    ORDER BY 
        TotalOrders DESC
) AS eoc
JOIN (
    SELECT TOP 1 
        c.City AS CustomerCity,
        SUM(od.Quantity) AS TotalQuantity
    FROM 
        Customers c
        JOIN Orders o ON c.CustomerID = o.CustomerID
        JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE 
        c.City IS NOT NULL
    GROUP BY 
        c.City
    ORDER BY 
        TotalQuantity DESC
) AS coq ON eoc.EmployeeCity = coq.CustomerCity;

-- 11. How do you remove the duplicates record of a table?
-- To remove duplicate records from a table using a CTE, 
-- I can utilize the ROW_NUMBER() window function to identify duplicates and then delete the excess rows. 

-- varchar vs nvarchar
-- 	Storage: VARCHAR uses 1 byte per character, while NVARCHAR uses 2 bytes per character.
--	Usage: VARCHAR for non-Unicode data, NVARCHAR for Unicode data.
--	Capacity: VARCHAR can store up to 8,000 bytes (non-MAX), NVARCHAR can store up to 4,000 characters (non-MAX).
--	Performance: VARCHAR is generally more efficient for non-Unicode data, NVARCHAR is necessary for internationalization support.