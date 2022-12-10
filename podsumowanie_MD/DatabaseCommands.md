# KURS SQL

Krótki rzut oka na nomenklaturę podstawowych obiektów bazodanowe w różnych terminologiach. Od czystej teorii – do wdrożenia.

|Teoria relacyjna |	Model ER|	Relacyjne bazy	|Aplikacje|
|----|----|----|----|
Relacja	  |          Encja	 |   Tabela	  |      Klasa
Krotka	  |          Instancja	|Wiersz	   |     Instancja klasy (obiekt)
Atrybut	      |      Atrybut	 |   Kolumna	 |       Właściwość, atrybut
Dziedzina	   |     Dziedzina/Typ|	Typ danych	|Typ danych

## RELACYJNA BAZA DANYCH
Zgodnie z modelem E-R, to zbiór schematów RELACJI i ZWIĄZKÓW między nimi. 
Czyli struktur służących do przechowywania danych w ściśle zorganizowany sposób.

W praktyce będzie to zawsze zbiór tabel, w których przechowywane są dane. 
Ponadto tabele, posiadać będą określone powiązania (relacje) między sobą.

## RELACJA
W modelu E-R, to po prostu TABELA czyli struktura, przechowująca informacje o obiektach określonego typu. 
Używając języka programistów – KLASA obiektów określonego typu.

## ATRYBUT
Każda RELACJA jest opisana za pomocą zbioru ATRYBUTÓW. 
Warto dodać że ten zbiór powinien być zawsze minimalny, niezbędny do realizacji celów biznesowych.

ATRYBUT w praktyce, to nic innego jako KOLUMNA. Zatem tłumacząc na model relacyjny, każda TABELA opisana jest za pomocą zbioru KOLUMN. 
Każda KOLUMNA jest ściśle określona TYPEM DANYCH, czyli przechowuje wartości jednorodne, z określonej DZIEDZINY 

## SCHEMAT RELACJI
To po prostu jej definicja. Czyli informacja o strukturze, ATRYBUTACH które opisują daną RELACJĘ.

W praktyce będzie to struktura tabeli – czyli informacja przez jakie kolumny, jakiego typu jest ona opisana.

## KROTKA
To pojedynczy egzemplarz, czyli obiekt opisany wszystkimi ATRYBUTAMI danej RELACJI. KROTKA to nic innego jak WIERSZ czy REKORD. 
W języku programistów możemy mówić o EGZEMPLARZU danej KLASY.

## KLUCZE
Klucze to zbiory atrybutów mających określoną właściwość. Dzięki nim, możemy jednoznacznie identyfikować każdy pojedynczy wiersz. 
Znajomość pojęć kluczy podstawowych i obcych jest niezbędna do tworzenia zapytań, odwołujących się do wielu tabel. 
Możesz się spotkać z następującymi pojęciami typów kluczy :

## SUPERKLUCZ (NADKLUCZ)
Superkluczem nazywamy dowolny podzbiór atrybutów, identyfikujący jednoznacznie każdy wiersz. Każda RELACJA (tabela) może zawierać wiele takich kluczy. 
Szczególnym przypadkiem jest superklucz składający się ze wszystkich atrybutów (kolumn) danej tabeli.

## KLUCZ KANDYDUJĄCY
To dowolny z SUPERKLUCZY, mogący zostać kluczem podstawowym. W implementacji bazy danych, w praktyce nie istnieje jako niezależny osobny (zmaterializowany byt) jako taki. 
Jest to tylko założenie teoretyczne.

## KLUCZ PODSTAWOWY (PRIMARY KEY)
To wybrany (zazwyczaj najkrótszy), jednoznacznie identyfikujący każdy, pojedynczy wiersz, zbiór atrybutów (kolumn) danej relacji (tabeli). 
Jest to pierwszy z wymienionych do tej pory kluczy, któy ma faktyczne, fizyczne odwzorowania w implementacji bazy danych. Każda tabela może mieć tylko jeden taki klucz.

W praktyce, będzie to najczęściej jedna lub dwie kolumny w tabeli, jednoznacznie (UNIKALNIE) identyfikujący każdy wiersz. 
Nie można stworzyć klucza podstawowego, na zbiorze atrybutów nieunikalnych. Dwa wiersze nie mogą mieć takiej samej wartości klucza podstawowego.
KLUCZ OBCY
To atrybut lub zbiór atrybutów, wskazujący na KLUCZ GŁÓWNY w innej RELACJI (tabeli). Klucz obcy to nic innego jak związek, relacja między dwoma tabelami.

# Przykładowy schemat bazy danych

[]()

# Polecenia do tworzenia bazy danych


## Create a new database

```SQL
CREATE DATABASE databasename;
```

## Drop database (usunięcie bazy danych)

```SQL
DROP DATABASE databasename;
```

Tip: Make sure you have admin privilege before dropping any database. Once a database is dropped, you can check it in the list of databases with the following SQL command: **SHOW DATABASES;**

## BACKUP Database

To create a full backup database of an existing SQL database

```SQL
BACKUP DATABASE databasename
TO DISK = 'filepath';
```

A differential back up only backs up the parts of the database that have changed since the last full database backup.

```SQL
BACKUP DATABASE databasename
TO DISK = 'filepath'
WITH DIFFERENTILA;
```

## Create a table in the database

```SQL
CREATE TABLE table_name 
(
    column_name_1 datatype,
    column_name_2 datatype,
    .......
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
);
```
The PersonID column is of type int and will hold an integer.

The LastName, FirstName, Address, and City columns are of type varchar and will hold characters, and the maximum length for these fields is 255 characters.

Bellow is the link to the type of data in SQL Server:

[DataType](https://www.w3schools.com/sql/sql_datatypes.asp)

### Create Table Using Another Table

 copy of an existing table can also be created using CREATE TABLE.

The new table gets the same column definitions. All columns or specific columns can be selected.

If you create a new table using an existing table, the new table will be filled with the existing values from the old table.

```SQL
CREATE TABLE new_table_name AS 
    SELECT COL1, COL2... 
    FROM    existing_table_name
    WHERE ....;
```

The TRUNCATE TABLE statement is used to delete the data inside a table, but not the table itself.

```SQL
TRUNCATE TABLE new_table_name;
```

## The ALTER TABLE statement 

The ALTER TABLE statement is used to add, delete, or modify columns in an existing table.

The ALTER TABLE statement is also used to add and drop various constraints on an existing table.

```SQL
ALTER TABLE table_name
ADD column_name datatype;
```

### ALTER TABLE - DROP COLUMN

To delete a column in a table, use the following syntax (notice that some database systems don't allow deleting a column):

```SQL
ALTER TABLE table_name 
DROP COLUMN column_name;
```
### ALTER TABLE - ALTER/MODIFY COLUMN
To change the data type of a column in a table, use the following syntax:

```SQL
ALTER TABLE table_name
ALTER COLUMN column_name datatype;
```

## SQL Constraints

