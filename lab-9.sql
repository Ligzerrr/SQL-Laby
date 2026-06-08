-- ===========================================
-- Piotr
-- Popiel
-- 240164
-- =============================================
/* X to P | Y to 240164 | N to 4 */
-- =============================================
-- =============================================
-- Zadanie 1
--niestety w widoku zrobilem tylko dwie kolumny nie wiem czy to działa, wiec musialem byle co dopisac tutaj.
CREATE FUNCTION SalesLT.BestRecord
(
	@SDATE Date = '2006-01-01',
	@SNAMELENGTH int = 50,
	@SCHAR char = 'D'
)
	RETURNS nvarchar(50)
AS
BEGIN
		DECLARE @BestLastName nvarchar(50)
		SELECT TOP 1 @BestLastName = LastName
		FROM dbo.[240164_Order]
		WHERE @SDATE < GETDATE() AND LastName Like @SCHAR AND LEN(FirstName) < @SNAMELENGTH --Musialbym chyba zmienic widok zeby inaczej to zrobic :/
		ORDER BY FirstName
		RETURN @BestLastName
END
GO
-- =============================================
-- =============================================
-- Zadanie 2
--Mam tutaj dwie opcje do ktorych muszę się przyznać:
/*
Msg 2772, Level 16, State 1, Procedure ufn_CalcAdjustedPrice, Line 20 [Batch Start Line 41]
Cannot access temporary tables from within a function.
Nie da sie przekazac #Tabeli do Funkcji tabelarycznej.
Czyli moge zostawic tak jak jest bo czysto teoretycznie to by zadzialalo gdyby T-sql przyjmowalby faktycznie te #tabele.

OPCJA DRUGA:
Uzyć AI ale tak jak juz było wspominane AI jest niedozwolone, niby istnieje stack i dałoby sie to rozwiazac
ale w sumie nie uzywaloby to wtedy prawdziwej #Tabeli, więc zostawiam tak jak jest.
Jesli będzie potrzeba to moge sprobowac oddac zadanie znowu z rozwiazaniem tego problemu.
:-)


*/
Create Table #TopProducts (
	ID INT PRIMARY KEY,
	Name NVARCHAR(50),
	Price DECIMAL(10,2)
	)
INSERT INTO #TopProducts
SELECT TOP 25 ProductID, Name, ListPrice
FROM SalesLT.Product
WHERE ListPrice > 1.05 * StandardCost AND ListPrice < 1.20 * StandardCost

GO

CREATE FUNCTION Student_4.ufn_CalcAdjustedPrice
(
	/*(@SID int,
	@SNAME nvarchar(50),
	@SPRICE decimal(10,2)*/ --ta czesc nie jest potrzebna chyba
)
Returns @Summary Table
(
	ProductID int,
	Name nvarchar(50),
	ListPrice decimal(10,2),
	NewPrice decimal(10,2)
)
AS
BEGIN
	INSERT INTO @Summary
	SELECT ID, Name, Price, Price - (Price * 0.05)
	FROM #TopProducts
	RETURN
END
GO

	
-- =============================================
-- =============================================
-- Zadanie 3
CREATE FUNCTION Student_4.ufn_ProductsJsonByCategory
(
	@CategoryName NVARCHAR(50)  --Chyba dobrze zrozumialem to zadanie? Nie wiem czy mam ustawic ten parametr czy nie.
)
	Returns nvarchar(max)
AS
BEGIN
	DECLARE @json nvarchar(max) --deklaruje jsona ustawiam go za pomoca SET i robie FOR JSON path zeby dostac wynik w json
	SET @json = (
	SELECT PRDT.ProductID, PRDT.Name, PRDT.ListPrice, CTG.Name
	FROM SalesLT.Product PRDT
	JOIN SalesLT.ProductCategory CTG on PRDT.ProductCategoryID = CTG.ProductCategoryID
	WHERE CTG.Name = @CategoryName
	FOR JSON PATH
	)

	RETURN @json
END
GO
--Podczas pracy z sqlem to mi sie wyswietlilo i juz sie nie chce naprawic od pewnego momentu. Nie mam jak sprawdzic czy dziala wszystko ale mam nadzieje ze mi sie udalo.
	--Msg 0, Level 20, State 0, Line 83
    --The connection is broken and recovery is not possible.  The connection is marked by the server as unrecoverable.  No attempt was made to restore the connection.
-- =============================================
-- =============================================
-- Zadanie 4
CREATE FUNCTION Student_4.ufn_IsPriceHigherThanCurrent
(
	@json nvarchar(max)
)
	RETURNS bit --bit dziala jak bool 1 albo 0 true or false
AS
BEGIN
	DECLARE @BOOLSOMETHING BIT
	DECLARE @HELP DECIMAL(10,2)
	SET @HELP = (SELECT ListPrice FROM SalesLT.Product WHERE JSON_VALUE(@json, '$.something.id') = ProductID)
	IF JSON_VALUE(@json, '$.something.price') > @HELP --nie wiem o jaki dokument chodzi wiec nie wiem jaka bedzie sciezka!!!! Wystarczy zmienic sciezke i tyle.
		SET @BOOLSOMETHING = 1
	ELSE IF JSON_VALUE(@json, '$.something.price') < @HELP --albo samo else i jakby cena byla rowna to po prostu by wykonalo sie ELSE . ale z ELSE IF cos by sie stalo z bitem. Czego nie wiem (dalej nie działa mi connection :) )
		SET @BOOLSOMETHING = 0
	RETURN @BOOLSOMETHING
