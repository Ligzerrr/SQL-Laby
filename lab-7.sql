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
-- =============================================
-- =============================================
-- Zadanie 2
--Tutaj deklaruje zmienna jsonowa
DECLARE @ProductInfo NVARCHAR(MAX) = N'[{"ProductID":717