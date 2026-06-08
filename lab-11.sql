﻿-- =============================================
-- Piotr
-- Popiel
-- 240164
-- =============================================
/* X to P | Y to 240164 | N to 4 */
-- =============================================
-- =============================================
-- Zadanie 1
SELECT CTG.CategoryName, MIN(PRDT.ListPrice) OVER (Partition By ProductCategoryID) as MINLP, MAX(PRDT.ListPrice) OVER (Partition By P.ProductCategoryID) as MAXLP, Count(*) OVER (Partition by P.ProductCategoryID) as VOL
FROM SalesLT.Product PRDT
JOIN SalesLT.ProductCategory CTG on PRDT.ProductCategoryID = CTG.ProductCategoryID
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