-- =============================================
-- Piotr
-- Popiel
-- 240164
-- =============================================
/* X to P | Y to 240164 | N to 4 */
-- =============================================
-- =============================================
-- Zadanie 1
    SELECT 
        soh.SalesOrderID,
        soh.ShipDate,
        a.City,
        a.StateProvince,
        p.Name AS ProductName,
        pd.Description,
        sod.OrderQty,
        sod.LineTotal
    FROM 
        SalesLT.SalesOrderHeader soh
    JOIN 
        SalesLT.Address a ON soh.ShipToAddressID = a.AddressID
    JOIN 
        SalesLT.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN 
        SalesLT.Product p ON sod.ProductID = p.ProductID
    JOIN 
        SalesLT.ProductModelProductDescription pmpd ON p.ProductModelID = pmpd.ProductModelID
    JOIN 
        SalesLT.ProductDescription pd ON pmpd.ProductDescriptionID = pd.ProductDescriptionID
    WHERE 
        a.City IN ('London', 'Cambridge', 'Oxford')
        AND pmpd.Culture = 'en'
        AND soh.ShipDate IS NOT NULL
    ORDER BY 
        soh.ShipDate DESC, a.City ASC;
-- Po sprawdzeniu planu:
/*
    1. Nie ma żadnych: missing indexów, sort warningów lub implicit conversion (czyli nie ma ostrzeżeń).
    2. Est. number of row porownanie do actual number of rows: 344 -> 92; 762 -> 762; 271 -> 92; 127 -> 127; 271 -> 92; 295 -> 295; Optymalizator dokonał przeszacowania w niektórych węzłach i spodziewał się większej ilości wierszy, niż faktycznie ich było.
    3. Najwyższy cost % ma węzeł Clustered Index Scan (Clustered) [Product].[PK_Product_ProductID] [p] 29 % koszt, Clustered Scan oznacza , że cała tabela Product jest przeglądana, żeby znaleźć to czego potrzebuje.
    4. W niektorych nested loopach wystepuje przeszacowanie optymalizatora, brak odpowiedniego indexu zmusza do index scan z kosztem 29% co w kolei wymusza silnik do użycia hash matchu.
    5. Nie wystepują żadne keey lookup.
    6. Po jednym nested loopie wyszła cienka strzałka (3), która przed wejściem była gruba (32), zaszło skanowanie dużej ilości niepotrzebnych danych.
*/
-- =============================================
-- =============================================
-- Zadanie 2
    SELECT 
        p.Name AS ProductName,
        pc.Name AS CategoryName,
        SUM(sod.LineTotal) AS TotalRevenue,
        AVG(p.StandardCost) AS AvgCost,
        (SUM(sod.LineTotal) - SUM(sod.UnitPrice * sod.OrderQty)) AS ProfitMargin
    FROM 
        SalesLT.Product p
    JOIN 
        SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
    LEFT JOIN 
        SalesLT.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    WHERE 
        p.ProductNumber = '705' 
        OR p.ProductNumber LIKE 'B%'
        AND ISNULL(sod.UnitPrice, 0) > 0
    GROUP BY 
        p.Name, pc.Name
    ORDER BY 
        TotalRevenue DESC;

    CREATE NONCLUSTERED INDEX NCLST_PRDCT_NUMBER
    ON SalesLT.Product (ProductNumber) --Pokrywający indeks tutaj zamienia index scan na index seek.
    INCLUDE (Name, ProductCategoryID, StandardCost)
    GO
    CREATE NONCLUSTERED INDEX NCLST_SOD_UNIT
    ON SalesLT.SalesOrderDetail (ProductID) --
    INCLUDE (UnitPrice, LineTotal, OrderQty)
    GO
    DROP INDEX NCLST_SOD_UNIT ON SalesLT.SalesOrderDetail
    GO
    UPDATE STATISTICS SalesLT.SalesOrderDetail
    GO
    
    
-- =============================================
--ZADANIE 3 SIE NIE UDAŁO NIE MOGĘ POŁĄCZYĆ SIĘ Z PROFILEREM! (PROBOWALEM WSZYSTKIEGO)
-- =============================================
-- Zadanie 4
UPDATE STATISTICS SalesLT.SalesOrderDetail
GO
--Najwieksza tabela w bazie danych (przynajmniej zakładam, że tak powinno być), tutaj pojawia sie duzo nowych indeksow, czasami trzeba je usunac i optymalizator może być przez to w błędzie, tutaj też często uzywany moze byc INSERT dlatego warto ręcznie aktualizować statystyki.
-- =============================================