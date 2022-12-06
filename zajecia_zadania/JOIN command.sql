-- Przykład 1 (bez aliasu nazwy tabeli)

USE joindb SELECT buyer_name, Sales.buyer_id, qty FROM Buyers, Sales WHERE Buyers.buyer_id = Sales.buyer_id;

-- Przykład 2 (z aliasem nazwy tabeli)

SELECT buyer_name, S.buyer_id, qty FROM Buyers AS B, Sales AS S WHERE B.buyer_id = S.buyer_id;

-- Złączenie wewnętrzne – INNER JOIN, te ktore nie udalo sie dopasowac nie sa dolaczane do zbioru winikowego 

SELECT buyer_name, Sales.buyer_id, qty FROM Buyers INNER JOIN Sales ON Buyers.buyer_id = Sales.buyer_id;

SELECT buyer_name, Sales.buyer_id, qty FROM Buyers  JOIN Sales ON Buyers.buyer_id = Sales.buyer_id; -- mozna pominac inner 


-- Przykłady

USE Northwind2 SELECT ProductName, CompanyName FROM Products 
	INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID;

SELECT * FROM Customers
SELECT * FROM Orders

SELECT CompanyName, OrderDate FROM Orders INNER JOIN Customers ON Customers.CustomerID = Orders.CustomerID 
	WHERE RequiredDate > '03/01/1998';

-- Złączenie zewnętrzne – OUTER JOIN, ZWRACA DODATKOWE INFORMACJE JAK CZEGOS NIE MA (INACZEJ W POROWNANIU DO INNER JOIN)

USE joindb SELECT buyer_name, Sales.buyer_id FROM Buyers LEFT OUTER JOIN Sales ON Buyers.buyer_id = Sales.buyer_id;

--  Napisz polecenie zwracające wszystkich klientów z datami zamówień (baza northwind).
-- testowanie to dadanie kluczy glownych po ON wystepujacych 

USE Northwind2 SELECT CompanyName, Customers.CustomerID, OrderDate FROM Orders 
	LEFT OUTER JOIN Customers ON Customers.CustomerID = Orders.CustomerID;

-- 1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej 
-- pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy

SELECT ProductName, UnitPrice, CompanyName, Address, City, PostalCode, Country FROM Products 
	INNER JOIN Suppliers ON  Products.SupplierID = Suppliers.SupplierID WHERE Products.UnitPrice BETWEEN 20 AND 30;

-- 2. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Traders

SELECT ProductName, UnitsInStock FROM Products INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID 
	WHERE Suppliers.CompanyName = 'Tokyo Traders';

-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak to pokaż ich dane adresowe

SELECT Customers.CustomerID, CompanyName, Address, City, PostalCode, Country FROM Customers 
	LEFT JOIN Orders ON Orders.CustomerID = Customers.CustomerID AND YEAR(Orders.OrderDate) = 1997 WHERE Orders.CustomerID IS NULL;

	-- ZLE TO PONIZEJ 
SELECT  Customers.CustomerID, CompanyName, Address, City, PostalCode, Country FROM Customers 
	INNER JOIN Orders ON Orders.CustomerID = Customers.CustomerID AND YEAR(Orders.OrderDate) != 1997 
-- 	GROUP BY Customers.CustomerID ,CompanyName, Address, City, PostalCode, Country;

-- DLA KAZDEGO KLIENTA PODAJ LICZBE ZLOZONYCH PRZEZ NIEGO ZAMOWIEN 

SELECT Customers.CustomerID, CompanyName, COUNT(OrderID)  FROM Customers
LEFT JOIN Orders ON Orders.CustomerID = Customers.CustomerID
AND YEAR(Orders.OrderDate) = 1997 GROUP BY Customers.CustomerID, CompanyName

-- 4. Wybierz nazwy i numery telefonów dostawców, dostarczających produkty, których aktualnie nie ma w magazynie

SELECT CompanyName, Phone FROM Suppliers 
	INNER JOIN Products ON Suppliers.SupplierID = Products.SupplierID AND UnitsInStock = 0

-- 1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza 
-- library). Interesuje nas imię, nazwisko i data urodzenia dziecka.

