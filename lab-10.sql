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
CREATE OR ALTER PROCEDURE dbo.GetCustomer
	@FNAME Name,
	@LName P4_surname,
	@CID int,
	@EmailAddress nvarchar(50)
AS
BEGIN 
	SET NOCOUNT ON

	SELECT FirstName, LastName, CustomerID, EmailAddress
	FROM [240164].Customer
	WHERE (@FNAME = FirstName OR @FNAME = Null) AND (@LNAME = LastName OR @LNAME = Null) AND
	(@CID = 


-- =============================================
-- =============================================
-- Zadanie 3

-- =============================================
-- =============================================
-- Zadanie 4

-- =============================================
-- =============================================
-- Zadanie 5

-- =============================================