USE AdventureWorks2019
GO
CREATE TRIGGER notifier
ON HumanResources.Department
AFTER INSERT, UPDATE 
AS 
BEGIN
   IF @@trancount > 0 ROLLBACK TRANSACTION
   ;THROW
   RETURN 55555
END;

-------------------------------------

CREATE TRIGGER notifier2
ON DATABASE
FOR ALTER_TABLE
AS 
BEGIN
   IF @@trancount > 0 ROLLBACK TRANSACTION
   ;THROW
   RETURN 55555
END;

-------------------------------------

IF OBJECT_ID ('dbo.ufnConcatStrings', 'IF') IS NOT NULL  
 DROP FUNCTION dbo.ufnConcatStrings;
GO
CREATE FUNCTION dbo.ufnConcatStrings(@first nvarchar, @last nvarchar)
RETURNS nvarchar(30)
AS
BEGIN
RETURN
( SELECT CONCAT_WS ('-', @first, @last)
  FROM Person.Person AS p
 WHERE p.FirstName = @first AND p.LastName = @last)
END;
SELECT * 
FROM dbo.ufnConcatStrings;

--------------------------------------

IF OBJECT_ID ('HumanResources.ufnEmployeeByDepartment', 'IF') IS NOT NULL  
    DROP FUNCTION HumanResources.ufnEmployeeByDepartment;
CREATE FUNCTION HumanResources.ufnEmployeeByDepartment (@storedId int)
RETURNS TABLE
AS
RETURN
(SELECT d.DepartmentID, e.*
FROM HumanResources.Employee AS e
JOIN HumanResources.EmployeeDepartmentHistory AS d ON e.BusinessEntityID = d.BusinessEntityID
WHERE d.DepartmentID = @storedId
);
SELECT *
FROM HumanResources.ufnEmployeeByDepartment(1);

----------------------------------------------

CREATE PROCEDURE Person.uspSearchByName 
(@Name nvarchar) AS
BEGIN
	SELECT p.BusinessEntityId, p.FirstName, p.LastName
	FROM Person.Person AS p
	WHERE p.FirstName LIKE '%' + @Name + '%' OR p.LastName LIKE '%' + @Name + '%'
END;
SELECT *
FROM Person.uspSearchByName('far');
