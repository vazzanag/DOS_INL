CREATE PROCEDURE [training].[SaveTrainingEventProjectCodes]
    @TrainingEventID BIGINT,
    @ModifiedByAppUserID INT,
    @ProjectCodes NVARCHAR(MAX)
AS
BEGIN

	SET NOCOUNT ON;

    DELETE FROM [training].[TrainingEventProjectCodes] 
     WHERE TrainingEventID = @TrainingEventID
       AND ProjectCodeID NOT IN (SELECT json.ProjectCodeID FROM OPENJSON(@ProjectCodes) WITH (ProjectCodeID INT) json);

    INSERT INTO [training].[TrainingEventProjectCodes] 
    (TrainingEventID, ProjectCodeID, ModifiedByAppUserID)
    SELECT @TrainingEventID, json.ProjectCodeID, @ModifiedByAppUserID
      FROM OPENJSON(@ProjectCodes) 
           WITH (ProjectCodeID INT) JSON
     WHERE NOT EXISTS(SELECT ProjectCodeID FROM [training].[TrainingEventProjectCodes]  WHERE TrainingEventID = @TrainingEventID and ProjectCodeID = json.ProjectCodeID);
	 
END