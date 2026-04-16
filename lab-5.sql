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
	StartSys datetime2 GENERATED ALWAYS AS ROW START DEFAULT GETDATE() NOT NULL, --Musiałem dodać defaultowe wartości inaczej nie przepuści mnie alter table 
	EndSys datetime2 GENERATED ALWAYS AS ROW END DEFAULT '9999-12-31 23:59:59.9999999' NOT NULL,
	PERIOD FOR SYSTEM_TIME (StartSys, EndSys)
GO
ALTER TABLE [240164].[Customer]
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [240164].[CustomerHistory]))
-- =============================================
-- =============================================
-- Zadanie 3
UPDATE [240164].[Customer]
SET FirstName = 'Kesha', Title = 'Ms.'
WHERE CustomerID = 2
UPDATE [240164].[Customer]
SET FirstName = 'Donovan', Title = 'Mr.', LastName = 'Smith', Suffix = 'Sr.'
WHERE CustomerID = 3
UPDATE [240164].[Customer]
SET FirstName = 'Jane', LastName = 'Remover'
WHERE CustomerID = 4
UPDATE [240164].[Customer]
SET LastName = 'Bedroque', Title = 'Ms.'
WHERE CustomerID = 5
UPDATE [240164].[Customer]
SET MiddleName = 'L.'
WHERE CustomerID = 7
UPDATE [240164].[Customer]
SET CompanyName = '3000-Promise'
WHERE CustomerID = 23
UPDATE [240164].[Customer]
SET Phone = '233-251-6244'
WHERE CustomerID = 55
UPDATE [240164].[Customer]
SET FirstName = 'Janet'
WHERe CustomerID = 65
UPDATE [240164].[Customer]
SET LastName = 'Grander'
WHERE CustomerID = 142
UPDATE [240164].[Customer]
SET LastName = 'Mongolian'
WHERE CustomerID = 34
GO

INSERT INTO [240164].[Customer](Title, FirstName, LastName, CompanyName, Phone, PasswordHash, PasswordSalt)
VALUES ('Mr.', 'Don', 'Patricio', 'Biking-Hiking 3000', '581-581-6901', '',''), ('Ms.', 'Shyanne', 'Pralic', 'Boy-Oh-Boy', '414-296-3610', '',''),
('Ms.', 'Monica', 'Patric', '3000Y Biking', '681-291-5891', '',''), ('Mr.', 'Patrick', 'Patric', 'Patrick-Land', '666-333-7777', '',''), ('Ms.', 'Tripanoshoa', 'Patrick', 'Cactus Lack', '696-676-7420', '','')

-- =============================================
