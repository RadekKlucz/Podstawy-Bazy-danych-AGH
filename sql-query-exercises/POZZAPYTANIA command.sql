-- Podzapytania

-- tutaj robimy sobie taka tabele i z niej korzystamy

USE Northwind2;

SELECT T.OrderID, T.CustomerID FROM (SELECT OrderID, CustomerID FROM Orders) AS T;

-- Podzapytanie jako wyrazenie

SELECT ProductName, UnitPrice, (SELECT AVG(UnitPrice) FROM Products) AS 'Average', UnitPrice - (SELECT AVG(UnitPrice) FROM Products) AS 'Difference' FROM Products;


-- Podzapytanie może być użyte w warunku 

SELECT ProductName, UnitPrice, (SELECT AVG(UnitPrice) FROM Products) AS average, UnitPrice - (SELECT AVG(UnitPrice) FROM Products) AS Difference FROM Products
	WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products);

-- Podzapytanie skolerowane 

SELECT ProductName, UnitPrice, (SELECT AVG(UnitPrice) FROM Products AS P_WEW WHERE P_ZEW.CategoryID = P_WEW.CategoryID) AS Average FROM Products AS P_ZEW;

-- Podzapytania skolerowane w warunku 

SELECT ProductName, UnitPrice, (SELECT AVG(UnitPrice) FROM Products AS P_WEW WHERE P_ZEW.CategoryID = P_WEW.CategoryID) AS AVERAGE FROM Products AS P_ZEW
	WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products AS P_WEW WHERE P_ZEW.CategoryID = P_WEW.CategoryID);

-- Podzapytnia skolerowane 
-- Dla każdego produktu podaj maksymalną liczbę zamówionych jednostek 

SELECT * FROM [Order Details]; -- POWTARZA SIE ID PRODUKTU 

SELECT DISTINCT ProductID, Quantity FROM [Order Details] AS ORD1 WHERE Quantity = (SELECT MAX(Quantity) FROM [Order Details] AS ORD2 WHERE ORD1.ProductID = ORD2.ProductID);
 
 -- To samo przy użyciu GROUP BY 
 -- Dla każdego produktu podaj maksymalną liczbę zamówionych jednostek

 SELECT MAX(Quantity) FROM [Order Details] GROUP BY ProductID ORDER BY ProductID

-- Operatory EXISTS, NOT EXISTS

SELECT LastName, EmployeeID FROM Employees AS E WHERE EXISTS (SELECT * FROM Orders AS O WHERE E.EmployeeID = O.EmployeeID AND O.OrderDate = '9/5/97');

-- JOINEM ZROBIONE

SELECT LastName, E.EmployeeID FROM Orders AS O INNER JOIN Employees AS E ON E.EmployeeID = O.EmployeeID WHERE O.OrderDate = '9/5/1997';

-- Z NOT EXIST

SELECT LastName, EmployeeID FROM Employees AS E WHERE NOT EXISTS (SELECT * FROM Orders AS O WHERE E.EmployeeID = O.EmployeeID AND O.OrderDate = '9/5/97');

-- OPERATORY IN, NOT IN 

SELECT LastName, EmployeeID FROM Employees AS E WHERE EmployeeID IN (SELECT EmployeeID FROM Orders AS O WHERE O.OrderDate = '9/5/1997');

-- ZROBIENIE SELECT I NAZWANIE GO T 

;WITH T AS (SELECT OrderID, CustomerID FROM Orders)

SELECT * FROM T;

SELECT lastname, employeeid
FROM employees AS e
WHERE EXISTS (SELECT * FROM orders AS o
WHERE e.employeeid = o.employeeid
AND o.orderdate = '9/5/97')
GO

