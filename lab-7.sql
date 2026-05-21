-- =============================================
-- Piotr
-- Popiel
-- 240164
-- =============================================
/* X to P | Y to 240164 | N to 4 */
-- =============================================
-- =============================================
-- Zadanie 1
CREATE TYPE dbo.P4_surname FROM NVARCHAR(50) NOT NULL -- Tworze własny typ danych P4_surname 
GO

ALTER TABLE [240164].[Customer] --To chyba jedyna tabela ktora zawiera LastName, chyba, że coś przeoczyłem ze zmęczenia.
ALTER COLUMN LastName P4_surname
GO
-- =============================================
-- =============================================
-- Zadanie 2
--Tworze widok z jakas tam nazwa 
CREATE VIEW dbo.JSONCOS AS 
SELECT ProductID, ListPrice
FROM SalesLT.Product
GO
--Tutaj deklaruje zmienna jsonowa, dowiedzialem sie, ze nie mozna zrobic dac do widoku zmiennej takiej wiec musze to zrobic za pomoca dwoch selectow, chyba ze jest jakas inna opcja.
DECLARE @ProductInfo NVARCHAR(MAX) = N'[{"ProductID":717, "NewPrice": 1730.13},{"ProductID":718, "NewPrice": 2003.30},{"ProductID": 720, "NewPrice": 6001.34},{"ProductID": 730, "NewPrice": 50.31},{"ProductID": 740, "NewPrice": 705.50}]'

SELECT vw.ProductID, vw.ListPrice, pinfo.NewPrice, (pinfo.NewPrice - vw.ListPrice) as Diff
FROM dbo.JSONCOS vw
INNER JOIN OPENJSON(@ProductInfo)
WITH ( ProductID int '$.ProductID', NewPrice money '$.NewPrice') pinfo ON vw.ProductID = pinfo.ProductID
GO
-- =============================================
-- =============================================
-- Zadanie 3
--Tak samo jak w zad 4 i 5 daje juz OR ALTER VIEW przez ilosc zmian
CREATE OR ALTER VIEW dbo.[240164_Order] AS
SELECT TOP 1000 LastName, FirstName --Chyba tak to trzeba zrobic jesli widok ma zawierac ORDER BY. Mozna jeszcze zrobic bez TOP ale potrzeba wtedy wziac ORDER BY do nastepnego SELECTA, ale chyba o to rozwiazanie chodzilo.
FROM [240164].[Customer]
ORDER BY LastName DESC
GO

SELECT *
FROM dbo.[240164_Order]
GO
-- =============================================
-- =============================================
-- Zadanie 4
--Prosty widok przedstawiający przewidywaną cenę z marzą, oficjalną cenę netto, oraz cenę brutto (podatek vat 23%)
--Oczywiscie zakladam ze standardcost oraz ListPrice nie są opodatkowane.
--Dzieki temu widokowi biznes wie jaka jest sugerowana cena, ułatwi to ludziom odpowiedzialnym za ustawianie cen łatwiej dopasować ceny.
--Dalem or ALTER VIEW, poniewaz musialem zmienic cos potrzebnego do nastepnego zadania!
CREATE OR ALTER VIEW Student_4.MyLogicView AS
SELECT ProductID as [P ID], ListPrice as [Net Price], (StandardCost * 1.15) as [Predicted Net Price], (ListPrice * 1.23) as [Gross Price]
FROM SalesLT.Product
GO

SELECT *
FROM Student_4.MyLogicView
ORDER BY [Net Price] DESC
GO

-- =============================================
-- =============================================
-- Zadanie 5
--Tutaj użyje po prostu mojego widoku z zadania 4, dzięki temu nie bede musiał wymyslać kolejnego widoku.
--Widok pozwoli na wyswietlenie produktow ktore maja cene netto ustawiona na albo zbyt wysoka albo zbyt niska (w relacji do Predicted Net Price)
CREATE OR ALTER VIEW Student_4.BetterLogicIG AS
SELECT [P ID], [Net Price], [Predicted Net Price], ([Predicted Net Price] - [Net Price]) as [Price diff]
FROM Student_4.MyLogicView
WHERE [Predicted Net Price] <> [Net Price]
GO

SELECT * 
FROM Student_4.BetterLogicIG
ORDER BY [Price Diff] ASC
-- =============================================
