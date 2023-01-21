-- Zadanie 1 

USE Northwind2;

SELECT ProductName, CategoryName, Products.UnitPrice
FROM Products
INNER JOIN Categories ON Categories.CategoryID = Products.CategoryID
INNER JOIN [Order Details] ON [Order Details].ProductID = Products.ProductID
INNER JOIN Orders ON Orders.OrderID = [Order Details].OrderID
INNER JOIN Customers ON Customers.CustomerID = Orders.CustomerID
WHERE YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 3 AND Country <> 'France';


-- Zadanie 2





-- Zadanie 3

USE Northwind2;

SELECT TOP 1 WITH TIES Customers.CompanyName, Employees.LastName, Employees.FirstName, COUNT(Orders.orderID) AS CountOfOrders
FROM Customers
INNER JOIN Orders ON Orders.CustomerID = Customers.CustomerID AND YEAR(Orders.OrderDate) = 1997
INNER JOIN Employees ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Customers.CustomerID, Customers.CompanyName, Employees.LastName, Employees.FirstName
ORDER BY ROW_NUMBER() OVER (PARTITION BY Customers.CompanyName ORDER BY COUNT(Orders.orderID) DESC);
