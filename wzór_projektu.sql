USE master
IF DB_ID('Baza_Konferencje') IS NOT NULL
DROP DATABASE Baza_Konferencje
GO
CREATE DATABASE Baza_Konferencje
GO
USE Baza_Konferencje
GO

--tabele
IF OBJECT_ID('Warsztaty_Rejestracje', 'U') IS NOT NULL 
DROP TABLE Warsztaty_Rejestracje;
IF OBJECT_ID('Dni_Konferencji_Rejestracje', 'U') IS NOT NULL 
DROP TABLE Dni_Konferencji_Rejestracje;
IF OBJECT_ID('Uczestnicy', 'U') IS NOT NULL 
DROP TABLE Uczestnicy;
IF OBJECT_ID('Dni_Konferencji_Rezerwacje', 'U') IS NOT NULL 
DROP TABLE Dni_Konferencji_Rezerwacje;
IF OBJECT_ID('Warsztaty_Rezerwacje', 'U') IS NOT NULL 
DROP TABLE Warsztaty_Rezerwacje;
IF OBJECT_ID('Warsztaty', 'U') IS NOT NULL 
DROP TABLE Warsztaty;
IF OBJECT_ID('Dni_Konferencji', 'U') IS NOT NULL 
DROP TABLE Dni_Konferencji;
IF OBJECT_ID('Konferencje', 'U') IS NOT NULL 
DROP TABLE Konferencje;
IF OBJECT_ID('Klienci', 'U') IS NOT NULL 
DROP TABLE Klienci;

CREATE TABLE Konferencje (
  ID_Konferencji int IDENTITY(1, 1) NOT NULL,
  Nazwa varchar(50) UNIQUE NOT NULL,	--unique a nie pk ze wzgledu na oszczednosc miejsca
  Miasto varchar(50) NOT NULL,
  Ulica varchar(50) NOT NULL,
  Nr_Budynku int NOT NULL,
  Kod_Pocztowy char(6) NOT NULL,
  PRIMARY KEY(ID_Konferencji),
  CONSTRAINT Kod_Pocztowy_Konf CHECK (Kod_Pocztowy LIKE '[0-9][0-9]-[0-9][0-9][0-9]'), --sprawdzic mozliwosc zmiany na \d\d\d\d\d, ew. \d{2}-\d{3}
  CONSTRAINT Nr_Budynku_Konf CHECK (Nr_Budynku > 0)
)

CREATE TABLE Dni_Konferencji (
  ID_Dnia_Konferencji int IDENTITY(1, 1) NOT NULL,
  ID_Konferencji int FOREIGN KEY REFERENCES Konferencje(ID_Konferencji) NOT NULL,
  Data date NOT NULL,
  Cena_Bazowa money NOT NULL,
  Znizka_Studencka int NOT NULL,
  Liczba_Miejsc int NOT NULL,
  PRIMARY KEY(ID_Dnia_Konferencji),
  CONSTRAINT Wysokosc_Znizki_DK CHECK (Znizka_Studencka BETWEEN 0 AND 100),
  CONSTRAINT Liczba_Miejsc_DK CHECK (Liczba_Miejsc > 0)
)

CREATE TABLE Warsztaty (
  ID_Warsztatu int IDENTITY(1, 1) NOT NULL,
  ID_Dnia_Konferencji int FOREIGN KEY REFERENCES Dni_Konferencji(ID_Dnia_Konferencji) NOT NULL,
  Temat varchar(50) NOT NULL,
  Cena money NOT NULL,
  Liczba_miejsc int NOT NULL,
  Godzina_Rozpoczecia time NOT NULL,
  Godzina_Zakonczenia time NOT NULL,
  PRIMARY KEY(ID_Warsztatu),
  CONSTRAINT Liczba_Miejsc_War CHECK (Liczba_Miejsc > 0)
)

