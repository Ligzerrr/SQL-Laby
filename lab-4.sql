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
-- =============================================
-- =============================================
-- Zadanie 3
SELECT clt.CustomerID, clt.FirstName, clt.LastName, adrs.City
INTO #KlienciMiasta
FROM SalesLT.Customer clt
JOIN SalesLT.CustomerAddress cadrs on clt.CustomerID = cadrs.AddressID
JOIN SalesLT.Address adrs on cadrs.AddressID = adrs.AddressID
WHERE adrs.City LIKE 'X%'

SELECT *
FROM #KlienciMiasta

DROP TABLE #KlienciMiasta
-- =============================================