-- =============================================
-- Piotr
-- Popiel
-- 240164
-- =============================================
/* X to P | Y to 240164 | N to 4 */
-- =============================================
-- ZADANIE 1
IF OBJECT_ID('SalesLT.Vendor', 'U') IS NOT NULL
    DROP TABLE SalesLT.Vendor;
GO
CREATE TABLE SalesLT.Vendor (
    VendorID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    AccountNumber NVARCHAR(20) NOT NULL,
    CreditRating TINYINT NOT NULL, -- 1 do 5
    ActiveFlag BIT DEFAULT 1
);

IF OBJECT_ID('SalesLT.ProductVendor', 'U') IS NOT NULL
    DROP TABLE SalesLT.ProductVendor;
GO
CREATE TABLE SalesLT.ProductVendor (
    ProductID INT NOT NULL,
    VendorID INT NOT NULL,
    StandardPrice MONEY NOT NULL,
    AverageLeadTime INT NOT NULL, -- Czas dostawy w dniach
);

IF OBJECT_ID('SalesLT.ProductBOM', 'U') IS NOT NULL
    DROP TABLE SalesLT.ProductBOM;
GO
CREATE TABLE SalesLT.ProductBOM (
    BOMID INT,
    ParentProductID INT NOT NULL,    -- Rower
    ComponentProductID INT NOT NULL, -- Rama
    Quantity DECIMAL(18,2) DEFAULT 1.0,
    InstructionStep INT,             -- Kolejno?? monta?u
    CONSTRAINT FK_BOM_Parent FOREIGN KEY (ParentProductID) REFERENCES SalesLT.Product(ProductID),
    CONSTRAINT FK_BOM_Component FOREIGN KEY (ComponentProductID) REFERENCES SalesLT.Product(ProductID)
);
GO


IF OBJECT_ID('SalesLT.VendorPriceHistory', 'U') IS NOT NULL
    DROP TABLE SalesLT.VendorPriceHistory;
GO
CREATE TABLE SalesLT.VendorPriceHistory (
    QuoteID BIGINT,
    VendorID INT NOT NULL,
    ProductID INT NOT NULL,
    Price MONEY NOT NULL,
    QuoteDate DATETIME NOT NULL
);
GO



IF OBJECT_ID('SalesLT.ShipmentTrackingEvents', 'U') IS NOT NULL
    DROP TABLE SalesLT.ShipmentTrackingEvents;
GO
CREATE TABLE SalesLT.ShipmentTrackingEvents (
    EventID BIGINT,
    SalesOrderID INT NOT NULL, -- FK do istniej?cych zamówie?
    EventDate DATETIME NOT NULL,
    Location VARCHAR(100),
    Status VARCHAR(50),
    Notes VARCHAR(200)
);
GO


INSERT INTO SalesLT.Vendor (Name, AccountNumber, CreditRating, ActiveFlag)
SELECT TOP 500000
    'Dostawca ' + CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS NVARCHAR(10)),
    'ACT' + CAST(10000 + ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS NVARCHAR(10)),
    (ABS(CHECKSUM(NEWID())) % 5) + 1,
    1
FROM sys.all_objects a CROSS JOIN sys.all_objects b;
GO


INSERT INTO SalesLT.ProductVendor (ProductID, VendorID, StandardPrice, AverageLeadTime)
SELECT 
    p.ProductID,
    v.VendorID,
    p.ListPrice * RAND(10000) * 0.1, -- Cena zakupu to 60% ceny sprzeda?y
    (ABS(CHECKSUM(NEWID())) % 15) + 1 -- Czas dostawy 1-15 dni
FROM SalesLT.Product p
CROSS APPLY (
    -- Wybierz 10 losowych dostawców dla ka?dego produktu
    SELECT TOP 15 VendorID 
    FROM SalesLT.Vendor 
    ORDER BY NEWID()
) v;
GO


-- Generowanie milionów rekordów
INSERT INTO SalesLT.VendorPriceHistory (VendorID, ProductID, Price, QuoteDate)
SELECT 
    pv.VendorID,
    pv.ProductID,
    pv.StandardPrice * (1 + (CAST(ABS(CHECKSUM(NEWID())) % 20 AS FLOAT) - 10) / 100), -- Fluktuacja ceny +/- 10%
    DATEADD(DAY, -n.Number, GETDATE()) -- Cena z ka?dego z ostatnich 'N' dni
FROM SalesLT.ProductVendor pv
CROSS JOIN (
    SELECT TOP 1000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS Number
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
) n;
GO

INSERT INTO SalesLT.ProductBOM (ParentProductID, ComponentProductID, Quantity, InstructionStep)
SELECT 
    p_parent.ProductID,
    p_child.ProductID,
    1,
    1
FROM SalesLT.Product p_parent
CROSS JOIN SalesLT.Product p_child
WHERE p_parent.Name LIKE '%Bike%' 
  AND (p_child.Name LIKE '%Frame%' OR p_child.Name LIKE '%Wheel%')
  AND p_parent.ProductID <> p_child.ProductID;
GO




