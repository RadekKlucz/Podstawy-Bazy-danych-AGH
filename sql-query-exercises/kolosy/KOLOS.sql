-- Zad.1. Wyświetl produkt, który przyniósł najmniejszy, ale niezerowy, przychód w 1996 roku

USE Northwind2

SELECT TOP 1 ProductName, SUM([Order Details].UnitPrice * Quantity * (1 - Discount)) AS DOCHOD 
FROM Products 
INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID 
INNER JOIN Orders ON Orders.OrderID = [Order Details].OrderID 
WHERE YEAR(OrderDate) = 1996 
GROUP BY ProductName 
ORDER BY DOCHOD ASC;



















-- Zad.2. Wyświetl wszystkich członków biblioteki (imię i nazwisko, adres) 
--  rozróżniając dorosłych i dzieci (dla dorosłych podaj liczbę dzieci),
--  którzy nigdy nie wypożyczyli książki

USE library2;

SELECT CONCAT(firstname, ' ', lastname) AS NAME, adult.street, COUNT(juvenile.adult_member_no) AS LICZBA_DZIECI, 'DOROSLY' AS WIEK
FROM member 
INNER JOIN adult ON adult.member_no = member.member_no 
LEFT JOIN juvenile ON juvenile.adult_member_no = member.member_no 
WHERE member.member_no NOT IN (SELECT member_no FROM loanhist) 
AND member.member_no NOT IN (SELECT member_no FROM loan)
GROUP BY CONCAT(firstname, ' ', lastname), adult.street
UNION 
SELECT CONCAT(firstname, ' ', lastname) AS NAME, adult.street, NULL AS LICZBA_DZIECI, 'DZIECKO' AS WIEK FROM member
INNER JOIN juvenile ON juvenile.member_no = member.member_no 
INNER JOIN adult ON adult.member_no = juvenile.adult_member_no 
WHERE member.member_no NOT IN (SELECT member_no FROM loanhist) 
AND member.member_no NOT IN (SELECT member_no FROM loan)
GROUP BY CONCAT(firstname, ' ', lastname), adult.street ORDER BY 1, 2







-- Zad.3. Wyświetl podsumowanie zamówień (całkowita cena + fracht) obsłużonych 
-- przez pracowników w lutym 1997 roku, uwzględnij wszystkich, nawet jeśli suma 
-- wyniosła 0.

USE Northwind2;

WITH TABLE1 AS (SELECT Employees.EmployeeID, FirstName, LastName, COUNT(Orders.OrderID) AS LICZBA_ZAMOWIEN,
ROUND(SUM([Order Details].UnitPrice * Quantity * (1 - Discount)) + SUM(Orders.Freight), 2) AS CALKOWITA_CENA
FROM Employees 
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID 
INNER JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID 
WHERE YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 2
GROUP BY Employees.EmployeeID, FirstName, LastName) 

SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName, 
ISNULL(TABLE1.LICZBA_ZAMOWIEN, 0) AS ILOSC,  ISNULL(TABLE1.CALKOWITA_CENA, 0) AS CENA
FROM TABLE1 
RIGHT JOIN Employees ON TABLE1.EmployeeID = Employees.EmployeeID ORDER BY ILOSC






/* zad 1)Podaj liczbę̨ zamówień oraz wartość zamówień (bez opłaty za przesyłkę)
 obsłużonych przez każdego pracownika w marcu 1997. Za datę obsłużenia
 zamówienia należy uznać datę jego złożenia (orderdate). Jeśli pracownik nie
 obsłużył w tym okresie żadnego zamówienia, to też powinien pojawić się na liście
 (liczba obsłużonych zamówień oraz ich wartość jest w takim przypadku równa 0).
 Zbiór wynikowy powinien zawierać: imię i nazwisko pracownika, liczbę obsłużonych
zamówień, wartość obsłużonych zamówień, oraz datę najpóźniejszego zamówienia
(w badanym okresie). (baza northwind) */

USE Northwind2;

SELECT Employees.EmployeeID, FirstName, LastName, COUNT(Orders.OrderID) 
AS LICZBA_ZAMOWIEN, ROUND(ISNULL(SUM(UnitPrice * Quantity - (1 - Discount)), 0), 2) AS WARTOSC_ZAMOWIEN, MAX(Orders.OrderDate)
FROM Employees 
RIGHT JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
FULL OUTER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID 
WHERE YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 3
GROUP BY Employees.EmployeeID, FirstName, LastName ORDER BY Employees.EmployeeID;








-- zad 2) Podaj listę dzieci będących członkami biblioteki, które w dniu '2001-12-14' nie
--		zwróciły do biblioteki książki o tytule 'Walking'. Zbiór wynikowy powinien zawierać
--		imię i nazwisko oraz dane adresowe dziecka. (baza library)


