-- =============================================
-- Piotr
-- Popiel
-- 240164
-- =============================================
/* X to P | Y to 240164 | N to 4 */
-- =============================================
-- =============================================
-- Zadanie 1
--niestety w widoku zrobilem tylko dwie kolumny nie wiem czy to działa, wiec musialem byle co dopisac tutaj.
CREATE FUNCTION SalesLT.BestRecord
(
	@SDATE Date = '2006-01-01',
	@SNAMELENGTH int = 50,
	@SCHAR char = 'D'
)
	RETURNS nvarchar(50)
AS
BEGIN
		DECLARE @BestLastName nvarchar(50)
		SELECT TOP 1 @BestLastName = LastName
		FROM dbo.[240164_Order]
		WHERE @SDATE < GETDATE() AND LastName Like @SCHAR AND LEN(FirstName) < @SNAMELENGTH --Musialbym chyba zmienic widok zeby inaczej to zrobic :/
		ORDER BY FirstName
		RETURN @BestLastName
END

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
-- =============================================
-- Zadanie 5
-- =============================================
-- =============================================
-- Zadanie 6
-- =============================================
-- =============================================
-- Zadanie 7
-- =============================================