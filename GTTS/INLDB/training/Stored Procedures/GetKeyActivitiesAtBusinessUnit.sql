CREATE PROCEDURE [training].[GetKeyActivitiesAtBusinessUnit]
	@BusinessUnitID INT
AS
SELECT KeyActivityID, Code, BusinessUnitID, Acronym, BusinessUnitName,
       BusinessUnitActive, KeyActivityBusinessUnitActive
  FROM [training].KeyActivitesAtBusinessUnitView
 WHERE BusinessUnitID = @BusinessUnitID;
