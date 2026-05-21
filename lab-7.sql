-- =============================================
-- Piotr
-- Popiel
-- 240164
-- =============================================
/* X to P | Y to 240164 | N to 4 */
-- =============================================
-- =============================================
-- Zadanie 1
CREATE TYPE dbo.P4_surname FROM NVARCHAR(50) NOT NULL -- Tworze własny typ danych P4_surname 
GO

ALTER TABLE [240164].[Customer] --To chyba jedyna tabela ktora zawiera LastName, chyba, że coś przeoczyłem ze zmęczenia.
ALTER COLUMN LastName P4_surname
GO
-- =============================================
-- =============================================
-- Zadanie 2
--Tworze widok z jakas tam nazwa 
CREATE VIEW dbo.JSONCOS AS 
SELECT ProductID, ListPrice
FROM SalesLT.Product
GO
--Tutaj deklaruje zmienna jsonowa, dowiedzialem sie, ze nie mozna zrobic dac do widoku zmiennej takiej wiec musze to zrobic za pomoca dwoch selectow, chyba ze jest jakas inna opcja.
DECLARE @ProductInfo NVARCHAR(MAX) = N'[{"ProductID":717, "NewPrice": 1730.13},{"ProductID":718, "NewPrice": 2003.30},{"ProductID": 720, "NewPrice": 6001.34},{"ProductID": 730, "NewPrice": 50.31},{"ProductID": 740, "NewPrice": 705.50}]'

SELECT vw.ProductID, vw.ListPrice, pinfo.NewPrice, (pinfo.NewPrice - vw.ListPrice) as Diff
FROM dbo.JSONCOS vw
INNER JOIN OPENJSON(@ProductInfo)
WITH ( ProductID int '$.ProductID', NewPrice money '$.NewPrice') pinfo ON vw.ProductID = pinfo.ProductID
GO
-- =============================================
-- =============================================
-- Zadanie 3
CREATE VIEW dbo.[240164_Order] AS
SELECT TOP 100 LastName, FirstName --Chyba tak to trzeba zrobic jesli widok ma zawierac ORDER BY. Mozna jeszcze zrobic bez TOP ale potrzeba wtedy wziac ORDER BY do nastepnego SELECTA, ale chyba o to rozwiazanie chodzilo.
FROM [240164].[Customer]
ORDER BY LastName DESC
GO

SELECT *
FROM dbo.[240164_Order]
GO
-- =============================================
-- =============================================
-- Zadanie 4

CREATE VIEW dbo.Student_4.MyLogicView AS
SELECT ListPrice as [Net Price], (StandardPrice * 1.15) as [Predicted Net Price], (ListPrice * 1.23) as [Gross Price]

-- =============================================