INSERT INTO SalesLT.ShipmentTrackingEvents (SalesOrderID, EventDate, Location, Status, Notes)
SELECT 
    soh.SalesOrderID,
    -- Data zdarzenia przesuni?ta wzgl?dem daty zamówienia
    DATEADD(HOUR, x.HoursOffset, soh.OrderDate),
    -- Losowa lokalizacja z listy
    x.Location,
    -- Status
    x.Status,
    -- Dodatkowa notatka
    x.Note
FROM SalesLT.SalesOrderHeader soh
CROSS JOIN (
    -- Symulujemy 5 etapów podró?y dla KA?DEGO zamówienia
    SELECT 2 AS HoursOffset, 'Magazyn Centralny' AS Location, 'Picked' AS Status, 'Skompletowano' AS Note UNION ALL
    SELECT 6, 'Magazyn Centralny', 'Shipped', 'Wydano kurierowi' UNION ALL
    SELECT 18, 'Sortownia Regionalna Wawa', 'Arrived', 'Skanowanie w sortowni' UNION ALL
    SELECT 24, 'Sortownia Regionalna Wawa', 'Departed', 'Wyjazd z sortowni' UNION ALL
    SELECT 30, 'Lokalny Oddzia?', 'OutForDelivery', 'Wydano do dor?czenia' UNION ALL
    SELECT 32, 'Adres Klienta', 'Delivered', 'Pozostawiono pod drzwiami'
) AS x

ALTER TABLE SalesLT.ProductVendor ADD CONSTRAINT PriK_PVNDR PRIMARY KEY (ProductID, VendorID) -- Brakujace primary key = automatycznie stworzony indeks klastrowy
GO
ALTER TABLE SalesLT.ProductBOM ADD CONSTRAINT PriK_PBOM PRIMARY KEY (ParentProductID, ComponentProductID) --Brakujace primary key BOMID nie jest NOT Nullem wiec nie moze byc PriK
GO
ALTER TABLE SalesLT.VendorPriceHistory ADD CONSTRAINT PriK_VPRHST PRIMARY KEY (ProductID, VendorID, QuoteDate) -- Brakujace primary key
GO
CREATE NONCLUSTERED INDEX NCLST_STEVENTS
ON SalesLT.ShipmentTrackingEvents (SalesOrderID)
INCLUDE (Status, Location, EventDate) --Nie uwzglednilem notes w include z uwagi na rozmiar ale gdyby go uwzlegnid mozna by napewno zrobic pokrywajcy sie index dla selecta wyzej(include pozwala na przechowanie wraz z kolumnami z indexu (nie sa sortowane)).
GO
CREATE NONCLUSTERED INDEX NCLST_VENDOR
ON SalesLT.Vendor (Name, VendorID) --Name jest bardzo czesto wykorzystywane do WHERE + lepiej jak jest głownym kluczu dzieki posortowaniu itp 
GO
CREATE NONCLUSTERED INDEX NCLST_VPHISTORY
ON SalesLT.VendorPriceHistory (VendorID)
INCLUDE (QuoteDate) --Index jest lzejszy gdy date wrzuci sie do includa zamiast głownej czesci indexu, czesto uzywana jest data wiec pewnie pomoze dzieki pokrywaniu.
GO
CREATE NONCLUSTERED INDEX NCLST_PVENDOR
ON SalesLT.ProductVendor (VendorID) 
GO
--Zastosowalem indeksy klastrowy (czyli tam gdzie sa primary key), zapewniaja unikalnosc oraz uporzadkowanie.
--Zastosowałem indeksy nieklastrowe tam gdzie kolumny wykorzystywane są do SELECT, FK i JOIN (np przyspieszenie wyszukiwania po nazwie dostawcy poniewaz czesto to robimy)
-- =============================================
-- Zadanie 2
CREATE NONCLUSTERED INDEX NCLST_VENDOR_ACC_NAMENUM 
ON SalesLT.Vendor (Name, AccountNumber) --nie uwzgledniam activeflag ze wzgledu na to ze jest zero jedynkowa
WHERE ActiveFlag = 1
-- =============================================
-- =============================================
-- Zadanie 3
CREATE NONCLUSTERED INDEX NLCST_ADR_STATE --indeks pokrywajacy, przyspieszy generowanie jakiegos raportu dla jakiegos klienta
ON SalesLT.Address (StateProvince) --bede uzywal do szukania where w select 
INCLUDE (City, AddressLine1); --reszta pokrycia
GO
SELECT City, AddressLine1 
FROM SalesLT.Address
WHERE StateProvince LIKE 'O%'
GO

CREATE NONCLUSTERED INDEX NCLST_PRDC_NOTAVAILABLE --indeks filtrowany dzieki ktoremu mozemy latwo znalezc liste produktow wycofanych np. gdy ktos potrzebuje znalezc archiwalne modele jakiegos roweru
ON SalesLT.Product (Name, ProductNumber)
WHERE SellEndDate IS NOT NULL
GO

SELECT ProductNumber, Name
FROM SalesLT.Product
WHERE SellEndDate IS NOT NULL AND NAME LIKE '%Road%'

CREATE NONCLUSTERED INDEX NCLST_CADRS_
-- =============================================