END
GO
-- =============================================
-- =============================================
-- Zadanie 5
-- Z uwagi na to, że nie potrafie naprawic bledu z not connected(??? nie wiem czemu) nie mam jak zbytnio przetestowac tego zadania. mam nadzieje ze dobrze.
CREATE FUNCTION Student_4.NameSomething()
RETURNS Table
AS
RETURN
(
	SELECT ProductID, ListPrice, Student_4.ufn_IsPriceHigherThanCurrent((SELECT ProductID, Name, ListPrice FOR JSON PATH)) as FunctionThing FROM SalesLT.Product
)

GO
-- =============================================
-- =============================================
-- Zadanie 6

--iVTF:
/*
iVTF sa najczesciej potrzebny gdy zwykly widok nie bedzie wystarczajacy (znacznie szybsze przy ogromnej ilosci danych). Dodatkowo pozwalaja na wlasne parametry zamiast kombinowania przy widokach
Jesli np. jest jakas Tabela ktora ma 300000 rekordów np. sprzedaże dużego biznesu lub jakieś logi iVTF będzie o wiele lepszym sposobem niż widok.
*/
CREATE FUNCTION Business.SalesShow --Mozna dodac tutaj parametry ktore przydadza sie do obliczen dla danego biznesu.
()
RETURNS TABLE
AS
RETURN
( 
	SELECT Info, Price, Tax, Name, Product FROM Business.Sales
)

GO

/*
mVTF powinny byc tylko stosowane do ciezszych obliczen oraz przy IF (iVTF nie przyjmuje ifow)
ma bardzo duzo minusow: w przeciwienstwie do iVTF sa koszmarne w wydajnosci. 
Przykladem moze byc np. Biznes potrzebuje obliczenia jakiegos DYNAMICZNEGO rabatu dla cen, lub podmian (ktore sa potrzebne w wielu miejsach kodu), ktore ciezko wykonac bez zastosowania funkcji.
*/
CREATE FUNCTION Business.SalesCalculations
()
RETURNS @Table Table
(
	ProductName nvarchar(50),
	PriceOG money,
	PriceFINAL money,
	IsDiscount BIT
)
AS
BEGIN
	INSERT INTO @Table
	SELECT ProductName, Price, Price * 0.50, 1
	FROM Business.Shoes
	WHERE ProductName LIKE 'Balenciaga'

	INSERT INTO @Table
	SELECT ProductName, Price, Price, 0
	FROM Business.Shoes
	WHERE ProductName NOT LIKE 'Balenciaga'
	RETURN
END
GO
/*
Widoki są bardzo podobne do iVFTów z małą różnicą. Widoki są łatwiejsze i wygodniejsze do stworzenia (chociaż to i tak nie jest taka wielka roznica).
Jeśli nie uwzgledniamy uzytecznosci parametrow to widoki z głębsza są popularniejszą opcją jeśli chodzi o tworzenie tych uproszczonych zapytań oraz zabezpieczenia danych.
ALE! Widoki są mniej wydajne niż iVFTy gdy mamy do czynienia z dużą ilością danych.
Przykładem jest np. w bazie danych istnieje tabela z PESEL za pomocą widoku można łatwo się pozbyć niebezpieczeństwa związanego z tym.
*/
--Tutaj istnieje jakas fikcyjna tabelka która ma PESEL oraz inne dane.
CREATE VIEW Business.EmployeesSafeVer AS
SELECT LastName, Name, DateOfEmployment
FROM Business.Employees
GO
--Za pomocą GRANT SELECT ON VIEW TO USER niweluje sie potrzebe uzywania oryginalnej tabeli
/*
Funkcje skalarne mają totalnie inne zastosowanie niż poprzednie rozwiazania.
Maja niska wydajnosc, przyjmuja parametry, pozwala na IF.
W przykladzie: sa fantastyczne do formatowania danych lub obliczenia stalych danych albo walidacji danych.
*/
CREATE FUNCTION Business.CalcVat
(
	@Price money
)
RETURNS MONEY
AS
BEGIN 
	RETURN @Price * 0.23
END
GO
-- =============================================
-- =============================================
-- Zadanie 7

CREATE FUNCTION dbo.fn_GetCustomerCreditRisk
(
	@CustomerID int
)
RETURNS nvarchar(10)
AS
BEGIN
	DECLARE @Orders Table(
		Order_SUM DECIMAL(10,2),
		ISLate_Orders int
	)
	INSERT INTO @Orders
	SELECT TotalDue, CASE WHEN DATEDIFF(day, DueDate, ShipDate) > 3 THEN 1 ELSE 0 END --Uzylem case zeby zrobic to sprawdzenie
	FROM SalesLT.SalesOrderHeader
	WHERE CustomerID = @CustomerID
	IF (SELECT Sum(Order_SUM) FROM @Orders) > 100000 AND (SELECT Sum(ISLate_Orders) FROM @Orders) >= 2
		RETURN 'HIGH'
	ELSE IF (SELECT SUM(Order_SUM) FROM @Orders) > 50000
		RETURN 'MEDIUM'
	ELSE
		RETURN 'LOW'
	RETURN '?'
END
-- =============================================