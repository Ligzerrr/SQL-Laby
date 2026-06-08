﻿-- =============================================
-- Piotr
-- Popiel
-- 240164
-- =============================================
/* X to P | Y to 240164 | N to 4 */
-- =============================================
-- =============================================
-- Zadanie 1
SELECT DISTINCT CTG.Name, MIN(PRDT.ListPrice) OVER (Partition By PRDT.ProductCategoryID) as MINLP, MAX(PRDT.ListPrice) OVER (Partition By PRDT.ProductCategoryID) as MAXLP, Count(*) OVER (Partition by PRDT.ProductCategoryID) as VOL
FROM SalesLT.Product PRDT
JOIN SalesLT.ProductCategory CTG on PRDT.ProductCategoryID = CTG.ProductCategoryID
-- =============================================
-- =============================================
-- Zadanie 2
--Stworze wlasna tabele bo latwiej bedzie mi pracowac nad tym niz tabelami z advworks.
CREATE TABLE #ClothingSales (
	Name nvarchar(50),

-- =============================================
-- =============================================
-- Zadanie 3
-- =============================================
-- =============================================
-- Zadanie 4
-- =============================================