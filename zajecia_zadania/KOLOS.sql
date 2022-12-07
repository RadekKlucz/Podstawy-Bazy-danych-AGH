-- KOLOS Z WCZESNIEJSZYCH LAT 

-- Zad.1. Wyświetl produkt, który przyniósł najmniejszy, ale niezerowy, przychód w 1996 roku

-- MOJE
SELECT TOP 1 ProductName, SUM([Order Details].UnitPrice * Quantity * (1 - Discount)) AS DOCHOD FROM Products 
INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID 
INNER JOIN Orders ON Orders.OrderID = [Order Details].OrderID WHERE YEAR(OrderDate) = 1996 GROUP BY ProductName
ORDER BY DOCHOD ASC;


-- ROZW Z WIKI 

select top 5 P.ProductName, sum(od.Quantity*od.UnitPrice*(1-od.Discount)) from Products P 

    inner join [Order Details] od on P.ProductID = od.ProductID

    inner join Orders O on O.OrderID = od.OrderID

    where year(O.OrderDate) = 1996

    group by P.ProductName

    having sum(od.Quantity*od.UnitPrice*(1-od.Discount)) > 0

    order by sum(od.Quantity*od.UnitPrice*(1-od.Discount))

-- Zad.2. Wyświetl wszystkich członków biblioteki (imię i nazwisko, adres) 
--  rozróżniając dorosłych i dzieci (dla dorosłych podaj liczbę dzieci),
--  którzy nigdy nie wypożyczyli książki

USE library2;

WITH T AS (SELECT CONCAT(firstname, ' ', lastname) AS DZIECKO, adult_member_no FROM member INNER JOIN juvenile ON juvenile.member_no = member.member_no) 
SELECT * FROM T;


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


select m1.firstname +' '+m1.lastname as name, a.street, 

	'Adult',count(j.adult_member_no) as dzieci 

	from member m1

	inner join adult a on m1.member_no = a.member_no

	left join juvenile j on a.member_no = j.adult_member_no

	where m1.member_no not in (select lh.member_no from loanhist lh)

	and m1.member_no not in (select l.member_no from loan l)

	group by m1.firstname+' '+ m1.lastname, a.street

union

select m.firstname+' '+ m.lastname as name, a2.street,

	'Child', null 

	from member m

	inner join juvenile j2 on m.member_no = j2.member_no

	inner join adult a2 on j2.adult_member_no = a2.member_no

	where m.member_no not in (select lh.member_no from loanhist lh)

	and m.member_no not in (select l.member_no from loan l)

	group by m.firstname+' '+ m.lastname, a2.street

	order by 1,2


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
RIGHT JOIN Employees ON TABLE1.EmployeeID = Employees.EmployeeID ORDER BY 4




-- KOLOS WTOREK 

/* zad 1)Podaj liczbę̨ zamówień oraz wartość zamówień (bez opłaty za przesyłkę)
 obsłużonych przez każdego pracownika w marcu 1997. Za datę obsłużenia
 zamówienia należy uznać datę jego złożenia (orderdate). Jeśli pracownik nie
 obsłużył w tym okresie żadnego zamówienia, to też powinien pojawić się na liście
 (liczba obsłużonych zamówień oraz ich wartość jest w takim przypadku równa 0).
 Zbiór wynikowy powinien zawierać: imię i nazwisko pracownika, liczbę obsłużonych
zamówień, wartość obsłużonych zamówień, oraz datę najpóźniejszego zamówienia
(w badanym okresie). (baza northwind) */

USE Northwind2;

SELECT Employees.EmployeeID, FirstName, LastName, COUNT(Orders.OrderID) AS LICZBA_ZAMOWIEN, SUM(UnitPrice * Quantity - (1 - Discount)) AS WARTOSC_ZAMOWIEN
FROM Employees 
RIGHT JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
FULL OUTER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID 
WHERE YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 3
GROUP BY Employees.EmployeeID, FirstName, LastName ORDER BY Employees.EmployeeID;

-- CHYBNA OK

-- zad 2) Podaj listę dzieci będących członkami biblioteki, które w dniu '2001-12-14' nie
--		zwróciły do biblioteki książki o tytule 'Walking'. Zbiór wynikowy powinien zawierać
--		imię i nazwisko oraz dane adresowe dziecka. (baza library)


USE library2;

SELECT firstname, lastname, street, city, state, zip FROM member 
INNER JOIN juvenile ON juvenile.member_no = member.member_no 
INNER JOIN adult ON adult.member_no = juvenile.adult_member_no
WHERE member.member_no IN (SELECT member_no FROM loanhist INNER JOIN title ON title.title_no = loanhist.title_no WHERE title.title = 'Walking');


SELECT member_no, loanhist.title_no, title, due_date, in_date, out_date FROM loanhist INNER JOIN title ON title.title_no = loanhist.title_no WHERE title.title = 'Walking'

--NIE OK 

/*zad 3)
Dla każdego klienta podaj imię i nazwisko pracownika, który w 1997r obsłużył
najwięcej jego zamówień, podaj także liczbę tych zamówień (jeśli jest kilku takich
pracownikow to wystarczy podać imię nazwisko jednego nich). Zbiór wynikowy
powinien zawierać nazwę klienta, imię i nazwisko pracownika oraz liczbę
obsłużonych zamówień. (baza northwind)*/

SELECT DISTINCT Customers.CompanyName, Employees.FirstName, Employees.LastName, COUNT(Orders.OrderID) AS LICZBA_ZAMOWIEN FROM Employees 
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID 
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE YEAR(Orders.OrderDate) = 1997 
GROUP BY Customers.CompanyName, Employees.FirstName, Employees.LastName ORDER BY LICZBA_ZAMOWIEN 


-- BRAK POMYSLU DALEJ