USE library2;

SELECT firstname, lastname, street, city, state, zip FROM member 
INNER JOIN juvenile ON juvenile.member_no = member.member_no 
INNER JOIN adult ON adult.member_no = juvenile.adult_member_no
WHERE member.member_no IN (SELECT member_no FROM loanhist INNER JOIN title ON title.title_no = loanhist.title_no 
WHERE title.title = 'Walking' AND YEAR(in_date) = 2001 AND MONTH(in_date) = 12 AND DAY(in_date) = 14 AND  DAY(due_date) <> 14 AND MONTH(due_date) >= )
ORDER BY juvenile.member_no






/*zad 3)
Dla każdego klienta podaj imię i nazwisko pracownika, który w 1997r obsłużył
najwięcej jego zamówień, podaj także liczbę tych zamówień (jeśli jest kilku takich
pracownikow to wystarczy podać imię nazwisko jednego nich). Zbiór wynikowy
powinien zawierać nazwę klienta, imię i nazwisko pracownika oraz liczbę
obsłużonych zamówień. (baza northwind)*/

USE Northwind2

SELECT TOP 1 WITH ties c.CustomerID, c.CompanyName, e.LastName, e.FirstName, COUNT(o.orderID) AS Order_Count
FROM Customers as c
JOIN Orders as o on o.CustomerID=c.CustomerID AND YEAR(o.OrderDate) = 1997
JOIN Employees as e on e.EmployeeID=o.EmployeeID
GROUP BY c.CustomerID, c.CompanyName, e.LastName, e.FirstName
ORDER BY ROW_NUMBER() OVER (PARTITION BY c.CustomerID, c.CompanyName ORDER BY COUNT(o.orderID) DESC)






/*zad 1)
Dla każdego pracownika podaj nazwę klienta, dla którego dany pracownik w 1997r
obsłużył najwięcej zamówień, podaj także liczbę tych zamówień (jeśli jest kilku
takich klientów to wystarczy podać nazwę jednego nich). Za datę obsłużenia
zamówienia należy przyjąć orderdate. Zbiór wynikowy powinien zawierać imię i
nazwisko pracownika, nazwę klienta, oraz liczbę obsłużonych zamówień. (baza
northwind)*/

USE Northwind2

SELECT TOP 1 WITH ties c.CustomerID, c.CompanyName, e.LastName, e.FirstName, COUNT(o.orderID) AS Order_Count
FROM Customers as c
JOIN Orders as o on o.CustomerID=c.CustomerID AND YEAR(o.OrderDate) = 1997
JOIN Employees as e on e.EmployeeID=o.EmployeeID
GROUP BY c.CustomerID, c.CompanyName, e.LastName, e.FirstName
ORDER BY ROW_NUMBER() OVER (PARTITION BY c.CustomerID, c.CompanyName ORDER BY COUNT(o.orderID) DESC)









/*zad 2)
Wyświetl numery zamówień złożonych w od marca do maja 1997, które były
przewożone przez firmę 'United Package' i nie zawierały produktów z kategorii
"confections". (baza northwind)*/


DECLARE @SHIPPPERID INT;

SET @SHIPPPERID = ( SELECT ShipperID FROM Shippers WHERE CompanyName LIKE 'United Package')


SELECT Orders.OrderID, OrderDate, ShipVia
FROM Orders 
INNER JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
INNER JOIN Products ON Products.ProductID = [Order Details].ProductID
INNER JOIN Categories ON Categories.CategoryID = Products.CategoryID
WHERE (MONTH(OrderDate) BETWEEN 3 AND 5) AND (YEAR(OrderDate) = 1997) AND ShipVia = @SHIPPPERID
AND CategoryName NOT LIKE 'confection'






/*zad 3)
Podaj tytuły książek wypożyczonych (aktualnie) przez dzieci mieszkające w Arizonie
(AZ). Zbiór wynikowy powinien zawierać imię i nazwisko członka biblioteki
(dziecka), jego adres oraz tytuł wypożyczonej książki. Jeśli jakieś dziecko
mieszkająca w Arizonie nie ma wypożyczonej żadnej książki to też powinno znaleźć
się na liście, a w polu przeznaczonym na tytuł książki powinien pojawić się napis
BRAK. (baza library)*/

USE library2

SELECT DISTINCT firstname, lastname, street, city, state, zip, ISNULL(title, 'BRAK') AS Wypozyczenie FROM member
LEFT JOIN loan ON member.member_no = loan.member_no
LEFT JOIN title ON title.title_no = loan.title_no
INNER JOIN juvenile on member.member_no = juvenile.member_no
INNER JOIN adult ON juvenile.adult_member_no = adult.member_no
WHERE state LIKE 'AZ'
