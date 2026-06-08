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
CREATE Table ProductInventory(
	ProductID int not null,
	Volume int

	CONSTRAINT PID Foreign Key(ProductID) references SalesLT.Product(ProductID)
)

CREATE OR ALTER PROCEDURE dbo.AddNewProduct
	@PName name,
	@CName name,
	@UPrice money,
	@VOL int
AS
BEGIN
	IF (@VOL < 0) OR (@UPRICE > 0)
		THROW 50002, 'Data validation failed! Check the data you have entered and try again.', 1
		END
	SET NOCOUNT ON
	SET XACT_ABORT ON
	BEGIN TRY
		BEGIN TRAN
			INSERT INTO SalesLT.Product(Name, CategoryName, ListPrice)




-- =============================================
-- =============================================
-- Zadanie 5

-- =============================================