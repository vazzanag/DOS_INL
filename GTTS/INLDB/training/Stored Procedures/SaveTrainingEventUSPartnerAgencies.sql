CREATE PROCEDURE [training].[SaveTrainingEventUSPartnerAgencies]
    @TrainingEventID BIGINT,
    @ModifiedByAppUserID INT,
    @USPartnerAgencies NVARCHAR(MAX)
AS
BEGIN

	SET NOCOUNT ON;

    DELETE FROM [training].[TrainingEventUSPartnerAgencies]
     WHERE TrainingEventID = @TrainingEventID
       AND AgencyID NOT IN (SELECT json.AgencyID FROM OPENJSON(@USPartnerAgencies) WITH (AgencyID INT) json);

    INSERT INTO [training].[TrainingEventUSPartnerAgencies]
    (TrainingEventID, AgencyID, ModifiedByAppUserID)
    SELECT @TrainingEventID, json.AgencyID, @ModifiedByAppUserID
      FROM OPENJSON(@USPartnerAgencies) 
           WITH (AgencyID INT) JSON
     WHERE NOT EXISTS(SELECT AgencyID FROM [training].[TrainingEventUSPartnerAgencies] WHERE TrainingEventID = @TrainingEventID and AgencyID = json.AgencyID);
	 
END