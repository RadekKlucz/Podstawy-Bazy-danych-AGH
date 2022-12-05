-- select * from customers;
-- select * from Products;
-- select * from Suppliers;

exec sp_help 'products'
-- komentarz 
-- select * from Orders
-- where OrderID = 10250;

-- select * from "Order Details"
-- where orderid = 10250;

-- Exercises SELECT
USE Northwind SELECT EmployeeID, LastName, FirstName, Title FROM Employees;

--1
USE Northwind SELECT CompanyName, Address FROM Customers;
--2
USE Northwind SELECT LastName, HomePhone FROM Employees;
--3
USE Northwind SELECT ProductName, UnitPrice FROM Products;
--4
USE Northwind SELECT CategoryName, Description FROM Categories;
--5
USE Northwind SELECT CompanyName, HomePage FROM Suppliers;

--Exercises WHERE
USE Northwind SELECT EmployeeID, LastName, FirstName, Title FROM Employees WHERE EmployeeID = 5;
USE Northwind SELECT LastName, City FROM Employees WHERE Country = 'USA'; -- moze byc sytuacja ze bedzie trzeba uwazac na wielkosc liter, zdefiniowanie moze to byc w zaleznosci od default programu 
USE Northwind SELECT OrderID, CustomerID FROM Orders WHERE OrderDate < '8/1/96';

--1
USE Northwind SELECT CompanyName, Address FROM Customers WHERE City = 'London';
--2
USE Northwind SELECT CompanyName, Address FROM Customers WHERE Country = 'France' OR Country = 'Spain';
USE Northwind SELECT CompanyName, Address, PostalCode FROM Customers WHERE Country IN ('France', 'Spain');

--3
USE Northwind SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice >= 20 AND UnitPrice <= 30;
USE Northwind SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice BETWEEN 20 AND 30;

--4
-- MOZNA ZADEKLAROWAC ZMIENNA 
DECLARE @id INT
-- tutaj szuka jakie oznaczenie kolumny
SET @id = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Meat/Poultry');
-- podstawienie znalezionej zmiennej 
SELECT ProductName, UnitPrice FROM Products WHERE CategoryID = @id;

USE Northwind SELECT * FROM Categories; -- kategoria meat ma oznaczenie 6
USE Northwind SELECT ProductName, UnitPrice FROM Products WHERE CategoryID = 6;
--5
USE Northwind SELECT * FROM Suppliers; -- identyfikator to 4
USE Northwind SELECT ProductName, UnitsInStock FROM Products WHERE SupplierID = 4;
--6
USE Northwind SELECT ProductName FROM Products WHERE UnitsInStock IS NULL; -- to nie działa bo wartość to 0
USE Northwind SELECT ProductName FROM Products WHERE UnitsInStock = 0;

-- Exercises LIKE String 
USE Northwind SELECT CompanyName FROM Customers WHERE CompanyName LIKE '%Restaurant%';

--1
USE Northwind SELECT * FROM Products; -- sprawdzam w jakiej kolumnie jest nazwa bottle
USE Northwind SELECT ProductName FROM Products WHERE QuantityPerUnit LIKE '%bottle%';
--2 Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się
-- na literę z zakresu od B do L
SELECT FirstName, LastName, Title FROM Employees WHERE LastName LIKE '[B-L]%';
--3 Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się
-- na literę B lub L
SELECT FirstName, LastName, Title FROM Employees WHERE LastName LIKE '[BL]%';
--4
USE Northwind SELECT CategoryName FROM Categories WHERE Description LIKE '%,%';
--5 
USE Northwind SELECT CompanyName FROM Customers WHERE CompanyName LIKE '%Store%';

--Exercises operators
USE Northwind SELECT ProductID, ProductName, SupplierID, UnitPrice FROM Products WHERE (ProductName LIKE 'T%' OR ProductID = 46)
    AND (UnitPrice > 16);

USE Northwind SELECT ProductID, ProductName, SupplierID, UnitPrice FROM Products WHERE (ProductName LIKE 'T%') 
    OR (ProductID = 46 AND UnitPrice > 16); 

USE Northwind SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice BETWEEN 10 AND 20;
-- zapisane inaczej 
USE Northwind SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice >= 10 AND UnitPrice <= 20;

--1
USE Northwind SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice <= 10 OR UnitPrice >= 20;
SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice NOT BETWEEN 10 AND 20;

--2
USE Northwind SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice BETWEEN 20 AND 30;

--1
USE Northwind SELECT CompanyName, Address FROM Customers WHERE Country = 'Japan' OR Country = 'Italy';

-- list of values 
USE Northwind SELECT CompanyName, Country FROM Suppliers WHERE Country IN ('Japan', 'Italy');

--  null
USE Northwind2 SELECT CompanyName, Fax FROM Suppliers WHERE Fax IS NULL; --puste nie zwraca wartości, czemu?
-- USE Northwind2 SELECT CompanyName, Fax FROM Suppliers WHERE Fax = 0; -- to JUZ NIE działa