USE library2 SELECT firstname, middleinitial, lastname, birth_date FROM member 
	INNER JOIN juvenile	ON member.member_no = juvenile.member_no;

-- 2. Napisz polecenie, które podaje tytuły aktualnie wypożyczonych książek

SELECT DISTINCT title FROM loan JOIN title ON loan.title_no = title.title_no;

-- 3. Podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule ‘Tao 
-- Teh King’. Interesuje nas data oddania książki, ile dni była przetrzymywana i jaką zapłacono karę

SELECT  in_date, DATEDIFF(DAY, due_date, in_date) AS 'delay', fine_paid FROM loanhist 
	JOIN title ON title.title_no = loanhist.title_no WHERE title = 'Tao Teh King' AND in_date > due_date;

-- 4. Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych 
-- przez osobę o nazwisku: Stephen A. Graff

SELECT firstname + ' ' + middleinitial + '. ' + lastname AS 'Person', isbn FROM reservation JOIN member ON member.member_no = reservation.member_no 
	WHERE firstname = 'Stephen' AND lastname = 'Graff';

-- CROSS JOIN – iloczyn karteziański

USE joindb SELECT buyer_name, qty FROM buyers CROSS JOIN Sales; -- CO TO OZNACZA?

SELECT buyer_name, qty FROM Buyers JOIN Sales ON Buyers.buyer_id = Sales.buyer_id; -- TO NIE TO SAMO

--  Napisz polecenie, wyświetlające CROSS JOIN między shippers i suppliers. użyteczne dla listowania wszystkich możliwych 
--  sposobów w jaki dostawcy mogą dostarczać swoje produkty

USE Northwind2 SELECT Suppliers.CompanyName, Shippers.CompanyName FROM Suppliers CROSS JOIN Shippers; --CO?

-- Łączenie więcej niż dwóch tabel

USE joindb SELECT buyer_name, prod_name, qty FROM Buyers 
	INNER JOIN Sales ON Buyers.buyer_id = Sales.buyer_id 
	INNER JOIN Produce ON Sales.prod_id = Produce.prod_id;

-- Napisz polecenie zwracające listę produktów zamawianych w dniu 1996-07-08.


USE Northwind2 SELECT ProductName, OrderDate FROM Products AS P
		INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID 
		INNER JOIN Orders AS O ON O.OrderID = OD.OrderID WHERE OrderDate = '07/08/1996';

-- 1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej 
-- pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy, 
-- interesują nas tylko produkty z kategorii ‘Meat/Poultry’

SELECT ProductName, UnitPrice, CONCAT(CompanyName, ' ', Address, ' ', City, ' ', PostalCode, ' ', Country) AS 'CompanyDetails' FROM Products 
	INNER JOIN Categories ON Categories.CategoryID = Products.CategoryID AND CategoryName = 'Meat/Poultry'
	INNER JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID;

-- 2. Wybierz nazwy i ceny produktów z kategorii ‘Confections’ dla każdego produktu podaj nazwę dostawcy.

SELECT ProductName, UnitPrice, CompanyName FROM Products 
	INNER JOIN Categories ON Categories. CategoryID = Products.CategoryID AND CategoryName = 'Confections' 
	INNER JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID;

-- 3. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki  dostarczała firma ‘United Package’

SELECT DISTINCT Customers.CompanyName, Customers.Phone, Shippers.CompanyName FROM Customers 
	INNER JOIN Orders ON Orders.CustomerID = Customers.CustomerID 
	INNER JOIN Shippers ON Shippers.ShipperID = Orders.ShipVia AND Shippers.CompanyName = 'United Package';

-- a) Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki nie dostarczała firma ‘United Package’

SELECT DISTINCT Customers.CompanyName, Customers.Phone, Shippers.CompanyName FROM Customers 
	INNER JOIN Orders ON Orders.CustomerID = Customers.CustomerID 
	INNER JOIN Shippers ON Shippers.ShipperID = Orders.ShipVia AND Shippers.CompanyName <> 'United Package';

-- b) Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii ‘Confections’
-- design query in editor prawym przyciskiem 
SELECT DISTINCT        
FROM            Customers INNER JOIN
                         Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID INNER JOIN
                         Products ON [Order Details].ProductID = Products.ProductID INNER JOIN
                         Categories ON Products.CategoryID = Categories.CategoryID

