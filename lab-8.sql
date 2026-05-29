﻿-- =============================================
-- Piotr
-- Popiel
-- 240164
-- =============================================
/* X to P | Y to 240164 | N to 4 */
-- =============================================
-- =============================================
-- Zadanie 1
--Tutaj tworze tabele do histori produktu aka audytu czy jak to się tam zwie, z historyid jako primary key itd. OldLP = OldListPrice analogicznie NewLP
CREATE TABLE SalesLT.ProductPriceHistory (
HistoryID int identity PRIMARY KEY,
ProductID int,
OldLP money,
NewLP money,
ChangedAuthor SYSNAME DEFAULT SYSTEM_USER,
ChangedDate DATETIME2 DEFAULT SYSDATETIME()
)
GO
-- Tworze od razu z create or alter bo pewnie bede musial cos zmienic
CREATE OR ALTER TRIGGER SalesTrigga
ON SalesLT.Product
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON --ustawilem nocount zeby nie wyswietlaly sie komunikaty o zmianie wierszy d
	INSERT INTO SalesLT.ProductPriceHistory(ProductID, OldLP, NewLP)
	SELECT ins.ProductID, prdt.ListPrice as OldLP, ins.ListPrice as NewLP
	FROM INSERTED ins
	JOIN DELETED prdt on ins.ProductID	= prdt.ProductID
	WHERE ISNULL(prdt.ListPrice, -1) <> ISNULL(i.ListPrice, -1) --Where sprawdza gdzie cena sie zmienila.
END
GO
-- =============================================
-- =============================================
-- Zadanie 2
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
-- =============================================
-- Zadanie 6
-- =============================================