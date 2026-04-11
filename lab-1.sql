-- =============================================
-- Piotr
-- Popiel
-- 240164
-- =============================================
/* X to P | Y to 240164 | N to 4 */
-- =============================================
-- Zadanie 1
SELECT *
FROM SalesLT.Customer
WHERE LastName LIKE 'P%'
GO
-- =============================================

-- =============================================
-- Zadanie 2
SELECT FirstName, LastName, EmailAddress
FROM SalesLT.Customer
WHERE CustomerID LIKE '%4'
GO
-- =============================================

-- =============================================
-- Zadanie 3
SELECT Name, ListPrice, ProductNumber
FROM SalesLT.Product
WHERE Name LIKE '%P%'
GO
-- =============================================

-- =============================================
-- Zadanie 4
SELECT AVG(ListPrice) as [Average Cena]
FROM SalesLT.Product
WHERE ProductCategoryID % 10 = 4
GO
-- =============================================

-- =============================================
-- Zadanie 5
SELECT distinct adrs.City
FROM SalesLT.Address adrs
JOIN SalesLT.CustomerAddress cadrs on adrs.AddressID = cadrs.AddressID
WHERE adrs.City LIKE 'P%'
GO
-- =============================================

-- =============================================
-- Zadanie 6
INSERT INTO SalesLt.Customer(FirstName, LastName, CompanyName, EmailAddress, PasswordHash, PasswordSalt) --Cannot insert the value NULL into column 'PasswordHash', table 'sql-adb-s12346-dev-pl.SalesLT.Customer'; column does not allow nulls. INSERT fails. Nie pozwala na nulle (hash i salt), więc trzeba dodać puste wartości
VALUES ('Piotr', 'Popiel', 'Lab4', 'Piotr.Popiel@lab4.com', '', '')
GO
-- =============================================

-- =============================================
-- Zadanie 7
INSERT INTO SalesLT.ProductCategory(Name) --Widzialem ze znajomi robili to dodawajac tez nowe RowGuid, mnie przepuszczało bez i tworzyło samo sie nowe rowguid, (chyba nadane sa default values newid itd.), ale znam zastosowanie NEWID() oraz GETDATE()
VALUES ('Special-P'), ('Extra-4')
GO
-- =============================================

-- =============================================
-- Zadanie 8
SELECT pdct.[Name], pdct.ProductNumber, pdctgr.[Name] as Category, 240164 as OwnerID
Into ProductCategories240164
FROM SalesLT.Product pdct
JOIN SalesLT.ProductCategory pdctgr on pdct.ProductCategoryID = pdctgr.ProductCategoryID
WHERE pdct.[Name] LIKE 'P%P' OR pdctgr.[Name] LIKE '%P%'
GO
-- =============================================

-- =============================================
-- Zadanie 9
SELECT Count(Category) as [CountedProducts], Category 
FROM ProductCategories240164
GROUP BY Category
GO
-- =============================================