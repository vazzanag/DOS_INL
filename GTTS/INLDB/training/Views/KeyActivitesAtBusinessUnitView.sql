CREATE VIEW [training].[KeyActivitesAtBusinessUnitView]
AS 
    SELECT ka.KeyActivityID, ka.Code AS Code, kb.BusinessUnitID, b.Acronym, b.BusinessUnitName,
           b.IsActive AS BusinessUnitActive, kb.IsActive AS KeyActivityBusinessUnitActive
	  FROM training.KeyActivities ka
INNER JOIN training.KeyActivitiesAtBusinessUnit kb ON ka.KeyActivityID = kb.KeyActivityID
INNER JOIN users.BusinessUnits b ON kb.BusinessUnitID = b.BusinessUnitID;
