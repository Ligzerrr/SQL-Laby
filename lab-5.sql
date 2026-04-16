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
SET Title = 'Mr.'
WHERE CustomerID = 5
UPDATE [240164].[Customer]
SET Title = 'Ms.'
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

INSERT INTO [240164].[Customer](Title, FirstName, LastName, CompanyName, Phone, PasswordHash, PasswordSalt) --czy modifieddate tutaj też dodać? Niby widać to [zmiany] po samym StartSys i EndSys 
VALUES ('Mr.', 'Don', 'Patricio', 'Biking-Hiking 3000', '581-581-6901', '',''), ('Ms.', 'Shyanne', 'Pralic', 'Boy-Oh-Boy', '414-296-3610', '',''),
('Ms.', 'Monica', 'Patric', '3000Y Biking', '681-291-5891', '',''), ('Mr.', 'Patrick', 'Patric', 'Patrick-Land', '666-333-7777', '',''), ('Ms.', 'Tripanoshoa', 'Patrick', 'Cactus Lack', '696-676-7420', '','')
GO
-- =============================================
-- =============================================
-- Zadanie 4
SELECT *
FROM [240164].[Customer]
FOR SYSTEM_TIME ALL
WHERE CustomerID = 5
GO
-- =============================================
-- =============================================
-- Zadanie 5
SELECT *
FROM [240164].[Customer]
FOR SYSTEM_TIME AS OF '2026-04-16 10:00:00.000000' --Z poprzedniego zadania sprawdzilem kiedy były robione te zmiany i po prostu ustawiłem czas na przed tym zmianami, pewnie da się to zrobić inaczej ale na taki pomysł wpadłem bo najłatwiejszy. Moze jakbym dodał modifieddate jako getdate() to mógłbym przez WHERE sprawdzić ale chyba tak najprościej.
GO
-- =============================================
-- =============================================
-- Zadanie 6
CREATE XML SCHEMA COLLECTION AttributeSchema AS N'
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="Product" type="ProductAttribute"/>
  <xs:complexType name="ProductAttribute">
    <xs:sequence>
      <xs:element name="Color" type="xs:string"/>
      <xs:element name="ListPrice" type="xs:decimal"/>
	  <xs:element name="StandardCost" type="xs:decimal"/>
	  <xs:element name="Weight" type="xs:decimal"/>
	  <xs:element name="Size" type="xs:string"/>
	  <xs:element name="COF" type="xs:string"/>
	  <xs:element name="Material" type="xs:string"/>
    </xs:sequence>
  </xs:complexType>
</xs:schema>';
GO
CREATE TABLE [SalesLT].[ProductAttribute] (
	ProductID int PRIMARY KEY NOT NULL, --Moglbym zrobic attributeid ale w SalesLT.Product ProductID tez jest PK wiec stwierdzam, że po co, tam też są jakieś cechy wpisane, więc zakładam, że nagle ktoś nie będzie miał potrzeby dodania nowych cech do istniejącego produktu.
	Attributes xml(AttributeSchema) NULL,
	CONSTRAINT FORK_PRDTATT_PRDT FOREIGN KEY (ProductID) REFERENCES [SalesLT].[Product](ProductID)
	)
