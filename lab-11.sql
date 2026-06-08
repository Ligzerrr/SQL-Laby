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

INSERT INTO #ClothingSales (BName, CAT, QRT, RVN)
VALUES 
('Balenciaga', 'Footwear', 'Q1', 12000.00),
('Balenciaga', 'Footwear', 'Q2', 15000.00),
('Balenciaga', 'Footwear', 'Q3', 17000.00),
('Balenciaga', 'Footwear', 'Q4', 15000.00), --tutaj daje takie samo revenue jak q2, wtedy w dense_rank i rank pokaza roznice. Rank pominie ranking np 3 w tym przypadku a dense_rank da ex aequo
('Balenciaga', 'Clothing', 'Q1', 8000.00),
('Balenciaga', 'Clothing', 'Q2', 9500.00),
('Balenciaga', 'Clothing', 'Q3', 6000.00),
('Balenciaga', 'Clothing', 'Q4', 10500.00),
('Maison Margiela', 'Footwear', 'Q1', 7000.00),
('Maison Margiela', 'Footwear', 'Q2', 6000.00),
('Maison Margiela', 'Footwear', 'Q3', 8000.00),
('Maison Margiela', 'Footwear', 'Q4', 14000.00),
('Maison Margiela', 'Clothing', 'Q1', 6500.00),
('Maison Margiela', 'Clothing', 'Q2', 5000.00),
('Maison Margiela', 'Clothing', 'Q3', 8500.00),
('Maison Margiela', 'Clothing', 'Q4', 5000.00)
--Ponizszy select pozwoli na pokazanie biznesowi rankingu (revenue) roznych marek w danym kwartale.
--Biznes moze okreslic wtedy anomalie oraz wdrozyc wewnetrzne procedury dzieki ktorym przychody poprawia sie w nastepnym roku finansowym
SELECT BName, CAT, RANK() OVER (PARTITION BY CAT ORDER BY RVN DESC) AS REVENUE_RANK, DENSE_RANK() OVER (PARTITION BY CAT ORDER BY RVN DESC) AS REVENUE_DENSERANK, QRT
FROM #ClothingSales

-- =============================================
-- =============================================
-- Zadanie 3
--Dzieki ponizszemu PIVOTOWI biznes moze zobaczyc sume przychodow podzielona na kwartały (dla osobnych marek)
--Podobnie jak powyzsze zadanie pomaga to biznesowi wyznaczyc ryzyka/straty/zmiany.

SELECT *
FROM
(
	SELECT
		QRT, RVN, BNAME
	FROM #ClothingSales
) AS SRC
PIVOT
(
	SUM(RVN)
	FOR QRT IN ([Q1], [Q2], [Q3], [Q4])
) AS PVT

SELECT BName, QRT, RVN
FROM
(
	SELECT BName, [Q1], [Q2], [Q3], [Q4]
	FROM
	(
		SELECT QRT, RVN, BName From #ClothingSales
	) AS SRC
	PIVOT
	(
		SUM(RVN) FOR QRT IN ([Q1], [Q2], [Q3], [Q4])
	) AS PVT
) AS PVTRSL
UNPIVOT
(
	RVN FOR QRT IN ([Q1], [Q2], [Q3], [Q4])
) AS UnpivotRSL

-- =============================================
-- =============================================
-- Zadanie 4
-- =============================================