-- c) Wybierz nazwy i numery telefonów klientów, którzy kupili co najmnie dwa rózne produkty z kategorii ‘Confections’



-- d) Wybierz nazwy i numery telefonów klientów, którzy w 1997r kupili co najmnie dwa rózne produkty z kategorii ‘Confections’



-- e) Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii ‘Confections’
	
SELECT DISTINCT Customers.CompanyName, Customers.Phone, Shippers.CompanyName FROM Customers 
	INNER JOIN Orders ON Orders.CustomerID = Customers.CustomerID 
	INNER JOIN Shippers ON Shippers.ShipperID = Orders.ShipVia AND Shippers.CompanyName <> 'United Package';

-- 4. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii ‘Confections'

SELECT CompanyName, Phone FROM Customers 
	INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
	INNER JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
	INNER JOIN Products ON Products.ProductID = [Order Details].ProductID
	INNER JOIN Categories ON Categories.CategoryID = Products.CategoryID AND CategoryName = 'Confections'
	GROUP BY CompanyName, Phone;

-- 2. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library).
-- Interesuje nas imię, nazwisko, data urodzenia dziecka, adres zamieszkania dziecka oraz imię i nazwisko rodzica. 

USE library2 SELECT firstname, lastname, birth_date, city, street FROM member 
	INNER JOIN juvenile ON juvenile.member_no = member.member_no
	INNER JOIN adult ON adult.member_no =  juvenile.adult_member_no;

-- Łączenie tabeli samej ze sobą – self join

USE joindb SELECT A.buyer_id AS buyer1, A.prod_id, B.buyer_id AS buyer2 FROM Sales AS A 
	JOIN Sales AS B ON A.prod_id = B.prod_id WHERE A.buyer_id > B.buyer_id; -- co?

-- Napisz polecenie, które wyświetla listę wszystkich kupujących te same produkty.

SELECT A.buyer_id AS B1, A.prod_id, B.buyer_id AS B2, B.prod_id FROM Sales AS A 
	INNER JOIN Sales AS B ON A.prod_id = B.prod_id;

--  Zmodyfikuj poprzedni przykład, tak aby zlikwidować duplikaty

SELECT A.buyer_id AS B1, A.prod_id, B.buyer_id AS B2, B.prod_id FROM Sales AS A 
	INNER JOIN Sales AS B ON A.prod_id = B.prod_id WHERE A.buyer_id <> B.buyer_id; 

SELECT A.buyer_id AS B1, A.prod_id, B.buyer_id AS B2, B.prod_id FROM Sales AS A 
	INNER JOIN Sales AS B ON A.prod_id = B.prod_id WHERE A.buyer_id < B.buyer_id;


-- Napisz polecenie, które pokazuje pary pracowników zajmujących to samo stanowisko.

USE Northwind2;

SELECT * FROM Employees;

USE Northwind2 SELECT A.EmployeeID, LEFT(A.LastName, 10) AS NAME, LEFT(A.Title, 10) AS TITLE, 
	B.EmployeeID, LEFT(B.LastName, 10) AS NAME, LEFT(B.Title, 10) AS TITLE FROM Employees AS A 
	INNER JOIN Employees AS B ON A.Title = B.Title WHERE A.EmployeeID < B.EmployeeID;

-- 1. Napisz polecenie, które wyświetla pracowników oraz ich podwładnych (baza northwind)

SELECT SZEF.EmployeeID, SZEF.LastName AS PRACOWNICY, PODWLADNI.EmployeeID, PODWLADNI.LastName AS PODWLADNI FROM Employees AS SZEF 
	INNER JOIN Employees AS PODWLADNI ON SZEF.EmployeeID = PODWLADNI.ReportsTo;

-- 2. Napisz polecenie, które wyświetla pracowników, którzy nie mają podwładnych (baza northwind) ?????

SELECT A.EmployeeID, A.FirstName, A.LastName FROM Employees AS A 
	LEFT JOIN Employees AS B ON A.EmployeeID = B.ReportsTo WHERE B.ReportsTo IS NULL;

