-- =============================================
-- Piotr
-- Popiel
-- 240164
-- =============================================
/* X to P | Y to 240164 | N to 4 */
-- =============================================
-- =============================================
-- Zadanie 1

BEGIN TRAN

UPDATE SalesLT.Product WITH (TABLOCKX)
SET ListPrice = ListPrice * 10
SELECT * FROM SalesLT.Product --Nie miałem pomysłu jak inaczej dojść do blokady tabeli, gdy próbowałem 
SELECT 
    resource_type,
    request_mode,
    request_status
FROM sys.dm_tran_locks;
ROLLBACK TRAN
-- =============================================