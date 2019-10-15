CREATE VIEW [training].[TrainingEventTypesAtBusinessUnitView]
AS 
    SELECT t.TrainingEventTypeID, t.[Name] AS TrainingEventTypeName, tb.BusinessUnitID, b.Acronym, b.BusinessUnitName,
           b.IsActive AS BusinessUnitActive, tb.IsActive AS TrainingEventTypeBusinessUnitActive
	  FROM training.TrainingEventTypes t
INNER JOIN training.trainingEventTypesAtBusinessUnit tb ON t.TrainingEventTypeID = tb.TrainingEventTypeID
INNER JOIN users.BusinessUnits b ON tb.BusinessUnitID = b.BusinessUnitID;
