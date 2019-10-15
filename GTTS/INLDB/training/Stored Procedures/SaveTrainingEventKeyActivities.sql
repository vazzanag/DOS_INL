CREATE PROCEDURE [training].[SaveTrainingEventKeyActivities]
    @TrainingEventID BIGINT,
    @ModifiedByAppUserID INT,
    @KeyActivities NVARCHAR(MAX)
AS
BEGIN

	SET NOCOUNT ON;

    DELETE FROM training.TrainingEventKeyActivities
     WHERE TrainingEventID = @TrainingEventID
       AND KeyActivityID NOT IN (SELECT json.KeyActivityID FROM OPENJSON(@KeyActivities) WITH (KeyActivityID INT) json);

    INSERT INTO training.TrainingEventKeyActivities
    (TrainingEventID, KeyActivityID, ModifiedByAppUserID)
    SELECT @TrainingEventID, json.KeyActivityID, @ModifiedByAppUserID
      FROM OPENJSON(@KeyActivities) 
           WITH (KeyActivityID INT) JSON
     WHERE NOT EXISTS(SELECT KeyActivityID FROM training.TrainingEventKeyActivities WHERE TrainingEventID = @TrainingEventID and KeyActivityID = json.KeyActivityID);

END
