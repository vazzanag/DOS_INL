CREATE PROCEDURE [training].[SaveTrainingEventInstructors]
    @TrainingEventID BIGINT,
    @ModifiedByAppUserID INT,
    @PersonsJSON NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        -- UPDATE EXISTING RECORDS
		UPDATE instructors SET
			   instructors.PersonsVettingID = jsonEntries.PersonsVettingID,
			   instructors.IsTraveling = ISNULL(jsonEntries.IsTraveling, instructors.IsTraveling), 
			   instructors.DepartureCityID = jsonEntries.DepartureCityID, 
			   instructors.DepartureDate = jsonEntries.DepartureDate, 
			   instructors.ReturnDate = jsonEntries.ReturnDate, 
			   instructors.VisaStatusID = jsonEntries.VisaStatusID, 
			   instructors.PaperworkStatusID = jsonEntries.PaperworkStatusID,
			   instructors.TravelDocumentStatusID = jsonEntries.TravelDocumentStatusID,
			   instructors.RemovedFromEvent = ISNULL(jsonEntries.RemovedFromEvent, instructors.RemovedFromEvent), 
			   instructors.ModifiedByAppUserID = @ModifiedByAppUserID
		  FROM training.TrainingEventParticipants AS instructors 
    INNER JOIN (
			        SELECT p.PersonID, @TrainingEventID TrainingEventID, p.PersonsVettingID,
				           p.IsTraveling, p.DepartureCityID, p.DepartureDate, 
				           p.ReturnDate, p.VisaStatusID, p.PaperworkStatusID, p.TravelDocumentStatusID,
				           0 RemovedFromEvent, @ModifiedByAppUserID ModifiedByAppUserID
			          FROM OPENJSON(@PersonsJSON) WITH 
				           (
					        PersonID INT, TrainingEventID BIGINT, PersonsVettingID BIGINT, IsTraveling BIT,	
					        DepartureCityID INT, DepartureDate DATETIME, ReturnDate DATETIME, VisaStatusID SMALLINT,	
					        PaperworkStatusID SMALLINT, 
					        TravelDocumentStatusID SMALLINT, RemovedFromEvent BIT, RemovalReasonID SMALLINT, 
					        RemovalCauseID SMALLINT, DateCanceled DATETIME, Comments NVARCHAR(4000), ModifiedByAppUserID INT
				           ) p
		       ) AS jsonEntries ON instructors.PersonID = jsonEntries.PersonID 
                               AND instructors.TrainingEventID = @TrainingEventID
							   AND TrainingEventParticipantTypeID = 2;


        -- INSERT
		INSERT INTO training.TrainingEventParticipants
			(
				TrainingEventParticipantTypeID, PersonID, TrainingEventID, PersonsVettingID,IsTraveling, DepartureCityID, DepartureDate, 
				ReturnDate, VisaStatusID, PaperworkStatusID, TravelDocumentStatusID,
				RemovedFromEvent, ModifiedByAppUserID
			)
                SELECT 2, PersonID, @TrainingEventID, PersonsVettingID, IsTraveling, DepartureCityID, DepartureDate, 
				       ReturnDate, VisaStatusID, PaperworkStatusID, TravelDocumentStatusID,
				       0 AS RemovedFromEvent, @ModifiedByAppUserID AS ModifiedByAppUserID
                  FROM (
			            SELECT p.PersonID, i.TrainingEventID, p.PersonsVettingID, COALESCE(p.IsTraveling, i.IsTraveling, 0) IsTraveling, 
                               ISNULL(p.DepartureCityID, i.DepartureCityID) DepartureCityID, p.DepartureDate, 
				               p.ReturnDate, p.VisaStatusID, p.PaperworkStatusID, p.TravelDocumentStatusID,
				               0 RemovedFromEvent, @ModifiedByAppUserID ModifiedByAppUserID
			              FROM OPENJSON(@PersonsJSON) WITH 
				               (
					            PersonID INT, TrainingEventID BIGINT, PersonsVettingID BIGINT, IsTraveling BIT,	
					            DepartureCityID INT, DepartureDate DATETIME, ReturnDate DATETIME, VisaStatusID SMALLINT,	
					            PaperworkStatusID SMALLINT, TravelDocumentStatusID SMALLINT, RemovedFromEvent BIT, RemovalReasonID SMALLINT, 
					            RemovalCauseID SMALLINT, DateCanceled DATETIME, Comments NVARCHAR(4000), ModifiedByAppUserID INT
				               ) p
                    INNER JOIN training.TrainingEventParticipants i ON p.PersonID = i.PersonID 
																AND TrainingEventParticipantTypeID = 2
                                                                  AND i.TrainingEventParticipantID = (SELECT MAX(TrainingEventParticipantID) 
                                                                                                       FROM training.TrainingEventParticipants
                                                                                                      WHERE PersonID = p.PersonID
																									  AND TrainingEventParticipantTypeID = 2)
			            WHERE p.PersonID NOT IN
				              (
					            SELECT PersonID FROM training.TrainingEventParticipants WHERE PersonID = p.PersonID AND TrainingEventID = @TrainingEventID AND TrainingEventParticipantTypeID = 2
				              )
                       ) z
              GROUP BY PersonID, PersonsVettingID, IsTraveling, DepartureCityID, DepartureDate, 
				       ReturnDate, VisaStatusID, PaperworkStatusID, TravelDocumentStatusID
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;