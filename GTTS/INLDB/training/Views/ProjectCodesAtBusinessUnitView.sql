CREATE VIEW [training].[ProjectCodesAtBusinessUnitView]
AS
    SELECT c.ProjectCodeID, c.Code, c.[Description], cb.BusinessUnitID, b.Acronym, b.BusinessUnitName,
           b.IsActive AS BusinessUnitActive, cb.IsActive AS ProjectCodeBusinessUnitActive
	  FROM training.ProjectCodes c
INNER JOIN training.ProjectCodesAtBusinessUnit cb ON c.ProjectCodeID = cb.ProjectCodeID
INNER JOIN users.BusinessUnits b ON cb.BusinessUnitID = b.BusinessUnitID;
