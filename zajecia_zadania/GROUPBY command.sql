-- Grupowanie 

-- select the first 5 rows 

USE Northwind2 SELECT TOP 5 OrderID, ProductID, Quantity FROM [Order Details] 
	ORDER BY Quantity DESC; -- WEZMIE PIERWSZE DWA A POZNIEJ 3 DOWOLNE, JEZELI ELEM NIE SA INNE TO MOZE ZWROCIC LOSOWO

--phrase WITH TIES return extra elements with value like the last one (quantity)

SELECT TOP 5 WITH TIES OrderID, ProductID, Quantity FROM [Order Details]
	ORDER BY Quantity DESC; -- MOZLIWOSC DOCIAGNIECIE JAK ELEM SA TE SAME, Fraza WITH TIES powoduje, że zwracane są dodatkowo 
--								wszystkie elementy o wartościach takich jak element ostatni

-- count 
SELECT * FROM Employees;
SELECT COUNT(*) AS 'Number of rows' FROM Employees GO;

SELECT COUNT(ReportsTo) FROM Employees GO;

-- Policz średnią cenę jednostkową dla wszystkich produktów w tabeli products

SELECT AVG(UnitPrice) AS 'Average unit price' FROM Products;

-- Zsumuj wszystkie wartości w kolumnie quantity w tabeli order details (dla wierszy w których wartość productid = 1)

SELECT SUM(Quantity) FROM [Order Details] WHERE ProductID=1;

--1. Podaj liczbę produktów o cenach mniejszych niż 10$ lub większych niż 20$

SELECT * FROM Products;
SELECT SUM(UnitsInStock) AS 'Number of products' FROM Products WHERE UnitPrice NOT BETWEEN 10 AND 20;

-- 2. Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20$

SELECT MAX(UnitPrice) AS 'Maximum price' FROM Products WHERE UnitPrice < 20;

SELECT TOP 1 UnitPrice FROM Products WHERE UnitPrice < 20 ORDER BY 1 DESC; -- 1 ZAMINENIE Z UNITPRICE 

-- 3. Podaj maksymalną i minimalną i średnią cenę produktu dla produktów o produktach sprzedawanych w butelkach (‘bottle’)

SELECT CONCAT(MAX(UnitPrice), ', ', MIN(UnitPrice), ', ', AVG(UnitPrice)) AS MaxMinAvgPrice FROM Products WHERE QuantityPerUnit LIKE '%bottle%';

-- 4. Wypisz informację o wszystkich produktach o cenie powyżej średniej

DECLARE @avgPrice INT;
SET @avgPrice = (SELECT AVG(UnitPrice) FROM Products);
SELECT ProductName, QuantityPerUnit, UnitPrice FROM Products WHERE UnitPrice > @avgPrice;

SELECT ProductName, QuantityPerUnit, UnitPrice FROM Products 
	WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products); -- MOZNA TEZ TAK


-- 5. Podaj sumę/wartość zamówienia o numerze 10250

SELECT ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS Costs FROM [Order Details] WHERE OrderID = 10250;

-- Użycie klauzuli GROUP BY 

SELECT productid, SUM(quantity) AS total_quantity FROM orderhist GROUP BY productid;

SELECT productid, SUM(quantity) AS TOTAL_QUANTITY FROM orderhist WHERE productid = 2 GROUP BY productid;

SELECT ProductID, SUM(Quantity) AS TOTAL_QUANTITY FROM [Order Details] GROUP BY ProductID;

-- 1. Podaj maksymalną cenę zamawianego produktu dla każdego zamówienia

SELECT MAX(UnitPrice) AS MAXIMUM_PRICE FROM [Order Details] GROUP BY OrderID;

-- 2. Posortuj zamówienia wg maksymalnej ceny produktu

SELECT OrderID FROM [Order Details] GROUP BY OrderID ORDER BY MAX(UnitPrice) DESC;

-- 3. Podaj maksymalną i minimalną cenę zamawianego produktu dla każdego zamówienia

SELECT MAX(UnitPrice) AS MAX_PRICE, MIN(UnitPrice) AS MIN_PRICE FROM [Order Details] GROUP BY OrderID;

-- 4. Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów (przewoźników)

SELECT ShipVia, COUNT(*)  AS ORDER_COUNT FROM Orders GROUP BY ShipVia;

-- 5. Który z spedytorów był najaktywniejszy w 1997 roku

SELECT TOP 1 ShipVia, COUNT(ShippedDate) AS 'Number of activity' FROM Orders 
					WHERE YEAR(ShippedDate) = 1997 GROUP BY ShipVia ORDER BY COUNT(ShippedDate) DESC;


-- GROUP BY z klauzulą HAVING 

