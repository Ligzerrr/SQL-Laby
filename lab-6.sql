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
SELECT * FROM SalesLT.Product WITH (Tablockx) --TABLOCKX powoduje Blokade całej tabeli, Wiersze oraz czasami stronę można zablokować poprzez zrobienie zbyt dużych zmian typu update, ale TABLOCKX jest najprostszym i najlepszym sposobem zablokowania całej tabeli.
-- Warto zaznaczyć, że z tej samej sesji zmiany przechodzą, ale np. inny użytkownik w sesji 2 musiałby poczekać aż tran zostanie commitowana lub rollbacknięta.
--Blokowanie tabeli jest niebezpieczne, wszystkie inne sesje nie mają wpływu na dane, a wszystko  pozostaję zależne od sesji, która zablokowała tabelę. Na dodatek im dłuższy lock tym większa szansa na timeout, który niesie ze sobą dużo problemów np. cancel query, (bardzo źle...)
--Blokowanie tabeli jest mniej optymalne, niż blokowanie samych wierszy - gdy np chcemy sie upewnic, że ktoś nie zmodyfikuję wierszy (na których pracujemy), ale dalej pozwala to na dodawanie i odczyt reszty tabeli!
ROLLBACK TRAN
-- =============================================
-- =============================================
-- Zadanie 2
BEGIN TRAN
UPDATE SalesLT.Address
SET City = 'Cracow'
WHERE AddressID = 470
UPDATE SalesLT.Address
SET City = 'Warsaw'
WHERE AddressID = 471
UPDATE SalesLT.Address
SET StateProvince = 'Lesser Poland'
WHERE AddressID = 479
UPDATE SalesLT.Address
SET AddressLine1 = 'Mongolia Drive 32'
WHERE AddressID = 482
Update SalesLT.Address
SET AddressLine2 = 'Fake China Town'
WHERE AddressID = 489
INSERT INTO SalesLT.Address(AddressLine1, City, StateProvince, CountryRegion, PostalCode)
VALUES('912 Davisson Street', 'Richmond', 'Indiana', 'United States', '47374'), ('1038 Alfred Drive', 'Bayside', 'New York', 'United States', '11361'),
('4813 Oakmound Road', 'Chicago', 'Illinois', 'United States', '60605'), ('3300 Yorkshire Circle', 'Greenville', 'North Carolina', 'United States', '27834'),
('2207 Randolph Street', 'Burlington', 'Massachusetts', 'United States', '01803')
--Zrobie w sumie SELECT po każdych 10 zmianach
SELECT *
FROM SalesLT.Address
--Brałem to z generatora adresów
UPDATE SalesLT.Product
SET Color = 'Brown'
WHERE ProductID BETWEEN 740 AND 751 --Tak będzie trochę wygodniej mi to zrobić

SELECT *
From SalesLT.Product
--Nie wiem o co chodzi z modyfikowaniem dokładnie więc zakładam o zmodyfikowanie ProductAttribute bo tam jest XML.
UPDATE SalesLT.ProductAttribute
SET Attributes.modify('replace value of (/Product/Size)[1] with "XXXXL"')
WHERE ProductID BETWEEN 680 AND 712

SELECT *
From SalesLT.ProductAttribute
--Tak samo zrobiłem jak poprzedni update
TRUNCATE TABLE SalesLT.ProductAttribute
SELECT *
From SalesLT.ProductAttribute
--Przed rollbackiem wszystkie zmiany (INSERTY UPDATEY oraz TRUNCATE TABLE) były widoczne ALE nie zostały zatwierdzone, rollback cofnął całą tranzakcję do stanu początkowego (czyli tabele efektywnie powróciły do stanu zerowego) Tabela tak się zachowuje przez ACID, D(urability) nie spełniło się z powodu braku COMMITA, więc dane tranzakcji nie zostały na dysku.
ROLLBACK TRAN
SELECT *
FROM SalesLT.Address
SELECT *
From SalesLT.Product
SELECT *
From SalesLT.ProductAttribute

-- =============================================
-- =============================================
-- Zadanie 3
BEGIN TRAN
UPDATE SalesLT.Address
SET City = 'Cracow'
WHERE AddressID = 470
UPDATE SalesLT.Address
SET City = 'Warsaw'
WHERE AddressID = 471
UPDATE SalesLT.Address
SET StateProvince = 'Lesser Poland'
WHERE AddressID = 479
WAITFOR DELAY '00:05:00'
UPDATE SalesLT.Address
SET AddressLine1 = 'Mongolia Drive 32'
WHERE AddressID = 482
Update SalesLT.Address
SET AddressLine2 = 'Fake China Town'
WHERE AddressID = 489
INSERT INTO SalesLT.Address(AddressLine1, City, StateProvince, CountryRegion, PostalCode)
VALUES('912 Davisson Street', 'Richmond', 'Indiana', 'United States', '47374'), ('1038 Alfred Drive', 'Bayside', 'New York', 'United States', '11361'),
('4813 Oakmound Road', 'Chicago', 'Illinois', 'United States', '60605'), ('3300 Yorkshire Circle', 'Greenville', 'North Carolina', 'United States', '27834'),
('2207 Randolph Street', 'Burlington', 'Massachusetts', 'United States', '01803')

SELECT *
FROM SalesLT.Address

UPDATE SalesLT.Product
SET Color = 'Brown'
WHERE ProductID BETWEEN 740 AND 751 

SELECT *
From SalesLT.Product

UPDATE SalesLT.ProductAttribute
SET Attributes.modify('replace value of (/Product/Size)[1] with "XXXXL"')
WHERE ProductID BETWEEN 680 AND 712

SELECT *
From SalesLT.ProductAttribute

TRUNCATE TABLE SalesLT.ProductAttribute
SELECT *
From SalesLT.ProductAttribute

ROLLBACK TRAN
SELECT *
FROM SalesLT.Address
SELECT *
From SalesLT.Product
SELECT *
From SalesLT.ProductAttribute

-- W niezależnej sesji odpaliłem:
/*
SELECT StateProvince
FROM SalesLT.Address
WHERE AddressID = 479
Ten select przez Read Commited Snapshot czytał mi snapshot danych aka dane, które były już commitowane.

Poniższy select ma WITH (NOLOCK), które obchodzi blokade, która wystąpiła przez WAITFOR DELAY i czyta już zupdateowane dane.
SELECT *
FROM SalesLT.Address
WITH (NOLOCK)
WHERE AddressID = 479
*/
-- =============================================
-- Zadanie 4
BEGIN TRY
	SELECT 2/0 AS [DIV ERROR]
END TRY
BEGIN CATCH
	PRINT 'Div Error'
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorNumber,
		ERROR_STATE() As ErrorNumber,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage
END CATCH
--Dzielenie przez 0 daje ErrorNumber 8134, Error Message "Divide by zero error encountered."
-- =============================================
-- Zadanie 5
DECLARE @CHANGEDLISTPRICE MONEY = 1500.50 --Tutaj wpisać co się chcę.
DECLARE @CHANGEDSTANDARDPRICE MONEY = 900.50
DECLARE @SELECTEDPRODUCTID INT = 717

BEGIN TRY
	IF @CHANGEDLISTPRICE < @CHANGEDSTANDARDPRICE
	BEGIN
		THROW 69594892
-- =============================================