--ćwiczenie
-- jeszcze trzeba uzyc daty dzisiejszej getdate, ale w ogolnosci ta bazda zwroci to samo 
SELECT OrderID, OrderDate, CustomerID FROM Orders WHERE (ShippedDate IS NULL OR ShippedDate > GETDATE()) AND ShipCountry = 'Argentina';

-- ORDER BY
USE Northwind SELECT ProductID, ProductName, UnitPrice FROM Products ORDER BY UnitPrice;
USE Northwind SELECT ProductID, ProductName, UnitPrice FROM Products ORDER BY UnitPrice DESC;

USE Northwind SELECT ProductID, ProductName, CategoryID, UnitPrice FROM Products ORDER BY CategoryID, UnitPrice DESC;
USE Northwind SELECT ProductID, ProductName, CategoryID, UnitPrice FROM Products ORDER BY 3, 4 DESC; -- to samo co wyżej

--1
USE Northwind SELECT CompanyName, Country FROM Customers ORDER BY Country, CompanyName;
--2
USE Northwind SELECT CategoryID, ProductName, UnitPrice FROM Products ORDER BY CategoryID, UnitPrice DESC;
--3
USE Northwind SELECT CompanyName, Country FROM Suppliers WHERE Country IN ('Japan', 'Italy') ORDER BY Country, CompanyName; 

-- elimination duplicats 
USE Northwind SELECT Country FROM Suppliers ORDER BY Country; -- tu będą duplikaty
USE Northwind SELECT DISTINCT Country FROM Suppliers ORDER BY Country; --te dane sa juz posortowane, ale warto dodac ORDER BY 

-- change column name
USE Northwind SELECT FirstName AS First, LastName AS Last, EmployeeID AS 'Employee ID:' FROM Employees;

-- constans value 
USE Northwind SELECT FirstName, LastName, 'Identification number:', EmployeeID FROM Employees; -- co tu ktoś miał na myśli? 

-- prise increased by 5%
USE Northwind SELECT OrderID, UnitPrice * 1.05 AS NewUnitPrice FROM [Order Details];

USE Northwind SELECT FirstName + ' ' + LastName AS ImieNazwisko FROM Employees;

--1. Napisz polecenie, które oblicza wartość każdej pozycji zamówienia o numerze 
-- 10250

-- tu jeszcze trzeba uwzglednic rabat procentowy 
SELECT * FROM [Order Details];
SELECT ROUND(UnitPrice * Quantity - (1 - Discount), 2) AS 'Value of order' FROM [Order Details] WHERE OrderID = 10250;
SELECT CAST(UnitPrice * Quantity - (1 - Discount) AS DECIMAL(10, 2)) FROM [Order Details] WHERE OrderID = 10250; -- TO SAMO ALE Z PRZECINKAMI

--2 
SELECT SupplierID, CONCAT(Phone, ', ', Fax) AS PhoneWithFax FROM Suppliers;

-- Library exercises
--Ex.1
--1 Napisz polecenie select, za pomocą którego uzyskasz tytuł i numer książki

USE library2 SELECT title_no, title FROM title;

--2 Napisz polecenie, które wybiera tytuł o numerze 10

SELECT title FROM title WHERE title_no = 10;

--3 Napisz polecenie select, za pomocą którego uzyskasz numer książki (nr tyułu) i 
-- autora z tablicy title dla wszystkich książek, których autorem jest Charles 
--  Dickens lub Jane Austen

SELECT title_no, author FROM title WHERE author IN ('Charles Dickens', 'Jane Austen');

--Ex.2
--1 Napisz polecenie, które wybiera numer tytułu i tytuł dla wszystkich książek, 
-- których tytuły zawierających słowo „adventure”

SELECT title_no, title FROM title WHERE title LIKE '%adventure%'; 

--2 Napisz polecenie, które wybiera numer czytelnika, oraz zapłaconą karę

SELECT member_no, fine_paid FROM loanhist;

--3 Napisz polecenie, które wybiera wszystkie unikalne pary miast i stanów z tablicy 
-- adult.

SELECT DISTINCT city, state FROM adult;

--4 Napisz polecenie, które wybiera wszystkie tytuły z tablicy title i wyświetla je w 
-- porządku alfabetycznym.

SELECT title FROM title ORDER BY title;

--Ex.3
--1
SELECT DISTINCT member_no, isbn, fine_assessed * 2 AS 'double fine' FROM loanhist WHERE fine_assessed IS NOT NULL;

--Ex.4
--1 

USE library2 SELECT LOWER(SUBSTRING(firstname, 1, 1) + middleinitial + SUBSTRING(lastname, 1, 2)) AS 'email_name' FROM member 
	WHERE lastname = 'Anderson';

-- REPLACE()  -- DO ZASTAOEINIA JAKIS LITER, SPACJI  

--Ex.5
--1

SELECT CONCAT('The title is: ', title, ', title number: ', title_no) AS 'Title and number' FROM title;

-- 2 I 3 NA NASTEPNYCH ZAJECIACH Z PLIKOW 

SELECT * FROM title