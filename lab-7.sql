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
--Tutaj deklaruje zmienna jsonowa
DECLARE @ProductInfo NVARCHAR(MAX) = N'[{"ProductID":717, "NewPrice": 1730.13},{"ProductID":718, "NewPrice": 2003.30},{"ProductID": 720, "NewPrice": 6001.34},{"ProductID": 730, "NewPrice": 50.31},{"ProductID": 740, "NewPrice": 705.50}]'

SELECT vw.ProductID, vw.ListPrice, pinfo.NewPrice, (pinfo.NewPrice - vw.ListPrice) as Diff
FROM dbo.JSONCOS vw


--Tworze widok z jakas tam nazwa 
