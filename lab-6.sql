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
SET City = Cracow
WHERE CustomerID = 7


-- =============================================