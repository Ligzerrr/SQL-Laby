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
	WHERE ISNULL(prdt.ListPrice, -1) <> ISNULL(ins.ListPrice, -1) --Where sprawdza gdzie cena sie zmienila.
END
GO
-- =============================================
-- =============================================
-- Zadanie 2
--Najpierw tworze tabele DeletedCustomerLog z tresci zadania, w tym zadaniu musze uzyc SalesLT.Customer bo [240164] jest wersjonowane i nie przepusci mnie sql.
CREATE TABLE SalesLT.DeletedCustomersLog (
HistoryID int primary key identity,
CustomerID int,
OrderDelDate DATETIME2 DEFAULT SYSDATETIME(),
)
GO
CREATE OR ALTER TRIGGER CustomerTrigga
ON SalesLT.Customer
INSTEAD OF DELETE
AS
BEGIN --Musze zrobic tutaj DELETE FROM Customer UPDATE Customer I INSERT INTO Customerslog
	SET NOCOUNT ON
	INSERT INTO SalesLT.DeletedCustomersLog (CustomerID)
	SELECT Customer.CustomerID FROM SalesLT.Customer Customer

	UPDATE Customer
	SET Customer.IsDeleted = 1, Customer.ModifiedDate = SYSUTCDATETIME()
	FROM SalesLT.Customer as Customer
	INNER JOIN DELETED AS Del on Customer.CustomerID = Del.CustomerID
	WHERE EXISTS (SELECT del.CustomerID FROM DELETED JOIN SalesLT.SalesOrderHeader SOH on Customer.CustomerID = SOH.CustomerID) --mialem tutaj blad bo dalem saleslt.customer zamiast from deleted
END
GO
		

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