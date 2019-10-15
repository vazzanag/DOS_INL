CREATE PROCEDURE [training].[GetTrainingEventTypesAtBusinessUnit]
    @BusinessUnitID INT
AS
SELECT TrainingEventTypeID, TrainingEventTypeName, BusinessUnitID, Acronym, BusinessUnitName,
       BusinessUnitActive, TrainingEventTypeBusinessUnitActive
  FROM [training].[TrainingEventTypesAtBusinessUnitView]
 WHERE BusinessUnitID = @BusinessUnitID;
