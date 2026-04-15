-- =============================================
-- Piotr
-- Popiel
-- 240164
-- =============================================
/* X to P | Y to 240164 | N to 4 */
-- =============================================
-- =============================================
-- Zadanie 1
DECLARE @Litera char(1);
DECLARE @Cyfra int;
SET @Cyfra = 4;
SET @Litera = 'P';
SELECT CustomerID, FirstName, LastName
FROM SalesLT.Customer
WHERE LastName Like @Litera + '%' AND CustomerID % 10 = @Cyfra;
GO
-- =============================================
-- =============================================
-- Zadanie 2
DECLARE @Produkty TABLE (
ProductID int,
Name nvarchar(50),
ListPrice money);
INSERT INTO @Produkty(ProductID, Name, ListPrice) 
SELECT ProductID, Name, ListPrice From SalesLT.Product WHERE NAME LIKE '%P%'
SELECT *
FROM @Produkty
GO
-- =============================================
-- =============================================
-- Zadanie 3
SELECT clt.CustomerID, clt.FirstName, clt.LastName, adrs.City
INTO #KlienciMiasta
FROM SalesLT.Customer clt
JOIN SalesLT.CustomerAddress cadrs on clt.CustomerID = cadrs.AddressID
JOIN SalesLT.Address adrs on cadrs.AddressID = adrs.AddressID
WHERE adrs.City LIKE 'P%'
GO
SELECT *
FROM #KlienciMiasta
GO
DROP TABLE #KlienciMiasta
GO
-- =============================================
-- =============================================
-- Zadanie 4
CREATE SCHEMA Student_4 AUTHORIZATION student
GO
CREATE TABLE Student_4.ProduktyP (
	ProductID int,
	Name nvarchar(100),
	Category nvarchar(100),
	ListPrice money
	)
GO
INSERT INTO Student_4.ProduktyP(ProductID, Name, Category, ListPrice)
SELECT ProductID, Name, Category, ListPrice
FROM SalesLT.Products
GO
-- =============================================
-- =============================================
-- Zadanie 5
DECLARE @Podsumowanie TABLE (
	Category nvarchar(100),
	SredniaCena money
	)
INSERT INTO @Podsumowanie(Category, SredniaCena)
SELECT Category, AVG(ListPrice) as SredniaCena
FROM SalesLT.ProductCategory
WHERE 
-- =============================================