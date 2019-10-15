CREATE PROCEDURE [training].[SaveTrainingEventVisaCheckLists]
	@TrainingEventID BIGINT = NULL,
	@VisaCheckListJSON NVARCHAR(MAX),
	@ModifiedByAppUserID BIGINT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
			UPDATE 
				visachecklist
			SET
				visachecklist.HasHostNationCorrespondence = jsonEntries.HasHostNationCorrespondence,
				visachecklist.HasUSGCorrespondence = jsonEntries.HasUSGCorrespondence, 
				visachecklist.IsApplicationComplete = jsonEntries.IsApplicationComplete, 
				visachecklist.HasPassportAndPhotos = jsonEntries.HasPassportAndPhotos, 
				visachecklist.ApplicationSubmittedDate = jsonEntries.ApplicationSubmittedDate, 
				visachecklist.VisaStatusID = vs.VisaStatusID, 
				visachecklist.TrackingNumber = jsonEntries.TrackingNumber,
				visachecklist.Comments = jsonEntries.Comments,
				visachecklist.ModifiedByAppUserID = @ModifiedByAppUserID
			FROM training.TrainingEventVisaCheckLists AS visachecklist 
			INNER JOIN (
			SELECT p.TrackingEventVisaCheckListID, p.PersonID, @TrainingEventID TrainingEventID, p.HasHostNationCorrespondence, p.HasUSGCorrespondence,
				   p.IsApplicationComplete, p.HasPassportAndPhotos, p.ApplicationSubmittedDate, p.VisaStatus, p.TrackingNumber, p.Comments,
				   @ModifiedByAppUserID ModifiedByAppUserID
				FROM OPENJSON(@VisaCheckListJSON) WITH (
					TrackingEventVisaCheckListID INT, PersonID INT, TrainingEventID BIGINT, HasHostNationCorrespondence BIT,	
					HasUSGCorrespondence BIT, IsApplicationComplete BIT, HasPassportAndPhotos BIT, ApplicationSubmittedDate DATETIME, VisaStatus NVARCHAR(100),	
					TrackingNumber NVARCHAR(30),  Comments NVARCHAR(1000), ModifiedByAppUserID INT
				  ) p
			) AS jsonEntries ON visachecklist.PersonID = jsonEntries.PersonID AND visachecklist.TrainingEventID = @TrainingEventID
			LEFT JOIN training.VisaStatuses vs ON jsonEntries.VisaStatus = vs.Code 

		INSERT INTO training.TrainingEventVisaCheckLists (
				PersonID, TrainingEventID, HasHostNationCorrespondence,	HasUSGCorrespondence, IsApplicationComplete, HasPassportAndPhotos, 
				ApplicationSubmittedDate, VisaStatusID, TrackingNumber, Comments,
			    ModifiedByAppUserID
			)
			SELECT p.PersonID, @TrainingEventID TrainingEventID, p.HasHostNationCorrespondence, p.HasUSGCorrespondence, p.IsApplicationComplete, p.HasPassportAndPhotos, p.ApplicationSubmittedDate, 
				   vs.VisaStatusID, p.TrackingNumber, p.Comments, @ModifiedByAppUserID ModifiedByAppUserID
				FROM OPENJSON(@VisaCheckListJSON) WITH (
					TrackingEventVisaCheckListID INT, PersonID INT, TrainingEventID BIGINT, HasHostNationCorrespondence BIT,	
					HasUSGCorrespondence BIT, IsApplicationComplete BIT, HasPassportAndPhotos BIT, ApplicationSubmittedDate DATETIME, VisaStatus NVARCHAR(100),	
					TrackingNumber NVARCHAR(30),  Comments NVARCHAR(1000), ModifiedByAppUserID INT
				  ) p
			LEFT JOIN training.VisaStatuses vs ON p.VisaStatus =  vs.Code
			WHERE p.PersonID NOT IN(
					SELECT PersonID FROM training.TrainingEventVisaCheckLists WHERE PersonID = p.PersonID AND TrainingEventID = @TrainingEventID
				  )
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;