-- 3. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci urodzone przed 1 stycznia 1996



-- 4. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci 
-- urodzone przed 1 stycznia 1996. Interesują nas tylko adresy takich członków 
-- biblioteki, którzy aktualnie nie przetrzymują książek.



-- 9 LUB 16 KOLOKWIUM, PROJEKT TERMINU PATRZ WYKLAD, ZADAWAC PYTANIA DO SPECYFIKACJI CO CZEGO CHCE, 
-- 3 PUNKT JEST WAZNY IMPLEMENTACJA PRZED SWIETAMI, ZA TRZY ZADANIA Z MEDIUM BEDZIE PLUS 


-- EFENTEM UNION JEST WYELIMINOWANIE DUPLIKATOW W ZBIORACH, UNION ALL DO ZOSTAWIENIA DUPLIKATOW 

--4.Podaj listę członków biblioteki mieszkających w Arizonie (AZ) mają więcej niż
-- dwoje dzieci zapisanych do biblioteki

USE library2

SELECT  lastname, firstname, count(j.member_no) from
 member m join adult a on m.member_no = a.member_no
join juvenile j on a.member_no = j.adult_member_no
where state = 'az'
group by m.member_no, lastname, firstname
having count(j.member_no) > 2



SELECT  lastname, firstname, count(j.member_no) from
 member m join adult a on m.member_no = a.member_no
join juvenile j on a.member_no = j.adult_member_no
where state = 'az'
group by m.member_no, lastname, firstname
having count(j.member_no) > 2


-- Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki nie dostarczała firma ‘United Package’
SELECT C.CompanyName, C.Phone
FROM Orders
JOIN Shippers S
on S.ShipperID = Orders.ShipVia and year(OrderDate) = 1997 and S.CompanyName = 'United Package'
right join Customers C on Orders.CustomerID = C.CustomerID
where S.CompanyName is NULL


--Teams 4. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produkty z kategorii
--‘Confections’

SELECT DISTINCT C.CompanyName, C.Phone FROM  Categories Cat    
JOIN Products P on P.CategoryID = Cat.CategoryID and CategoryName = 'Confections'    
JOIN [Order Details] OD on P.ProductID = OD.ProductID    JOIN Orders O on OD.OrderID = O.OrderID    
RIGHT JOIN Customers C on C.CustomerID = O.CustomerID    WHERE CategoryName IS NULL

-- Dla każdego klienta podaj liczbe zamówień, które dostarczała w 1997 mu firma 'United Package' 

USE Northwind2;

--  podaj liczbę  zamówień złożonych w latach 1996, 1997, 1998 z podziałem na lata i miesiące

SELECT * FROM Orders

SELECT * FROM [Order Details]

SELECT [Order Details].OrderID, SUM(UnitPrice * Quantity) AS Koszt FROM Orders 
RIGHT JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID GROUP BY [Order Details].OrderID

SELECT COUNT(OD.OrderID) FROM Orders AS O 
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID WHERE (YEAR(OrderDate) BETWEEN 1996 AND 1998)
AND (MONTH(OrderDate) BETWEEN 1 AND 12)
GROUP BY OD.OrderID

with rec(x)  as (
    select 1 as x
    union all
    select x+1 from rec where x<10
)
select x from rec;

USE joindb

SELECT a.buyer_id AS buyer1, a.prod_id, b.buyer_id AS buyer2
FROM sales AS a
INNER JOIN sales AS b
ON a.prod_id = b.prod_id WHERE a.buyer_id <> b.buyer_id

-- Union 

USE Northwind2;

SELECT (firstname + ' ' + lastname) AS name, city, postalcode
FROM employees
UNION
SELECT companyname, city, postalcode
FROM customers

-- 1. Napisz polecenie które zwraca imię i nazwisko (jako pojedynczą kolumnę –
--  name), oraz informacje o adresie: ulica, miasto, stan kod (jako pojedynczą
--  kolumnę – address) dla wszystkich dorosłych członków biblioteki

USE library2;

SELECT CONCAT(firstname, ' ', lastname) AS name, CONCAT(street, ' ', city, ' ', state, ' ', zip) AS ADDRESS FROM member 
INNER JOIN adult ON member.member_no = adult.member_no;