GO
-- =============================================
-- =============================================
-- Zadanie 7
INSERT INTO [SalesLT].[ProductAttribute](ProductID, Attributes)
VALUES (680, '<Product><Color>Black</Color><ListPrice>1431.5000</ListPrice><StandardCost>1059.3100</StandardCost><Weight>1016.04</Weight><Size>58</Size><COF>China</COF><Material>Steel</Material></Product>'),
(706, '<Product><Color>Red</Color><ListPrice>1431.5000</ListPrice><StandardCost>1059.3100</StandardCost><Weight>1016.04</Weight><Size>58</Size><COF>China</COF><Material>Steel</Material></Product>'), 
(707,'<Product><Color>Red</Color><ListPrice>34.9900</ListPrice><StandardCost>13.0863</StandardCost><Weight>402</Weight><Size>OS</Size><COF>Brazil</COF><Material>Plastic</Material></Product>'),
(708,'<Product><Color>Black</Color><ListPrice>34.9900</ListPrice><StandardCost>13.0863</StandardCost><Weight>402</Weight><Size>OS</Size><COF>Brazil</COF><Material>Plastic</Material></Product>'),
(709,'<Product><Color>White</Color><ListPrice>9.5000</ListPrice><StandardCost>3.3963</StandardCost><Weight>8005</Weight><Size>M</Size><COF>Vietnam</COF><Material>Stainless Steel</Material></Product>'),
(710,'<Product><Color>White</Color><ListPrice>9.5000</ListPrice><StandardCost>3.3963</StandardCost><Weight>8005</Weight><Size>L</Size><COF>Vietnam</COF><Material>Stainless Steel</Material></Product>'),
(711,'<Product><Color>Blue</Color><ListPrice>34.9900</ListPrice><StandardCost>13.0863</StandardCost><Weight>420</Weight><Size>XXL</Size><COF>Mongolia</COF><Material>Plastic</Material></Product>')
GO
-- =============================================
-- =============================================
-- Zadanie 8
UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify ('replace value of (/Product/Color)[1] with "Pearlescent"') --Nie wiem jak inaczej moglbym to zrobic, pewnie przez kombinowanie z warunkowymi modify() ale byłoby to bardzo żmudne, mam sporo rekordów, a zarazem dużo pól tekstowych, więc troche lepiej będzie mi to nadpisać zamiast używać .modify() ale dla pierwszego wiersza zrobiłem to normalnie.
WHERE ProductID = 680
UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify ('replace value of (/Product/Size)[1] with "PlusXL"')
WHERE ProductID = 680
UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify ('replace value of (/Product/COF)[1] with "Poland"')
WHERE ProductID = 680
UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify ('replace value of (/Product/Material)[1] with "Patina"')
WHERE ProductID = 680
UPDATE [SalesLT].[ProductAttribute]
SET Attributes = '<Product><Color>Plum</Color><ListPrice>1431.5000</ListPrice><StandardCost>1059.3100</StandardCost><Weight>1016.04</Weight><Size>PlusL</Size><COF>Pakistan</COF><Material>Plastic</Material></Product>'
WHERE ProductID = 706
UPDATE [SalesLT].[ProductAttribute]
SET Attributes = '<Product><Color>Pink</Color><ListPrice>34.9900</ListPrice><StandardCost>13.0863</StandardCost><Weight>402</Weight><Size>PlusXXL</Size><COF>Pakistan</COF><Material>Plastic</Material></Product>'
WHERE ProductID = 707
UPDATE [SalesLT].[ProductAttribute]
SET Attributes = '<Product><Color>Plague Black</Color><ListPrice>34.9900</ListPrice><StandardCost>13.0863</StandardCost><Weight>402</Weight><Size>PlusXXXL</Size><COF>Peru</COF><Material>Patina</Material></Product>'
WHERE ProductID = 708
UPDATE [SalesLT].[ProductAttribute]
SET Attributes = '<Product><Color>Plaque White</Color><ListPrice>9.5000</ListPrice><StandardCost>3.3963</StandardCost><Weight>8005</Weight><Size>PlusXXXL</Size><COF>Peru</COF><Material>Plastic mesh</Material></Product>'
WHERE ProductID = 709
UPDATE [SalesLT].[ProductAttribute]
SET Attributes = '<Product><Color>Polish Red</Color><ListPrice>9.5000</ListPrice><StandardCost>3.3963</StandardCost><Weight>8005</Weight><Size>PlusXXXXXXL</Size><COF>Panama</COF><Material>PBT</Material></Product>'
WHERE ProductID = 710
UPDATE [SalesLT].[ProductAttribute]
SET Attributes = '<Product><Color>Plank Brown</Color><ListPrice>34.9900</ListPrice><StandardCost>13.0863</StandardCost><Weight>420</Weight><Size>PLUSXXS</Size><COF>Paraguay</COF><Material>Phosphorous</Material></Product>'
WHERE ProductID = 711
-- =============================================
-- Zadanie 9
DECLARE @jsonAddress nvarchar(max) --zgodnie z zadaniem nvarchar(max), 
SET @jsonAddress = N'{
		"address":{
			"city":"Warsaw",
			"voivodeship":"Masovian",
			"country":"Poland",
			"zip-code":"00-002"
		}
	}'
SELECT @jsonAddress -- address przed zmiana zip-code na 240164

SET @jsonAddress = JSON_MODIFY(@jsonAddress, '$.address."zip-code"', '240164') --modifykacja za pomoca JSON_MODIFY

SELECT @jsonAddress as [240164JSON]

-- =============================================