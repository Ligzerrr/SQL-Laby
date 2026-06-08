﻿-- =============================================
-- Piotr
-- Popiel
-- 240164
-- =============================================
/* X to P | Y to 240164 | N to 4 */
-- =============================================
-- =============================================
-- Zadanie 1
-- Dam taki mały prefix, dalej mam problem z no connection jeśli chodzi o bazę, więc totalnie nie mam jak sprawdzić czy to działa.
--Znaczy zawsze mógłbym w osobnej bazie danych pracować ale nie widzę troche sensu tego ale rozumiem jeśli powinnienem tak zrobić.
GO
--Mały problem co do tego zadania. Nie rozumiem do czego ten TIP nawiazuje? Nie pamietam tworzenia wlasnych typow danych specyficznie pod SalesLT.Product i troche mnie to? zdziwilo?
CREATE OR ALTER PROCEDURE dbo.UpdatePrices
	@IDProd int,
	@NEWLPrice decimal(10,2)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON

	UPDATE SalesLT.Product
	SET ListPrice = @NEWLPRICE
	WHERE ProductID = @IDPROD
END
GO
-- =============================================
-- =============================================
-- Zadanie 2
-- Za pomocą NULL mozna stworzyc niewymagalne parametry
CREATE OR ALTER PROCEDURE dbo.GetCustomer
	@FNAME Name = NULL,
	@LName P4_surname = NULL,
	@CID int = NULL,
	@EmailAddress nvarchar(50) = NULL
AS
BEGIN 
	SET NOCOUNT ON

	SELECT FirstName, LastName, CustomerID, EmailAddress
	FROM [240164].Customer
	WHERE (@FNAME = FirstName OR @FNAME IS Null) AND (@LNAME = LastName OR @LNAME IS Null) AND
	(@CID = CustomerID OR @CID IS Null) AND (@EmailAddress = EmailAddress OR @EmailAddress IS NULL)
END
GO

-- =============================================
-- =============================================
-- Zadanie 3
--Podobny poczatek do zad2, ale raczej najczesciej zmienane sa naziwska, emaile oraz numery telefonu.
--Zrobie tutaj fajny komunikat za pomoca zmiennej @message
CREATE OR ALTER PROCEDURE dbo.UpdateCustomer
	@IDC int,
	@LNAME P4_surname,
	@EADRS nvarchar(50),
	@PHONE Phone
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
		IF EXISTS (SELECT 1 FROM SalesLT.Customer WHERE CustomerID = @IDC)
			UPDATE SalesLT.Customer
			SET LastName = @LNAME, EmailAddress = @EADRS, Phone = @PHONE
			WHERE CustomerID = @IDC
		ELSE
			DECLARE @MESSAGE nvarchar(100) = 'Parameter: ' + CAST(@IDC AS NVARCHAR(5)) + ' does not match an existing record within the table!';
			THROW 50001, @MESSAGE, 1
END
-- =============================================
-- =============================================
-- Zadanie 4
CREATE Table SalesLT.ProductInventory(
	ProductID int not null,
	Volume int

	CONSTRAINT PID Foreign Key(ProductID) references SalesLT.Product(ProductID)
)
GO
CREATE OR ALTER PROCEDURE dbo.AddNewProduct
	@PName name,
	@CName name,
	@UPrice money,
	@VOL int
AS
BEGIN
	DECLARE @NID INT --na poczatku mialem declare w tranzakcji ale przypomnialo mi sie ze nie mozna tak robic. dlatego na samym poczatku zadeklarowalem.
	IF (@VOL < 0) OR (@UPRICE <= 0)
		THROW 50002, 'Data validation failed! Check the data you have entered and try again.', 1 --IF sprawdz mi tutaj jedno z wymagan zadania. (THROW zostanie wykonane jesli cena jest ponizej lub rowna 0 albo wolumen jest < 0)
	SET NOCOUNT ON
	SET XACT_ABORT ON
	BEGIN TRY
		BEGIN TRAN
			INSERT INTO SalesLT.Product(Name, CategoryName, ListPrice)
			VALUES (@PName, @CName, @UPrice)
			SET @NID = SCOPE_IDENTITY() --Najlepszy sposob na zdobycie ID nowego produktu, chcialem na poczatku zrobic przez SELECT DESC ale jakby ktos zmienil cos w trakcie to wywaliloby sie wszystko. (Szukalem w internecie)
			INSERT INTO SalesLT.ProductInventory
			VALUES(@NID, @Vol)
		COMMIT TRAN 
	END TRY
	BEGIN CATCH
		IF XACT_STATE() <> 0
			ROLLBACK TRAN
		DECLARE @EMSG Nvarchar(5000) = ERROR_MESSAGE()
		DECLARE @ENUM INT = ERROR_NUMBER();
		THROW @ENUM, @EMSG, 1
	END CATCH
END
GO
-- =============================================
-- =============================================
-- Zadanie 5
--Tabela #TopProducts z 9 ale wzialem zamiast 25, 15 produktow. I musialem w pewnym momencie dodac CategoryName oraz Volume bo nie byloby skad wziac tych rzeczy do exec procedury.
Create Table #TopProducts (
	ID INT PRIMARY KEY,
	Name NVARCHAR(50),
	Price DECIMAL(10,2),
	CategoryName Nvarchar(50),
	Volume INT
	)
INSERT INTO #TopProducts
SELECT TOP 15 ProductID, Name, ListPrice, CategoryName, 50
FROM SalesLT.Product
WHERE ListPrice > 1.05 * StandardCost AND ListPrice < 1.20 * StandardCost


INSERT INTO #TopProducts
VALUES (3232, 'Balenciaga', 4330, 'Footwear', 4000)
GO

CREATE OR ALTER PROCEDURE dbo.UpdatePAfterD
AS
BEGIN
	DECLARE @id int, @name nvarchar(50), @Price decimal(10,2), @CatName nvarchar(50), @Volu int--Id do kursora itd.
	SET NOCOUNT ON
	SET XACT_ABORT ON

	DECLARE CURSOR_SOMETHING CURSOR FOR
	SELECT ID, Name, Price, CategoryName, Volume
	FROM #TopProducts
	ORDER BY ID

	OPEN CURSOR_SOMETHING

	FETCH NEXT FROM CURSOR_SOMETHING INTO @id, @name, @Price, @CatName, @Volu
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS (SELECT ProductID FROM SalesLT.Product WHERE ProductID = @ID)
			EXEC dbo.UpdatePrices @IDPROD = @ID, @NEWLPRICE = @Price
		ELSE 
			EXEC dbo.AddNewProduct @PName = @name, @CName = @CatName, @UPrice = @Price, @VOL = @Volu
		FETCH NEXT FROM CURSOR_SOMETHING INTO @id, @name, @Price, @CatName, @Volu
	END
	CLOSE CURSOR_SOMETHING
	DEALLOCATE CURSOR_SOMETHING
END

GO

-- =============================================