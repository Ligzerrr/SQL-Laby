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
JOIN SalesLT.CustomerAddress cadrs on clt.CustomerID = cadrs.CustomerID --Tutaj wymagane jest połączenie tabel CustomerAddress oraz Address aby dostać wszystkie potrzebne kolumny
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
CREATE SCHEMA Student_4 AUTHORIZATION dbo
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
FROM SalesLT.Product
GO
-- =============================================
-- =============================================
-- Zadanie 5
DECLARE @Podsumowanie TABLE (
	Category nvarchar(100),
	SredniaCena money
	)
INSERT INTO @Podsumowanie(Category, SredniaCena)
SELECT prdctg.Name, AVG(prd.ListPrice) as SredniaCena
FROM SalesLT.Product prd
JOIN SalesLT.ProductCategory prdctg ON prd.ProductCategoryID = prdctg.ProductCategoryID --Trzeba połączyć tabele ProductCategory z Product
WHERE prdctg.ProductCategoryID % 10 = 4
GROUP BY prdctg.Name
SELECT *
FROM @Podsumowanie
GO
-- =============================================
-- =============================================
-- Zadanie 6
CREATE SCHEMA [240164] AUTHORIZATION dbo --Nie miałem zbytnio o czym pisać w tym labie, tutaj musiałem dać nawiasy kwadratowe, ponieważ w innym przypadku 240164 traktowane jest jako liczba (int)
GO
ALTER SCHEMA [240164] TRANSFER SalesLT.Customer -- SalesLT jest nazwą SCHEMATU.
ALTER SCHEMA [240164] TRANSFER SalesLT.CustomerAddress --Nie da się przenieść za pomocą jednej instrukcji, chyba, że o tym nie wiem lub jakoś dynamicznie, dwóch tabel jednocześnie.
-- =============================================