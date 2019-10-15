CREATE PROCEDURE [training].[SaveTrainingEventAuthorizingDocuments]
    @TrainingEventID BIGINT,
    @ModifiedByAppUserID INT,
    @IIAs NVARCHAR(MAX)
AS
BEGIN

	SET NOCOUNT ON;

    DELETE FROM training.TrainingEventAuthorizingDocuments
     WHERE TrainingEventID = @TrainingEventID
       AND InterAgencyAgreementID NOT IN (SELECT json.IAAID FROM OPENJSON(@IIAs) WITH (IAAID INT) json);


    INSERT INTO training.TrainingEventAuthorizingDocuments
    (TrainingEventID, InterAgencyAgreementID, ModifiedByAppUserID)
    SELECT @TrainingEventID, json.IAAID, @ModifiedByAppUserID
      FROM OPENJSON(@IIAs) 
           WITH (IAAID INT) JSON
     WHERE NOT EXISTS(SELECT IAAID FROM [training].[TrainingEventAuthorizingDocuments]  WHERE TrainingEventID = @TrainingEventID and IAAID = json.IAAID);
	 
END