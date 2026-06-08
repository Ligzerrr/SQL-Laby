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
	BName nvarchar(50), --brand name
	CAT nvarchar(50), --category namz
	QRT nvarchar(5), --Quarter ze q1 q2 q3 q4
	RVN decimal(10,2) --revenue
	)
INSERT INTO #BrandSales (BName, CAT, QRT, RVN)
VALUES 
('Balenciaga', 'Footwear', 'Q1', 12000.00),
('Balenciaga', 'Footwear', 'Q2', 15000.00),
('Balenciaga', 'Clothing', 'Q1', 8000.00),
('Balenciaga', 'Clothing', 'Q2', 9500.00),
('Maison Margiela', 'Footwear', 'Q1', 7000.00),
('Maison Margiela', 'Footwear', 'Q2', 11000.00),
('Maison Margiela', 'Clothing', 'Q1', 6500.00),
('Maison Margiela', 'Clothing', 'Q2', 5000.00);
-- =============================================
-- =============================================
-- Zadanie 3
-- =============================================
-- =============================================
-- Zadanie 4
-- =============================================