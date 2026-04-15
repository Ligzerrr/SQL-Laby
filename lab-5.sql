-- =============================================
-- Piotr
-- Popiel
-- 240164
-- =============================================
/* X to P | Y to 240164 | N to 4 */
-- =============================================
-- =============================================
-- Zadanie 1
https://github.com/Ligzerrr/SQL-Laby/tree/lab-5-database
-- =============================================
-- =============================================
-- Zadanie 2
ALTER TABLE [240164].[Customer] 
ADD
	StartSys datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
	EndSys datetime2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (StartSys, EndSys)
GO
ALTER TABLE [240164].[Customer]
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [240164].[CustomerHistory]))
-- =============================================
-- =============================================
-- Zadanie 3


-- =============================================
