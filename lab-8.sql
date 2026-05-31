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
	JOIN DELETED prdt on ins.ProductID	= prdt.ProductID --tutaj inaczej to mialem nazwac zamiast prdt mialo byc (del) ale pomylilo mi sie i juz mi sie nie chcialo zmieniac
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
BEGIN --Musze zrobic tutaj DELETE FROM Customer UPDATE Customer I INSERT INTO Customerslog inaczej nie wiem jak. If tez mozna zrobic ale tak chyba łatwiej mi to było zrobic.
	SET NOCOUNT ON
	INSERT INTO SalesLT.DeletedCustomersLog (CustomerID)
	SELECT Del.CustomerID FROM deleted Del
	WHERE EXISTS (SELECT CustomerID FROM SalesLT.SalesOrderHeader SOH Where SOH.CustomerID = Del.CustomerId)

	UPDATE Customer
	SET Customer.IsDeleted = 1, Customer.ModifiedDate = SYSUTCDATETIME()
	FROM SalesLT.Customer as Customer
	INNER JOIN DELETED AS Del on Customer.CustomerID = Del.CustomerID
	WHERE EXISTS (SELECT CustomerID FROM SalesLT.SalesOrderHeader SOH Where SOH.CustomerID = Del.CustomerI) --W commitach napisalem ale mialem caly zle ten warunek. Teraz juz jest poprawnie (chyba)

	DELETE FROM SalesLT.Customer
	WHERE CustomerID IN (SELECT CustomerID FROM DELETED Del WHERE NOT EXISTS (SELECT CustomerID FROM SalesLT.SalesOrderHeader SOH Where SOH.CustomerID = Del.CustomerID)) 
END
GO
		

-- =============================================
-- =============================================
-- Zadanie 3
WITH PRODUCTCATEGORYTHING AS (
	/* SELECT ParentProductCategoryID, ProductCategoryID, Name, 0 AS CategoryLevel
	FROM SalesLT.ProductCategory
	WHERE ParentProductCategoryID is NULL
	UNION ALL */
    --Mam tutaj dwa zastosowania, poniewaz nie dokladnie zrozumialem tresc zadania.
	--Pierwsze to zwyczajne wypisanie wszystkiego (tak jak jest ponizej oraz powyzej w zakomentarozwane)
	/* SELECT
		PrdtC.ParentProductCategoryID,
		PrdtC.ProductCategoryID,
		PrdtC.Name,
		PCT.CategoryLevel + 1
	FROM SalesLT.ProductCategory PrdtC
	JOIN PRODUCTCATEGORYTHING PCT on PrdtC.ParentProductCategoryId = PCT.ProductCategoryID */
	--Drugie to takie ze strzalkami tak jak w zadaniu.
	SELECT ParentProductCategoryID, ProductCategoryID, Name, CAST(Name AS NVARCHAR(MAX)) AS CategoryPath --Musze tutaj zrobić CAST as nvarchar poniewaz: Types don't match between the anchor and the recursive part in column "CategoryPath" of recursive query "PRODUCTCATEGORYTHING". 
	FROM SalesLT.ProductCategory
	WHERE ParentProductCategoryID is NULL

	UNION ALL

	SELECT
		PrdtC.ParentProductCategoryID,
		PrdtC.ProductCategoryID,
		prdtC.Name,
		PCT.CategoryPath + ' > ' + CAST(PrdtC.Name AS NVARCHAR(MAX)) --Tutaj musze tez dolozyc ten CAST tak podpowiada internet :)
	FROM SalesLT.ProductCategory PrdtC
	JOIN PRODUCTCATEGORYTHING PCT on PrdtC.ParentProductCategoryID = PCT.ProductCategoryID
	--Nie wiem dlaczego ale wynik wszystkiego mi sie wyswietla tylko jako np. "Bikes > Mountain Bikes" a Mountain Frames sa podpiete pod Komponenty ? nie wiem jak to naprawic.
)
SELECT *
FROM ProductCategoryThing
ORDER BY ParentProductCategoryID, ProductCategoryID
GO
-- =============================================
-- =============================================
-- Zadanie 4
CREATE TRIGGER PriceChangeAlert
on SalesLT.Product
AFTER UPDATE
AS
BEGIN
	if UPDATE(ListPrice) --najpierw trzeba sprawdzic czy wgl byla jakakolwiek zmiana na kolumnie
	BEGIN
		if exists (
			SELECT ProductID
			FROM inserted Ins
			JOIN Deleted Del on Ins.ProductID = Del.ProductID
			where Ins.ListPrice > (Del.ListPrice * 1.20)
			)
			BEGIN
				INSERT INTO SalesLT.ProductPriceHistory (ProductID, OLDLP, NEWLP, ChangedDate)
				SELECT Ins.ProductID, Del.ListPrice, Ins.ListPrice, GetDate()
				FROM Inserted Ins
				JOIN Deleted Del on Ins.ProductID = Del.ProductID
				WHERE Ins.ListPrice > (Del.ListPrice * 1.20)

				ROLLBACK tran
			END
	END
END
GO

-- =============================================
-- =============================================
-- Zadanie 5

-- =============================================
-- =============================================
-- Zadanie 6
-- =============================================