CREATE PROCEDURE [training].[GetTrainingEventParticiantsPersonIdAsJSON]
    @TrainingEventID BIGINT
AS
BEGIN

    SELECT (SELECT PersonID 
              FROM training.TrainingEventParticipantsView
			 WHERE TrainingEventID = @TrainingEventID FOR JSON PATH, INCLUDE_NULL_VALUES
           ) PersonJSON

END
