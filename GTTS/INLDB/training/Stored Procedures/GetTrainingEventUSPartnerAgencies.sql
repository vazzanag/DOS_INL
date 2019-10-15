CREATE PROCEDURE [training].[GetTrainingEventUSPartnerAgencies]
    @TrainingEventID BIGINT
AS
    SELECT TrainingEventID, AgencyID, [Name], Initials, ModifiedByAppUserID, ModifiedDate, ModifiedByUserJSON
	  FROM training.TrainingEventUSPartnerAgenciesView
	 WHERE TrainingEventID = @TrainingEventID;
