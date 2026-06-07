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
	@SID int,
	@SNAME nvarchar(50),
	@SPRICE decimal(10,2)
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
-- =============================================
-- =============================================
-- Zadanie 5

-- =============================================
-- =============================================
-- Zadanie 6
-- =============================================
-- =============================================
-- Zadanie 7
-- =============================================