CREATE TABLE Klienci (
  Nazwa varchar(50)	UNIQUE NOT NULL,
  NIP char(10) NOT NULL,
  Nr_Konta varchar(50),
  Nr_Telefonu varchar(15) NOT NULL,
  Email varchar(50),
  Miasto varchar(50) NOT NULL,
  Ulica varchar(50) NOT NULL,
  Nr_Budynku int NOT NULL,
  Nr_Lokalu int,
  Kod_Pocztowy 	varchar(50) NOT NULL,
  PRIMARY KEY(NIP),
  CONSTRAINT Sprawdz_Email_Kl CHECK (Email LIKE '%_@_%._%'),
  CONSTRAINT Sprawdz_NIP_Kl CHECK (NIP LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  CONSTRAINT Kod_Pocztowy_Kl CHECK (Kod_pocztowy LIKE '[0-9][0-9]-[0-9][0-9][0-9]'), 
  CONSTRAINT Nr_Budynku_Kl CHECK (Nr_Budynku > 0),
  CONSTRAINT Nr_Lokalu_Kl CHECK (Nr_Lokalu > 0 OR Nr_Lokalu IS NULL)
)

CREATE TABLE Uczestnicy (
  ID_Uczestnika char(11) not null,
  NIP_Klienta char(10) FOREIGN KEY REFERENCES Klienci(NIP) NOT NULL,
  Imie varchar(50) NOT NULL,	
  Nazwisko varchar(50) NOT NULL,
  Nr_Legitymacji int,
  PRIMARY KEY(ID_Uczestnika),
  CONSTRAINT Nr_Legitymacji_Ucz CHECK (Nr_Legitymacji LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'),
  CONSTRAINT ID_Ucz_PESEL CHECK (ID_Uczestnika LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)

CREATE TABLE Warsztaty_Rezerwacje (
  ID_Rezerwacji int IDENTITY(1, 1) NOT NULL,
  ID_Warsztatu int FOREIGN KEY REFERENCES Warsztaty(ID_Warsztatu) NOT NULL,
  NIP_Klienta char(10) FOREIGN KEY REFERENCES Klienci(NIP) NOT NULL,
  Liczba_Miejsc int NOT NULL,
  Data_Rezerwacji date DEFAULT GETDATE() NOT NULL,
  Data_Anulowania date,
  Kwota_Do_Zaplaty money DEFAULT 0 NOT NULL,
  Kwota_Zaplacona money DEFAULT 0 NOT NULL,
  PRIMARY KEY(ID_Rezerwacji),
  CONSTRAINT Liczba_Miejsc_WR CHECK (Liczba_Miejsc > 0)
)

CREATE TABLE Dni_Konferencji_Rezerwacje (
  ID_Rezerwacji int IDENTITY(1, 1) NOT NULL,
  ID_Dnia_Konferencji int FOREIGN KEY REFERENCES Dni_Konferencji(ID_Dnia_Konferencji) NOT NULL,
  NIP_Klienta char(10) FOREIGN KEY REFERENCES Klienci(NIP) NOT NULL,
  Liczba_Miejsc int NOT NULL,
  Data_Rezerwacji date DEFAULT GETDATE() NOT NULL,
  Data_Anulowania date,
  Kwota_Do_Zaplaty money DEFAULT 0 NOT NULL,
  Kwota_Zaplacona money DEFAULT 0 NOT NULL,
  PRIMARY KEY(ID_Rezerwacji),
  CONSTRAINT Liczba_Miejsc_DKR CHECK (Liczba_Miejsc > 0)
)

CREATE TABLE Dni_Konferencji_Rejestracje (
  ID_Rejestracji int IDENTITY(1, 1) NOT NULL,
  ID_Rezerwacji int FOREIGN KEY REFERENCES Dni_Konferencji_Rezerwacje(ID_Rezerwacji) NOT NULL,
  ID_Uczestnika char(11) FOREIGN KEY REFERENCES Uczestnicy(ID_Uczestnika) NOT NULL,
  Data_Rejestracji date DEFAULT GETDATE() NOT NULL,
  Data_Anulowania date,
  PRIMARY KEY(ID_Rejestracji),
)

CREATE TABLE Warsztaty_Rejestracje (
  ID_Rezerwacji int FOREIGN KEY REFERENCES Warsztaty_Rezerwacje(ID_Rezerwacji) NOT NULL,
  ID_Rejestracji int FOREIGN KEY REFERENCES Dni_Konferencji_Rejestracje(ID_Rejestracji) NOT NULL,
  Data_Rejestracji date DEFAULT GETDATE() NOT NULL,
  Data_Anulowania date,
)

--funkcje
IF OBJECT_ID('Dzien_Konferencji_Wolne_Miejsca') IS NOT NULL
DROP FUNCTION Dzien_Konferencji_Wolne_Miejsca
GO
IF OBJECT_ID('Warsztat_Wolne_Miejsca') IS NOT NULL
DROP FUNCTION Warsztat_Wolne_Miejsca
GO
IF OBJECT_ID('Rezerwacja_Dnia_Wolne_Miejsca') IS NOT NULL
DROP FUNCTION Rezerwacja_Dnia_Wolne_Miejsca
GO
IF OBJECT_ID('Rezerwacja_Warsztatu_Wolne_Miejsca') IS NOT NULL
DROP FUNCTION Rezerwacja_Warsztatu_Wolne_Miejsca
GO

CREATE FUNCTION Dzien_Konferencji_Wolne_Miejsca(@ID_Dnia int)
	RETURNS int
	AS
	BEGIN
		DECLARE @Miejsca AS int
		SET @Miejsca = (
			SELECT Liczba_Miejsc
			FROM Dni_Konferencji
			WHERE ID_Dnia_Konferencji = @ID_Dnia
		)
		DECLARE @Zajete AS int
		SET @Zajete = (
			SELECT SUM(Liczba_Miejsc)
			FROM Dni_Konferencji_Rezerwacje
			WHERE ID_Dnia_Konferencji = @ID_Dnia AND Data_Anulowania IS NULL
		)
		IF @Zajete IS NULL
		BEGIN
			SET @Zajete = 0
		END
		RETURN (@Miejsca - @Zajete)
	END
GO

CREATE FUNCTION Warsztat_Wolne_Miejsca(@ID_Warsztatu int)
	RETURNS int
	AS
	BEGIN
		DECLARE @Miejsca AS int
		SET @Miejsca = (
			SELECT Liczba_Miejsc
			FROM Warsztaty
			WHERE ID_Warsztatu = @ID_Warsztatu
		)
		DECLARE @Zajete AS int
		SET @Zajete = (
			SELECT SUM(Liczba_Miejsc)
			FROM Warsztaty_Rezerwacje
			WHERE ID_Warsztatu = @ID_Warsztatu AND Data_Anulowania IS NULL
		)
		IF @Zajete IS NULL
		BEGIN
			SET @Zajete = 0
		END
		RETURN (@Miejsca - @Zajete)
	END
GO
CREATE FUNCTION Rezerwacja_Dnia_Wolne_Miejsca(@ID_Rezerwacji int)
	RETURNS int
	AS
	BEGIN
		DECLARE @Miejsca AS int
		SET @Miejsca = (
			SELECT Liczba_Miejsc
			FROM Dni_Konferencji_Rezerwacje
			WHERE ID_Rezerwacji = @ID_Rezerwacji
		)
		DECLARE @Zajete AS int
		SET @Zajete = (
			SELECT COUNT(*)
			FROM Dni_Konferencji_Rejestracje
			WHERE ID_Rezerwacji = @ID_Rezerwacji AND Data_Anulowania IS NULL
		)
		IF @Zajete IS NULL
		BEGIN
			SET @Zajete = 0
		END
		RETURN (@Miejsca - @Zajete)
	END
GO

CREATE FUNCTION Rezerwacja_Warsztatu_Wolne_Miejsca(@ID_Rezerwacji int)
	RETURNS int
	AS
	BEGIN
		DECLARE @Miejsca AS int
		SET @Miejsca = (
			SELECT Liczba_Miejsc
			FROM Warsztaty_Rezerwacje
			WHERE ID_Rezerwacji = @ID_Rezerwacji
		)
		DECLARE @Zajete AS int
		SET @Zajete = (
			SELECT COUNT(*)
			FROM Warsztaty_Rejestracje
			WHERE ID_Rezerwacji = @ID_Rezerwacji AND Data_Anulowania IS NULL
		)
		IF @Zajete IS NULL
		BEGIN
			SET @Zajete = 0
		END
		RETURN (@Miejsca - @Zajete)
	END
GO


--funkcje pomocnicze
IF OBJECT_ID('Pobierz_ID_Dnia') IS NOT NULL
DROP FUNCTION Pobierz_ID_Dnia
GO
IF OBJECT_ID('Pobierz_ID_Warsztatu') IS NOT NULL
DROP FUNCTION Pobierz_ID_Warsztatu
GO

CREATE FUNCTION Pobierz_ID_Dnia(@Nazwa_Konf varchar(50), @Data date)
	RETURNS int
	AS
	BEGIN
		DECLARE @ID_Dnia AS int
		SET @ID_Dnia = ( 
			SELECT ID_Dnia_Konferencji
			FROM Dni_Konferencji
			WHERE Data = @Data AND ID_Konferencji = (
				SELECT ID_Konferencji
				FROM Konferencje
				WHERE Nazwa = @Nazwa_Konf
			)
		)
		RETURN @ID_Dnia
	END
GO

CREATE FUNCTION Pobierz_ID_Warsztatu(@Nazwa_Konf varchar(50), @Data date, @Temat varchar(50))
	RETURNS int
	AS
	BEGIN
		DECLARE @ID_Warsztatu AS int
		SET @ID_Warsztatu = (
			SELECT ID_Warsztatu
			FROM Warsztaty
			WHERE Temat = @Temat AND ID_Dnia_Konferencji = (
				SELECT ID_Dnia_Konferencji
				FROM Dni_Konferencji
				WHERE Data = @Data AND ID_Konferencji = (
					SELECT ID_Konferencji
					FROM Konferencje
					WHERE Nazwa = @Nazwa_Konf
				)				
			)
		)
		RETURN @ID_Warsztatu
	END
GO

--triggery
IF OBJECT_ID('Anuluj_Rejestracje_Warsztatu_Trigger_Rez') IS NOT NULL
DROP TRIGGER Anuluj_Rejestracje_Warsztatu_Trigger_Rez
GO

IF OBJECT_ID('Anuluj_Rejestracje_Warsztatu_Trigger_Rej') IS NOT NULL
DROP TRIGGER Anuluj_Rejestracje_Warsztatu_Trigger_Rej
GO

IF OBJECT_ID('Anuluj_Rejestracje_Dnia_Trigger_Rez') IS NOT NULL
DROP TRIGGER Anuluj_Rejestracje_Dnia_Trigger_Rez
GO

CREATE TRIGGER Anuluj_Rejestracje_Warsztatu_Trigger_Rez
	ON Warsztaty_Rezerwacje
	FOR UPDATE
	AS
	BEGIN
		IF UPDATE(Data_Anulowania)
		BEGIN
			DECLARE @ID_Rez AS int
			SET @ID_Rez = (SELECT ID_Rezerwacji FROM INSERTED)
			
			UPDATE Warsztaty_Rejestracje
			SET Data_Anulowania = GETDATE()
			WHERE ID_Rezerwacji = @ID_Rez
		END
	END
GO

CREATE TRIGGER Anuluj_Rejestracje_Warsztatu_Trigger_Rej
	ON Dni_Konferencji_Rejestracje
	FOR UPDATE
	AS
	BEGIN
		IF UPDATE(Data_Anulowania)
		BEGIN
			DECLARE @ID_Rej AS int
			SET @ID_Rej = (SELECT ID_Rejestracji FROM INSERTED)
			
			UPDATE Warsztaty_Rejestracje
			SET Data_Anulowania = GETDATE()
			WHERE ID_Rejestracji = @ID_Rej
		END
	END
GO

CREATE TRIGGER Anuluj_Rejestracje_Dnia_Trigger_Rez
	ON Dni_Konferencji_Rezerwacje
	FOR UPDATE
	AS
	BEGIN
		IF UPDATE(Data_Anulowania)
		BEGIN
			DECLARE @ID_Rez AS int
			SET @ID_Rez = (SELECT ID_Rezerwacji FROM INSERTED)
			
			UPDATE Dni_Konferencji_Rejestracje
			SET Data_Anulowania = GETDATE()
			WHERE ID_Rezerwacji = @ID_Rez
		END	
	END
GO

--procedury
IF OBJECT_ID('Dodaj_Konferencje') IS NOT NULL 
DROP PROC Dodaj_Konferencje;
GO
IF OBJECT_ID('Dodaj_Dzien_Konferencji') IS NOT NULL 
DROP PROC Dodaj_Dzien_Konferencji;
GO
IF OBJECT_ID('Dodaj_Warsztat') IS NOT NULL 
DROP PROC Dodaj_Warsztat;
GO
IF OBJECT_ID('Dodaj_Klienta') IS NOT NULL 
DROP PROC Dodaj_Klienta;
GO
IF OBJECT_ID('Dodaj_Uczestnika') IS NOT NULL 
DROP PROC Dodaj_Uczestnika;
GO
IF OBJECT_ID('Dodaj_Rezerwacje_Dnia') IS NOT NULL
DROP PROC Dodaj_Rezerwacje_Dnia
GO
IF OBJECT_ID('Dodaj_Rezerwacje_Warsztatu') IS NOT NULL
DROP PROC Dodaj_Rezerwacje_Warsztatu
GO
IF OBJECT_ID('Dodaj_Rejestracje_Dnia') IS NOT NULL
DROP PROC Dodaj_Rejestracje_Dnia
GO
IF OBJECT_ID('Dodaj_Rejestracje_Warsztatu') IS NOT NULL
DROP PROC Dodaj_Rejestracje_Warsztatu
GO


CREATE PROCEDURE Dodaj_Konferencje
	@Nazwa varchar(50),
	@Miasto varchar(50),
	@Ulica varchar(50),
	@Nr_Budynku int,
	@Kod_Pocztowy varchar(50)
	AS 
	BEGIN
		SET NOCOUNT ON;
		INSERT INTO Konferencje
		(Nazwa, Miasto, Ulica, Nr_Budynku, Kod_Pocztowy) 
		VALUES (@Nazwa, @Miasto, @Ulica, @Nr_Budynku, @Kod_Pocztowy)
	END
GO

CREATE PROCEDURE Dodaj_Dzien_Konferencji
	@Nazwa_Konferencji varchar(50),
	@Data date,
	@Cena_Bazowa money,
	@Znizka_Studencka int,
	@Liczba_Miejsc int
	AS
	BEGIN
		SET NOCOUNT ON;
		DECLARE @ID_Konf AS int
		SET @ID_Konf = (
			SELECT ID_Konferencji 
			FROM Konferencje
			WHERE Nazwa = @Nazwa_Konferencji		
		)
		INSERT INTO Dni_Konferencji
		(ID_Konferencji, Data, Cena_bazowa, Znizka_Studencka, Liczba_miejsc)
		VALUES (@ID_Konf, @Data, @Cena_Bazowa, @Znizka_Studencka, @Liczba_Miejsc)
	END
GO

CREATE PROCEDURE Dodaj_Warsztat
	@Nazwa_Konf varchar(50),
	@Data date,
	@Temat varchar(50),
	@Cena money,
	@Liczba_miejsc int,
	@Godzina_Rozpoczecia time,
	@Godzina_Zakonczenia time
	AS
	BEGIN
		SET NOCOUNT ON;
		DECLARE @ID_Dnia AS int
		SET @ID_Dnia = dbo.Pobierz_ID_Dnia(@Nazwa_Konf, @Data)
		INSERT INTO Warsztaty
		(ID_Dnia_Konferencji, Temat, Liczba_miejsc, Cena, Godzina_Rozpoczecia, Godzina_Zakonczenia)
		VALUES (@ID_Dnia, @Temat, @Liczba_miejsc, @Cena, @Godzina_Rozpoczecia, @Godzina_Zakonczenia)
	END
GO

CREATE PROCEDURE Dodaj_Klienta
	@Nazwa varchar(50),
	@NIP char(10),
	@Nr_Telefonu varchar(15),
	@Miasto varchar(50),
	@Ulica varchar(50),
	@Kod_Pocztowy varchar(50),
	@Nr_Budynku int,
	@Nr_Lokalu int = null,
	@Nr_Konta varchar(50) = null,
	@Email varchar(50) = null
	AS
	BEGIN
		SET NOCOUNT ON;
		INSERT INTO Klienci
		(Nazwa, NIP, Nr_telefonu, Miasto, Ulica, Kod_pocztowy, Nr_budynku, Nr_lokalu, Nr_konta, Email)
		VALUES (@Nazwa, @NIP, @Nr_Telefonu, @Miasto, @Ulica, @Kod_Pocztowy, @Nr_Budynku, @Nr_Lokalu, @Nr_Konta, @Email)
	END
GO

CREATE PROCEDURE Dodaj_Uczestnika
	@NIP_Klienta char(10),
	@PESEL char(11),
	@Imie varchar(50),
	@Nazwisko varchar(50),
	@Nr_Legitymacji int = null
	AS
	BEGIN
		SET NOCOUNT ON;
		INSERT INTO Uczestnicy
		(ID_Uczestnika, Imie, Nazwisko, NIP_Klienta, Nr_Legitymacji)
		VALUES (@PESEL, @Imie, @Nazwisko, @NIP_Klienta, @Nr_Legitymacji)
	END
GO

CREATE PROCEDURE Dodaj_Rezerwacje_Dnia
	@Nazwa_Konf varchar(50),
	@Data date,
	@NIP_Klienta char(10),
	@Liczba_Miejsc int
	AS
	BEGIN
		SET NOCOUNT ON;
		DECLARE @ID_Dnia AS int
		SET @ID_Dnia = dbo.Pobierz_ID_Dnia(@Nazwa_Konf, @Data)
		DECLARE @Znizka AS float
		SET @Znizka = 1 - DATEDIFF(WEEK, GETDATE(), @Data)/100
		IF (@Znizka < 0.9) BEGIN
			SET @Znizka = 0.9
		END
		DECLARE @Do_zaplaty money
		SET @Do_zaplaty = (
			SELECT Cena_bazowa
			FROM Dni_Konferencji
			WHERE ID_Dnia_Konferencji = @ID_Dnia
		) * @Liczba_Miejsc * @Znizka
		
		IF dbo.Dzien_Konferencji_Wolne_Miejsca(@ID_Dnia) >= @Liczba_Miejsc
		BEGIN
			INSERT INTO Dni_Konferencji_Rezerwacje
			(ID_Dnia_Konferencji, NIP_Klienta, Liczba_Miejsc, Kwota_do_zaplaty)
			VALUES (@ID_Dnia, @NIP_Klienta, @Liczba_Miejsc, @Do_zaplaty)
		END
	END
GO

CREATE PROCEDURE Dodaj_Rezerwacje_Warsztatu
	@Nazwa_Konf varchar(50),
	@Data date,
	@Temat varchar(50),
	@Liczba_Miejsc int,
	@NIP_Klienta char(10)
	AS
	BEGIN
		SET NOCOUNT ON;
		DECLARE @ID_War AS int
		SET @ID_War = dbo.Pobierz_ID_Warsztatu(@Nazwa_Konf, @Data, @Temat)
		
		DECLARE @Do_zaplaty money
		SET @Do_zaplaty = (
			SELECT Cena
			FROM Warsztaty
			WHERE ID_Warsztatu = @ID_War
		) * @Liczba_Miejsc
		
		IF dbo.Warsztat_Wolne_Miejsca(@ID_War) >= @Liczba_Miejsc
		BEGIN
			INSERT INTO Warsztaty_Rezerwacje
			(ID_Warsztatu, NIP_Klienta, Liczba_Miejsc, Kwota_do_zaplaty)
			VALUES (@ID_War, @NIP_Klienta, @Liczba_Miejsc, @Do_zaplaty)
		END
	END
GO

CREATE PROCEDURE Dodaj_Rejestracje_Dnia
	@NIP_Klienta varchar(50),
	@PESEL char(11),
	@Nazwa_Konf varchar(50),
	@Data date
	AS
	BEGIN
		SET NOCOUNT ON;	
		DECLARE @ID_Rez AS int
		SET @ID_Rez = (
			SELECT ID_Rezerwacji
			FROM Dni_Konferencji_Rezerwacje 
			WHERE ID_Dnia_Konferencji = dbo.Pobierz_ID_Dnia(@Nazwa_Konf, @Data) 
				AND NIP_Klienta = @NIP_Klienta
		)
		DECLARE @Data_Rezerwacji AS date
		SET @Data_Rezerwacji = (
			SELECT Data_Rezerwacji
			FROM Dni_Konferencji_Rezerwacje
			WHERE ID_Dnia_Konferencji = dbo.Pobierz_ID_Dnia(@Nazwa_Konf, @Data) 
			AND NIP_Klienta = @NIP_Klienta
		)
		
		DECLARE @Znizka1 AS float
		SET @Znizka1 = 1 - DATEDIFF(WEEK, @Data_Rezerwacji, @Data)/100
		IF (@Znizka1 < 0.9) BEGIN
			SET @Znizka1 = 0.9
		END
		
		DECLARE @Znizka2 AS float
		SET @Znizka2 = (
			SELECT COUNT(*)
			FROM Dni_Konferencji_Rejestracje JOIN Uczestnicy
			ON Dni_Konferencji_Rejestracje.ID_Uczestnika = Uczestnicy.ID_Uczestnika
			WHERE ID_Rezerwacji = @ID_Rez AND Nr_Legitymacji IS NOT NULL
		) / (SELECT Liczba_Miejsc FROM Dni_Konferencji_Rezerwacje WHERE ID_Rezerwacji = @ID_Rez)
		SET @Znizka2 = 1 - @Znizka2 * (
			SELECT Znizka_Studencka
			FROM Dni_Konferencji
			WHERE ID_Dnia_Konferencji = dbo.Pobierz_ID_Dnia(@Nazwa_Konf, @Data) 
		)
		
		IF dbo.Rezerwacja_Dnia_Wolne_Miejsca(@ID_Rez) > 0
		BEGIN 
			BEGIN TRANSACTION 
				INSERT INTO Dni_Konferencji_Rejestracje
				(ID_Rezerwacji, ID_Uczestnika)
				VALUES (@ID_Rez, @PESEL)
				
				IF @@ERROR <> 0
				BEGIN
					RAISERROR('error', 16, 1)
					ROLLBACK TRANSACTION
				END
				
				UPDATE Dni_Konferencji_Rezerwacje
				SET Kwota_Do_Zaplaty = (
					SELECT Liczba_Miejsc * (
						SELECT Cena_Bazowa
						FROM Dni_Konferencji
						WHERE ID_Dnia_Konferencji = dbo.Pobierz_ID_Dnia(@Nazwa_Konf, @Data)
					)
					FROM Dni_Konferencji_Rezerwacje
					WHERE ID_Rezerwacji = @ID_Rez
				) * @Znizka1 * @Znizka2
				WHERE ID_Rezerwacji = @ID_Rez
				
				IF @@ERROR <> 0
				BEGIN
					RAISERROR('error', 16, 1)
					ROLLBACK TRANSACTION
				END
			COMMIT TRANSACTION
		END
	END
GO

CREATE PROCEDURE Dodaj_Rejestracje_Warsztatu
	@NIP_Klienta char(10),
	@PESEL char(11),
	@Nazwa_Konf varchar(50),
	@Data date,
	@Temat varchar(50)
	AS
	BEGIN
		SET NOCOUNT ON;
		DECLARE @ID_Rez_War AS int
		SET @ID_Rez_War = (
			SELECT ID_Rezerwacji
			FROM Warsztaty_Rezerwacje 
			WHERE NIP_Klienta = @NIP_Klienta 
				AND ID_Warsztatu = dbo.Pobierz_ID_Warsztatu(@Nazwa_Konf, @Data, @Temat)
		)
		DECLARE @ID_Rej AS int 
		SET @ID_Rej = (
			SELECT ID_Rejestracji
			FROM Dni_Konferencji_Rejestracje
			WHERE ID_Uczestnika = @PESEL AND ID_Rezerwacji = (
				SELECT ID_Rezerwacji
				FROM Dni_Konferencji_Rezerwacje 
				WHERE NIP_Klienta = @NIP_Klienta 
					AND ID_Dnia_Konferencji = dbo.Pobierz_ID_Dnia(@Nazwa_Konf, @Data)
			)
		)
		DECLARE @Godzina_Rozpoczecia AS time
		SET @Godzina_Rozpoczecia = (
			SELECT Godzina_Rozpoczecia 
			FROM Warsztaty 
			WHERE ID_Warsztatu = dbo.Pobierz_ID_Warsztatu(@Nazwa_Konf, @Data, @Temat)
		)
		DECLARE @Godzina_Zakonczenia AS time
		SET @Godzina_Zakonczenia = (
			SELECT Godzina_Zakonczenia
			FROM Warsztaty 
			WHERE ID_Warsztatu = dbo.Pobierz_ID_Warsztatu(@Nazwa_Konf, @Data, @Temat)
		)
		DECLARE @Trwajace_Warsztaty AS int
		SET @Trwajace_Warsztaty = (
			SELECT COUNT(*)
			FROM Warsztaty
			WHERE ID_Warsztatu in (
				SELECT ID_Warsztatu
				FROM Warsztaty_Rezerwacje
				WHERE ID_Rezerwacji in (
					SELECT ID_Rezerwacji
					FROM Warsztaty_Rejestracje
					WHERE ID_Rejestracji = @ID_Rej AND Data_Anulowania IS NULL --w tym samym dniu konferencji dla danego uczestnika
				)
			) AND (@Godzina_Rozpoczecia BETWEEN Godzina_Rozpoczecia AND Godzina_Zakonczenia
				OR @Godzina_Zakonczenia BETWEEN Godzina_Rozpoczecia AND Godzina_Zakonczenia)
		)
		
		IF dbo.Rezerwacja_Warsztatu_Wolne_Miejsca(@ID_Rez_War) > 0 AND @Trwajace_Warsztaty = 0
		BEGIN
			INSERT INTO Warsztaty_Rejestracje
			(ID_Rejestracji, ID_Rezerwacji)
			VALUES (@ID_Rej, @ID_Rez_War)
		END
	END
GO

IF OBJECT_ID('Anuluj_Rejestracje_Warsztatu') IS NOT NULL
DROP PROC Anuluj_Rejestracje_Warsztatu
GO

IF OBJECT_ID('Anuluj_Rezerwacje_Warsztatu') IS NOT NULL
DROP PROC Anuluj_Rezerwacje_Warsztatu
GO

IF OBJECT_ID('Anuluj_Rejestracje_Dnia') IS NOT NULL
DROP PROC Anuluj_Rejestracje_Dnia
GO

IF OBJECT_ID('Anuluj_Rezerwacje_Dnia') IS NOT NULL
DROP PROC Anuluj_Rezerwacje_Dnia
GO

CREATE PROCEDURE Anuluj_Rejestracje_Warsztatu
	@Nazwa_Konf varchar(50),
	@Data date,
	@Temat varchar(50),
	@PESEL char(11)
	AS
	BEGIN
		SET NOCOUNT ON;
		DECLARE @NIP_Klienta AS char(10)
		SET @NIP_Klienta = (
			SELECT NIP_Klienta
			FROM Uczestnicy
			WHERE ID_Uczestnika = @PESEL
		)
		DECLARE @ID_Rez_War AS int
		SET @ID_Rez_War = (
			SELECT ID_Rezerwacji
			FROM Warsztaty_Rezerwacje 
			WHERE NIP_Klienta = @NIP_Klienta 
				AND ID_Warsztatu = dbo.Pobierz_ID_Warsztatu(@Nazwa_Konf, @Data, @Temat)
		)
		DECLARE @ID_Rej AS int 
		SET @ID_Rej = (
			SELECT ID_Rejestracji
			FROM Dni_Konferencji_Rejestracje
			WHERE ID_Uczestnika = @PESEL AND ID_Rezerwacji = (
				SELECT ID_Rezerwacji
				FROM Dni_Konferencji_Rezerwacje 
				WHERE NIP_Klienta = @NIP_Klienta 
					AND ID_Dnia_Konferencji = dbo.Pobierz_ID_Dnia(@Nazwa_Konf, @Data)
			)
		)
		UPDATE Warsztaty_Rejestracje
		SET Data_Anulowania = GETDATE()
		WHERE ID_Rejestracji = @ID_Rej AND ID_Rezerwacji = @ID_Rez_War
	END
GO

CREATE PROCEDURE Anuluj_Rezerwacje_Warsztatu
	@NIP_Klienta char(10),
	@Nazwa_Konf varchar(50),
	@Data date,
	@Temat varchar(50)
	AS
	BEGIN
		SET NOCOUNT ON;
		DECLARE @ID_Rez AS int
		SET @ID_Rez = (
			SELECT ID_Rezerwacji 
			FROM Warsztaty_Rezerwacje
			WHERE NIP_Klienta = @NIP_Klienta 
				AND ID_Warsztatu = dbo.Pobierz_ID_Warsztatu(@Nazwa_Konf, @Data, @Temat)
		)
		
		UPDATE Warsztaty_Rezerwacje
		SET Data_Anulowania = GETDATE()
		WHERE ID_Rezerwacji = @ID_Rez
	END
GO

CREATE PROCEDURE Anuluj_Rejestracje_Dnia
	@Nazwa_Konf varchar(50),
	@Data date,
	@PESEL char(11)
	AS
	BEGIN
	SET NOCOUNT ON;	
		DECLARE @ID_Rej AS int
		SET @ID_Rej = (
			SELECT ID_Rejestracji
			FROM Dni_Konferencji_Rejestracje
			WHERE ID_Rejestracji = (
				SELECT ID_Rezerwacji
				FROM Dni_Konferencji_Rezerwacje 
				WHERE ID_Dnia_Konferencji = dbo.Pobierz_ID_Dnia(@Nazwa_Konf, @Data) 
					AND NIP_Klienta = (
						SELECT NIP_Klienta
						FROM Uczestnicy
						WHERE ID_Uczestnika = @PESEL
				)
			)
		)
		UPDATE Dni_Konferencji_Rejestracje
		SET Data_Anulowania = GETDATE()
		WHERE ID_Rejestracji = @ID_Rej
	END
GO

CREATE PROCEDURE Anuluj_Rezerwacje_Dnia
	@NIP_Klienta char(10),
	@Nazwa_Konf varchar(50),
	@Data date
	AS
	BEGIN
	SET NOCOUNT ON;
		DECLARE @ID_Rez AS int
		SET @ID_Rez = (
			SELECT ID_Rezerwacji
			FROM Dni_Konferencji_Rezerwacje
			WHERE NIP_Klienta = @NIP_Klienta 
				AND ID_Dnia_Konferencji = dbo.Pobierz_ID_Dnia(@Nazwa_Konf, @Data)
		)
		UPDATE Dni_Konferencji_Rezerwacje
		SET Data_Anulowania = GETDATE()
		WHERE ID_Rezerwacji = @ID_Rez
	END
GO

IF OBJECT_ID('Warsztat_Zaplata') IS NOT NULL
DROP PROCEDURE Warsztat_Zaplata
GO
IF OBJECT_ID('Dzien_Konferencji_Zaplata') IS NOT NULL
DROP PROCEDURE Dzien_Konferencji_Zaplata
GO

CREATE PROCEDURE Warsztat_Zaplata
	@NIP_Klienta char(10),
	@Nazwa_Konf varchar(50),
	@Data date,
	@Temat varchar(50),
	@Kwota_Wplaty money
	AS
	BEGIN
		DECLARE @ID_Rez AS int
		SET @ID_Rez = (
			SELECT ID_Rezerwacji
			FROM Warsztaty_Rezerwacje
			WHERE ID_Warsztatu = dbo.Pobierz_ID_Warsztatu(@Nazwa_Konf, @Data, @Temat)
			AND NIP_Klienta = @NIP_Klienta
		)
		print @ID_Rez
		UPDATE Warsztaty_Rezerwacje
		SET Kwota_Zaplacona = Kwota_Zaplacona + @Kwota_Wplaty
		WHERE ID_Rezerwacji = @ID_Rez
	END
GO

CREATE PROCEDURE Dzien_Konferencji_Zaplata
	@NIP_Klienta char(10),
	@Nazwa_Konf varchar(50),
	@Data date,
	@Kwota_Wplaty money
	AS
	BEGIN
		DECLARE @ID_Rez AS int
		SET @ID_Rez = (
			SELECT ID_Rezerwacji
			FROM Dni_Konferencji_Rezerwacje
			WHERE ID_Dnia_Konferencji = dbo.Pobierz_ID_Dnia(@Nazwa_Konf, @Data)
			AND NIP_Klienta = @NIP_Klienta
		)
		
		UPDATE Dni_Konferencji_Rezerwacje
		SET Kwota_Zaplacona = Kwota_Zaplacona + @Kwota_Wplaty
		WHERE ID_Rezerwacji = @ID_Rez
	END
GO

IF OBJECT_ID('Anuluj_Nieoplacone_Rezerwacje') IS NOT NULL
DROP PROCEDURE Anuluj_Nieoplacone_Rezerwacje 
GO

CREATE PROCEDURE Anuluj_Nieoplacone_Rezerwacje
	AS
	BEGIN
		BEGIN TRANSACTION
			UPDATE Dni_Konferencji_Rezerwacje
			SET Data_Anulowania = GETDATE()
			WHERE ID_Rezerwacji in (
				SELECT ID_Rezerwacji
				FROM Dni_Konferencji_Rezerwacje
				WHERE ID_Dnia_Konferencji in (
					SELECT ID_Dnia_Konferencji
					FROM Dni_Konferencji
					WHERE DATEDIFF(WEEK, GETDATE(), Data) <= 1
				) AND Kwota_Zaplacona < Kwota_Do_Zaplaty
			)
			
			IF @@ERROR <> 0
			BEGIN
				RAISERROR('error', 16, 1)
				ROLLBACK TRANSACTION
			END
			
			UPDATE Warsztaty_Rezerwacje
			SET Data_Anulowania = GETDATE()
			WHERE ID_Rezerwacji in (
				SELECT ID_Rezerwacji
				FROM Warsztaty_Rezerwacje
				WHERE ID_Warsztatu in (
					SELECT ID_Warsztatu
					FROM Warsztaty
					WHERE DATEDIFF(WEEK, GETDATE(),
						 (SELECT Data
						  FROM Dni_Konferencji 
						  WHERE Dni_Konferencji.ID_Dnia_Konferencji = Warsztaty.ID_Dnia_Konferencji)
						 ) <= 1
				) AND Kwota_Zaplacona < Kwota_Do_Zaplaty
			)
			IF @@ERROR <> 0
			BEGIN
				RAISERROR('error', 16, 1)
				ROLLBACK TRANSACTION
			END
		COMMIT TRANSACTION
	END
GO

--widoki
IF OBJECT_ID('Nadchodzace_Konferencje') IS NOT NULL
DROP VIEW Nadchodzace_Konferencje
GO

CREATE VIEW Nadchodzace_Konferencje
	AS
	SELECT Nazwa, Miasto, Ulica, Nr_Budynku, Kod_Pocztowy, MIN(Data) as Dzien_Rozpoczecia, MAX(Data) as Dzien_Zakonczenia
	FROM Konferencje join Dni_Konferencji
	ON Konferencje.ID_Konferencji = Dni_Konferencji.ID_Konferencji
	GROUP BY Nazwa, Miasto, Ulica, Nr_Budynku, Kod_Pocztowy
	HAVING MIN(Data) > GETDATE()
GO

IF OBJECT_ID('Nadchodzace_Warsztaty') IS NOT NULL
DROP VIEW Nadchodzace_Warsztaty
GO

CREATE VIEW Nadchodzace_Warsztaty
	AS
	SELECT Konferencje.Nazwa, Temat, Cena,
	Warsztaty.Liczba_miejsc, Warsztaty.Liczba_miejsc - (
		SELECT SUM(Warsztaty_Rezerwacje.Liczba_Miejsc) 
		FROM Warsztaty_Rezerwacje 
		WHERE Warsztaty_Rezerwacje.ID_Warsztatu = Warsztaty.ID_Warsztatu
		AND Data_Anulowania IS NULL) as Liczba_Miejsc_Wolnych,
	Godzina_Rozpoczecia, Godzina_Zakonczenia
	FROM Warsztaty 
	join Dni_Konferencji
	ON Warsztaty.ID_Dnia_Konferencji = Dni_Konferencji.ID_Dnia_Konferencji
	join Konferencje
	ON Konferencje.ID_Konferencji = Dni_Konferencji.ID_Konferencji
	WHERE Dni_Konferencji.Data > GETDATE()
GO

IF OBJECT_ID('Klienci_Nadchodzacych_Konferencji') IS NOT NULL
DROP VIEW Klienci_Nadchodzacych_Konferencji
GO

CREATE VIEW Klienci_Nadchodzacych_Konferencji
	AS
	SELECT Konferencje.Nazwa AS Nazwa_Konferencji, Klienci.Nazwa AS Nazwa_Klienta, 
	SUM(Dni_Konferencji_Rezerwacje.Liczba_Miejsc) AS Liczba_Miejsc
	FROM Konferencje join Dni_Konferencji 
	ON Konferencje.ID_Konferencji = Dni_Konferencji.ID_Konferencji
	join Dni_Konferencji_Rezerwacje
	ON Dni_Konferencji_Rezerwacje.ID_Dnia_Konferencji = Dni_Konferencji.ID_Dnia_Konferencji
	join Klienci
	ON Klienci.NIP = Dni_Konferencji_Rezerwacje.NIP_Klienta
	WHERE Dni_Konferencji.Data > GETDATE()
	AND Dni_Konferencji_Rezerwacje.Data_Anulowania IS NULL
	GROUP BY Konferencje.Nazwa, Klienci.Nazwa
GO

IF OBJECT_ID('Uczestnicy_Nadchodzacych_Konferencji') IS NOT NULL
DROP VIEW Uczestnicy_Nadchodzacych_Konferencji
GO

CREATE VIEW Uczestnicy_Nadchodzacych_Konferencji
	AS
	SELECT Uczestnicy.ID_Uczestnika, Uczestnicy.Imie, Uczestnicy.Nazwisko, Konferencje.Nazwa
	FROM Dni_Konferencji_Rejestracje join Uczestnicy
	ON Dni_Konferencji_Rejestracje.ID_Uczestnika = Uczestnicy.ID_Uczestnika
	join Dni_Konferencji_Rezerwacje
	ON Dni_Konferencji_Rezerwacje.ID_Rezerwacji = Dni_Konferencji_Rejestracje.ID_Rezerwacji
	join Dni_Konferencji
	ON Dni_Konferencji.ID_Dnia_Konferencji = Dni_Konferencji_Rezerwacje.ID_Dnia_Konferencji
	join Konferencje
	ON Konferencje.ID_Konferencji = Dni_Konferencji.ID_Konferencji
	WHERE Dni_Konferencji_Rejestracje.Data_Anulowania IS NULL
GO

IF OBJECT_ID('Uczestnicy_Nadchodzacych_Warsztatow') IS NOT NULL
DROP VIEW Uczestnicy_Nadchodzacych_Warsztatow
GO

CREATE VIEW Uczestnicy_Nadchodzacych_Warsztatow
	AS
	SELECT Warsztaty.Temat, Uczestnicy.Imie, Uczestnicy.Nazwisko, Uczestnicy.ID_Uczestnika
	FROM Warsztaty_Rejestracje join Dni_Konferencji_Rejestracje
	ON Warsztaty_Rejestracje.ID_Rejestracji = Dni_Konferencji_Rejestracje.ID_Rejestracji
	join Uczestnicy
	ON Uczestnicy.ID_Uczestnika = Dni_Konferencji_Rejestracje.ID_Uczestnika
	join Warsztaty_Rezerwacje
	ON Warsztaty_Rejestracje.ID_Rezerwacji = Warsztaty_Rezerwacje.ID_Rezerwacji
	join Warsztaty
	ON Warsztaty.ID_Warsztatu = Warsztaty_Rezerwacje.ID_Warsztatu	
	WHERE Warsztaty_Rejestracje.Data_Anulowania IS NULL
GO

IF OBJECT_ID('Nieoplacone_Rezerwacje_Dni') IS NOT NULL
DROP VIEW Nieoplacone_Rezerwacje_Dni
GO

CREATE VIEW Nieoplacone_Rezerwacje_Dni
	AS
	SELECT Konferencje.Nazwa as Nazwa_Konferencji, Dni_Konferencji.Data,
	Klienci.Nazwa as Nazwa_Klienta, Kwota_Do_Zaplaty, Kwota_Zaplacona, 
	Kwota_Do_Zaplaty - Kwota_Zaplacona as Roznica, Dni_Konferencji_Rezerwacje.Liczba_Miejsc, 
	Klienci.Nr_Telefonu, Klienci.Email
	FROM Dni_Konferencji_Rezerwacje 
	join Dni_Konferencji
	ON Dni_Konferencji.ID_Dnia_Konferencji = Dni_Konferencji_Rezerwacje.ID_Dnia_Konferencji
	join Konferencje
	ON Konferencje.ID_Konferencji = Dni_Konferencji.ID_Konferencji
	join Klienci
	ON Klienci.NIP = Dni_Konferencji_Rezerwacje.NIP_Klienta
	WHERE Kwota_Do_Zaplaty < Kwota_Zaplacona
	AND Dni_Konferencji.Data > GETDATE()
	AND Dni_Konferencji_Rezerwacje.Data_Anulowania IS NULL
GO

IF OBJECT_ID('Nieoplacone_Rezerwacje_Warsztatow') IS NOT NULL
DROP VIEW Nieoplacone_Rezerwacje_Warsztatow
GO

CREATE VIEW Nieoplacone_Rezerwacje_Warsztatow
	AS
	SELECT Warsztaty.Temat, Klienci.Nazwa, Kwota_Do_Zaplaty, Kwota_Zaplacona,
	 Kwota_Do_Zaplaty - Kwota_Zaplacona as Roznica, Warsztaty_Rezerwacje.Liczba_Miejsc
	FROM Warsztaty_Rezerwacje
	join Warsztaty
	ON Warsztaty.ID_Warsztatu = Warsztaty_Rezerwacje.ID_Warsztatu
	join Klienci
	ON Klienci.NIP = Warsztaty_Rezerwacje.NIP_Klienta
	join Dni_Konferencji
	ON Dni_Konferencji.ID_Dnia_Konferencji = Warsztaty.ID_Dnia_Konferencji
	WHERE Kwota_Do_Zaplaty < Kwota_Zaplacona
	AND Warsztaty_Rezerwacje.Data_Anulowania IS NULL
	AND Dni_Konferencji.Data > GETDATE()
GO

IF OBJECT_ID('Niewykorzystane_Rezerwacje_Dni') IS NOT NULL
DROP VIEW Niewykorzystane_Rezerwacje_Dni
GO

CREATE VIEW Niewykorzystane_Rezerwacje_Dni
	AS
	SELECT Konferencje.Nazwa as Nazwa_Konferencji, Dni_Konferencji.Data, Klienci.Nazwa as Nazwa_Klienta,
	Dni_Konferencji_Rezerwacje.Liczba_Miejsc, COUNT(Dni_Konferencji_Rejestracje.ID_Rejestracji) as Liczba_Miejsc_Wykorzystanych
	FROM Dni_Konferencji_Rezerwacje
	join Dni_Konferencji
	ON Dni_Konferencji.ID_Dnia_Konferencji = Dni_Konferencji_Rezerwacje.ID_Dnia_Konferencji
	join Dni_Konferencji_Rejestracje
	ON Dni_Konferencji_Rejestracje.ID_Rezerwacji = Dni_Konferencji_Rezerwacje.ID_Rezerwacji
	join Klienci
	ON Klienci.NIP = Dni_Konferencji_Rezerwacje.NIP_Klienta
	join Konferencje
	ON Dni_Konferencji.ID_Konferencji = Konferencje.ID_Konferencji
	WHERE Dni_Konferencji_Rezerwacje.Data_Anulowania IS NULL
	AND Dni_Konferencji.Data > GETDATE()
	GROUP BY Konferencje.Nazwa, Dni_Konferencji.Data, Klienci.Nazwa, Dni_Konferencji_Rezerwacje.Liczba_Miejsc
GO

IF OBJECT_ID('Niewykorzystane_Rezerwacje_Warsztatow') IS NOT NULL
DROP VIEW Niewykorzystane_Rezerwacje_Warsztatow
GO

CREATE VIEW Niewykorzystane_Rezerwacje_Warsztatow
	AS
	SELECT Klienci.Nazwa, Warsztaty.Temat, Warsztaty_Rezerwacje.Liczba_Miejsc,
	COUNT(Warsztaty_Rejestracje.ID_Rejestracji) as Liczba_Miejsc_Wykorzystanych 
	FROM Warsztaty_Rezerwacje
	join Warsztaty_Rejestracje
	ON Warsztaty_Rezerwacje.ID_Rezerwacji = Warsztaty_Rejestracje.ID_Rezerwacji
	join Klienci
	ON Klienci.NIP = Warsztaty_Rezerwacje.NIP_Klienta
	join Warsztaty
	ON Warsztaty.ID_Warsztatu = Warsztaty_Rezerwacje.ID_Warsztatu
	join Dni_Konferencji
	ON Dni_Konferencji.ID_Dnia_Konferencji = Warsztaty.ID_Dnia_Konferencji
	WHERE Warsztaty_Rezerwacje.Data_Anulowania IS NULL 
	AND Dni_Konferencji.Data > GETDATE()
	GROUP BY Klienci.Nazwa, Warsztaty.Temat, Warsztaty_Rezerwacje.Liczba_Miejsc
GO

IF OBJECT_ID('Klienci_Aktywnosc') IS NOT NULL
DROP VIEW Klienci_Aktywnosc
GO

CREATE VIEW Klienci_Aktywnosc
	AS
	SELECT Klienci.Nazwa, SUM(Dni_Konferencji_Rezerwacje.Liczba_Miejsc) as Rez_Dni_Konferencji,
	SUM(Warsztaty_Rezerwacje.Liczba_Miejsc) as Rez_Warsztatow, 
	SUM(Dni_Konferencji_Rezerwacje.Kwota_Zaplacona) + SUM(Warsztaty_Rezerwacje.Kwota_Zaplacona) as Suma_Wplat
	FROM Klienci
	join Dni_Konferencji_Rezerwacje
	ON Dni_Konferencji_Rezerwacje.NIP_Klienta = Klienci.NIP
	join Warsztaty_Rezerwacje
	ON Warsztaty_Rezerwacje.NIP_Klienta = Klienci.NIP
	WHERE Dni_Konferencji_Rezerwacje.Data_Anulowania IS NULL 
	AND Warsztaty_Rezerwacje.Data_Anulowania IS NULL
	GROUP BY Klienci.Nazwa
GO