-- WHERE ODWOLUJEMY SIE DO TEGO CO JEST W TABELACH 
-- HAVING DRUGI WARUNEK NA TO CO DOSTAJEMY W PROCESIE AGREGACJI 

SELECT productid, orderid, quantity FROM orderhist;

SELECT productid, SUM(quantity) AS TOTAL_QUANTITY FROM orderhist GROUP BY productid HAVING SUM(quantity) >= 30;

SELECT ProductID, SUM(Quantity) AS TOTAL_QUANTITY FROM [Order Details] GROUP BY ProductID HAVING SUM(Quantity) > 1200;

-- 1. Wyświetl zamówienia dla których liczba pozycji zamówienia jest większa niż 5
SELECT * FROM [Order Details]
SELECT OrderID FROM [Order Details] GROUP BY OrderID HAVING COUNT(*) > 5;

-- 2. Wyświetl klientów dla których w 1998 roku zrealizowano więcej niż 8 zamówień
-- (wyniki posortuj malejąco wg łącznej kwoty za dostarczenie zamówień dla każdego z klientów)

SELECT CustomerID, COUNT(*) AS NumberOfOrders, SUM(Freight) AS DeliveryPrice FROM Orders WHERE YEAR(ShippedDate) = 1998 
	GROUP BY CustomerID HAVING COUNT(*) > 8 ORDER BY SUM(Freight) DESC;

-- Użycie klauzuli GROUP BY z operatorem ROLLUP 

SELECT productid, orderid, SUM(quantity) AS TOTAL_QUANTITY FROM orderhist 
	GROUP BY productid, orderid WITH ROLLUP ORDER BY productid, orderid

SELECT orderid, productid, SUM(quantity) AS total_quantity FROM [order details]
	WHERE orderid < 10250 GROUP BY orderid, productid ORDER BY orderid, productid


-- Ćwiczenie 1

-- 1. Napisz polecenie, które oblicza wartość sprzedaży dla każdego zamówienia w tablicy order details i zwraca wynik 
--    posortowany w malejącej kolejności (wg wartości sprzedaży).

SELECT OrderID, ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS wartosc_sprzedazy FROM [Order Details] 
	GROUP BY OrderID ORDER BY wartosc_sprzedazy DESC; 

-- 2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało pierwszych 10 wierszy

SELECT TOP 10 OrderID, ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS wartosc_sprzedazy FROM [Order Details] 
	GROUP BY OrderID ORDER BY wartosc_sprzedazy DESC;

-- Ćwiczenie 2

-- 1. Podaj liczbę zamówionych jednostek produktów dla produktów, dla których productid < 3

SELECT ProductID, SUM(Quantity) AS LICZBA_JEDNOSTEK FROM [Order Details] WHERE ProductID < 3 GROUP BY ProductID;

-- 2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby podawało liczbę zamówionych jednostek produktu dla wszystkich produktów

SELECT ProductID, SUM(Quantity) AS LICZBA_JEDNOSTEK FROM [Order Details] GROUP BY ProductID ORDER BY ProductID;

-- 3. Podaj nr zamówienia oraz wartość zamówienia, dla zamówień, dla których łączna liczba zamawianych jednostek produktów jest > 250 

SELECT OrderID, ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS WARTOSC FROM [Order Details] 
	GROUP BY OrderID HAVING SUM(Quantity) > 250 ORDER BY WARTOSC;

-- Ćwiczenie 3

-- 1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień

SELECT EmployeeID, COUNT(OrderID) AS LICZBA_ZAMOWIEN FROM Orders GROUP BY EmployeeID;

-- 2. Dla każdego spedytora/przewoźnika podaj wartość "opłata za przesyłkę" przewożonych przez niego zamówień

SELECT ShipVia, SUM(Freight) AS 'opłata za przesyłkę' FROM Orders GROUP BY ShipVia;

-- 3. Dla każdego spedytora/przewoźnika podaj wartość "opłata za przesyłkę" przewożonych przez niego zamówień w latach o 1996 do 1997

SELECT ShipVia, SUM(Freight) AS 'opłata za przesyłkę' FROM Orders 
	WHERE YEAR(ShippedDate) BETWEEN 1996 AND 1997 GROUP BY ShipVia;

-- Ćwiczenie 4

-- 1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z podziałem na lata i miesiące!!!!!!!!!!!!!!!!!!!!

SELECT * FROM Orders
SELECT EmployeeID, COUNT(OrderID) AS LICZBA_ZAMOWIEN, RequiredDate FROM Orders 
	GROUP BY EmployeeID, RequiredDate WITH ROLLUP 

-- 2. Dla każdej kategorii podaj maksymalną i minimalną cenę produktu w tej kategorii

SELECT CategoryID, MAX(UnitPrice) AS MAKSIMUM, MIN(UnitPrice) AS MINIMUM FROM Products 
	GROUP BY CategoryID WITH CUBE;

