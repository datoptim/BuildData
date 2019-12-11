USE [master]
GO

-- Debemos tener la tabla #Names que está en el Git referenciado al principio. El enlace:
-- https://github.com/datoptim/BuildData/blob/9131addd0a3d16a128b4364b8fde4eae465c2235/PeopleNames.sql


/*
	1. Creamos una temporal para generar dos nombres aleatorios
	Generamos los códigos de nombre para usar con la tabla #Names
*/

SELECT TOP 1000000
	CAST(4949 * RAND(CHECKSUM(NEWID()))+1 AS INT) AS Name1,
	CAST(4949 * RAND(CHECKSUM(NEWID()))+1 AS INT) AS Name2
INTO #TempNames
FROM [sys].[all_objects] a​
CROSS JOIN [sys].[all_objects] b



/*
	2. Preparamos la tabla final para nuestros datos aleatorios
*/

CREATE TABLE #FakeTable (​
	RowId INT IDENTITY(1,1) PRIMARY KEY,​
	Name VARCHAR(16),​
	MiddleName VARCHAR(16),​
	Office INT,
	Gender SMALLINT,
	DescriptionText VARCHAR(500)
	)



/*
	3. Preparamos una variable para generar textos aleatorios
*/

DECLARE @lorem varchar(1000)
SET @lorem = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse varius arcu purus, nec tristique elit pharetra ut. Vestibulum lobortis sagittis bibendum. Duis a libero interdum, faucibus dolor id, elementum purus. Fusce euismod fringilla libero. Suspendisse ac consectetur nisi, non scelerisque diam. Pellentesque ultrices dapibus accumsan. Phasellus cursus pulvinar mauris, eu elementum felis tempor vel. Praesent tellus eros, rutrum ac facilisis quis, tincidunt nec ipsum. Duis arcu arcu, aliquet in dapibus sed, iaculis ut metus. Etiam non dolor id augue condimentum consectetur vel et nisi. Integer quis eleifend lectus. Nunc vitae venenatis urna. Nulla imperdiet vel nunc quis mollis. Donec tincidunt maximus cursus. Aenean feugiat ante nec nulla convallis lacinia. Curabitur turpis lorem, maximus congue luctus mattis, ullamcorper id erat. ​
​
Integer ullamcorper maximus eros id fermentum. Maecenas in dui rutrum, ullamcorper dolor in, tristique mauris. Morbi auctor ornare leo, vitae posuere. '​




/*
	4. Insertamos todos los datos aleatorios en la tabla #FakeTable
*/

INSERT INTO #FakeTable  (Name, MiddleName, Office, Gender, DescriptionText) 
SELECT 
	b.name AS Name, 
	c.name AS MiddleName, 
	CAST(200 * RAND(CHECKSUM(NEWID()))+100 AS INT) AS Office,
	CAST(5 * RAND(CHECKSUM(NEWID()))+1 AS INT) AS Gender,
	SUBSTRING(@lorem,1,CAST(500 * RAND(CHECKSUM(NEWID())) AS INT)) AS DescriptionText
FROM #TempNames a
INNER JOIN #Names b
	ON a.Name1 = b.id
INNER JOIN #Names c
	ON a.Name2 = c.id



