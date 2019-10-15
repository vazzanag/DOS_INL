CREATE PROCEDURE [training].[GetProjectCodesAtBusinessUnit]
    @BusinessUnitID INT
AS
SELECT ProjectCodeID, Code, BusinessUnitID, Acronym, BusinessUnitName,
       BusinessUnitActive, ProjectCodeBusinessUnitActive
  FROM [training].[ProjectCodesAtBusinessUnitView]
 WHERE BusinessUnitID = @BusinessUnitID;
