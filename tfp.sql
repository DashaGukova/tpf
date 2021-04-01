USE AdventureWorks2019
GO
CREATE TRIGGER notifier
ON HumanResources.Department
AFTER INSERT, UPDATE 
AS 
BEGIN
   THROW 50000, 'Using insert, update unacceptable', 1;
END;

-------------------------------------

CREATE TRIGGER notifier2
ON DATABASE
FOR ALTER_TABLE
AS 
BEGIN
   THROW 50001, 'Using insert, update unacceptable', 1;
END;

-------------------------------------

IF OBJECT_ID ('dbo.ufnConcatStrings', 'IF') IS NOT NULL  
 DROP FUNCTION dbo.ufnConcatStrings;
GO
CREATE FUNCTION dbo.ufnConcatStrings (@first nvarchar(20), @last nvarchar(20))
RETURNS nvarchar(50)
AS
BEGIN
RETURN
CONCAT_WS ('-', @first, @last)
END;
GO
SELECT dbo.ufnConcatStrings ('FRESG', 'OIUYT');

--------------------------------------

IF OBJECT_ID ('HumanResources.ufnEmployeeByDepartment', 'IF') IS NOT NULL  
    DROP FUNCTION HumanResources.ufnEmployeeByDepartment;
CREATE FUNCTION HumanResources.ufnEmployeeByDepartment (@storedId int)
RETURNS TABLE
AS
RETURN
SELECT e.*
 FROM HumanResources.Employee AS e
 JOIN HumanResources.EmployeeDepartmentHistory AS d ON e.BusinessEntityID = d.BusinessEntityID
 WHERE d.DepartmentID = @storedId;
GO
SELECT HumanResources.ufnEmployeeByDepartment(1);

----------------------------------------------

CREATE PROCEDURE Person.uspSearchByName 
(@Name nvarchar (20)) AS
BEGIN
    @SetName = '%' + @Name + '%'
	SELECT p.BusinessEntityId, p.FirstName, p.LastName
	FROM Person.Person AS p
	WHERE p.FirstName LIKE @SetName OR p.LastName LIKE @SetName
END;
GO
SELECT Person.uspSearchByName('far');
