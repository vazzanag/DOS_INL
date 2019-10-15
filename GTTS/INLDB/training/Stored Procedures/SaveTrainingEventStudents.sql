CREATE PROCEDURE [training].[SaveTrainingEventStudents]
    @TrainingEventID BIGINT,
    @ModifiedByAppUserID INT,
    @PersonsJSON NVARCHAR(MAX)
AS
BEGIN

    DECLARE @IsJSONValid BIT

    -- CHECK FOR VALID JSON
    SELECT @IsJSONValid = ISJSON(@PersonsJSON);
    IF (@IsJSONValid = 0)
        THROW 50000,  'Format of JSON is invalid',  1

    BEGIN TRY
        BEGIN TRANSACTION

        -- UPDATE EXISTING RECORDS
        UPDATE training.TrainingEventParticipants SET
						    IsVIP =						ISNULL(p.IsVIP, s.IsVIP),
						    IsParticipant =				ISNULL(p.IsParticipant, s.IsParticipant),
						    IsTraveling =				ISNULL(p.IsTraveling, s.IsTraveling),
						    DepartureCityID =			p.DepartureCityID,
						    DepartureDate =				p.DepartureDate,
						    ReturnDate =				p.ReturnDate,
						    VisaStatusID =				p.VisaStatusID, 
                            HasLocalGovTrust =             ISNULL(p.HasLocalGovTrust, s.HasLocalGovTrust),
						    PassedLocalGovTrust =		ISNULL(p.PassedLocalGovTrust, s.PassedLocalGovTrust),
						    LocalGovTrustCertDate =		p.LocalGovTrustCertDate, 
                            OtherVetting =              ISNULL(p.OtherVetting, s.OtherVetting),
						    PassedOtherVetting =		ISNULL(p.PassedOtherVetting, s.PassedOtherVetting),
						    OtherVettingDescription =	p.OtherVettingDescription, 
						    OtherVettingDate =			p.OtherVettingDate,
						    PaperworkStatusID =			p.PaperworkStatusID, 
						    TravelDocumentStatusID =	p.TravelDocumentStatusID, 
						    RemovedFromEvent =			ISNULL(p.RemovedFromEvent, s.RemovedFromEvent), 
						    RemovalReasonID =			p.RemovalReasonID, 
						    RemovalCauseID =			p.RemovalCauseID,
						    DateCanceled =				p.DateCanceled, 
						    Comments =					p.Comments, 
						    ModifiedByAppUserID =		p.ModifiedByAppUserID
          FROM training.TrainingEventParticipants s
    INNER JOIN OPENJSON(@PersonsJSON) WITH 
                                        (
                                            PersonID INT, TrainingEventID BIGINT, IsVIP BIT, IsParticipant BIT,IsTraveling BIT,	
	                                        DepartureCityID INT, DepartureDate DATETIME, ReturnDate DATETIME, VisaStatusID SMALLINT,	
	                                        HasLocalGovTrust BIT, PassedLocalGovTrust BIT, LocalGovTrustCertDate DATETIME, OtherVetting BIT, PassedOtherVetting BIT, 
                                            OtherVettingDescription NVARCHAR(150), OtherVettingDate DATETIME, PaperworkStatusID SMALLINT, 
                                            TravelDocumentStatusID SMALLINT, RemovedFromEvent BIT, RemovalReasonID SMALLINT, 
                                            RemovalCauseID SMALLINT, DateCanceled DATETIME, Comments NVARCHAR(4000), ModifiedByAppUserID INT
                                        ) p ON s.PersonID = p.PersonID AND s.TrainingEventID = p.TrainingEventID 
         WHERE s.PersonID = p.PersonID AND s.TrainingEventID = @TrainingEventID AND s.TrainingEventID = p.TrainingEventID
		 AND TrainingEventParticipantTypeID != 2


        -- INSERT
        INSERT INTO training.TrainingEventParticipants
        (
            PersonID, TrainingEventID, IsVIP, IsParticipant, IsTraveling, DepartureCityID, DepartureDate, 
            ReturnDate, HasLocalGovTrust, PassedLocalGovTrust, LocalGovTrustCertDate, OtherVetting, PassedOtherVetting,
            OtherVettingDescription, OtherVettingDate, VisaStatusID, PaperworkStatusID, TravelDocumentStatusID,
            RemovedFromEvent, ModifiedByAppUserID
        )
            SELECT PersonID, @TrainingEventID, IsVIP, IsParticipant, IsTraveling, DepartureCityID, DepartureDate, 
			       ReturnDate, HasLocalGovTrust, PassedLocalGovTrust, LocalGovTrustCertDate, OtherVetting, PassedOtherVetting,
			       OtherVettingDescription, OtherVettingDate, VisaStatusID, PaperworkStatusID, TravelDocumentStatusID,
			       0 RemovedFromEvent, @ModifiedByAppUserID ModifiedByAppUserID 
              FROM (
                    SELECT p.PersonID, s.TrainingEventID, COALESCE(p.IsVIP, s.IsVIP, 0) IsVIP, COALESCE(p.IsParticipant, s.IsParticipant, 1) IsParticipant, 
			               COALESCE(p.IsTraveling, s.IsTraveling, 0) IsTraveling, ISNULL(p.DepartureCityID, s.DepartureCityID) DepartureCityID, p.DepartureDate, 
			               p.ReturnDate, COALESCE(p.HasLocalGovTrust, s.HasLocalGovTrust, 0) HasLocalGovTrust, COALESCE(p.PassedLocalGovTrust, s.PassedLocalGovTrust, 0) PassedLocalGovTrust, 
                           p.LocalGovTrustCertDate, COALESCE(p.OtherVetting, s.OtherVetting, 0) OtherVetting, COALESCE(p.PassedOtherVetting, s.PassedOtherVetting, 0) PassedOtherVetting,
			               p.OtherVettingDescription, p.OtherVettingDate, p.VisaStatusID, p.PaperworkStatusID, p.TravelDocumentStatusID
                      FROM OPENJSON(@PersonsJSON) WITH 
                                                    (
                                                        PersonID INT, TrainingEventID BIGINT, IsVIP BIT, IsParticipant BIT,IsTraveling BIT,	
											            DepartureCityID INT, DepartureDate DATETIME, ReturnDate DATETIME, VisaStatusID SMALLINT,	
											            HasLocalGovTrust BIT, PassedLocalGovTrust BIT, LocalGovTrustCertDate DATETIME, OtherVetting BIT, PassedOtherVetting BIT, 
                                                        OtherVettingDescription NVARCHAR(150), OtherVettingDate DATETIME, PaperworkStatusID SMALLINT, 
                                                        TravelDocumentStatusID SMALLINT, RemovedFromEvent BIT, RemovalReasonID SMALLINT, 
                                                        RemovalCauseID SMALLINT, DateCanceled DATETIME, Comments NVARCHAR(4000), ModifiedByAppUserID INT
                                                    ) p 
                 LEFT JOIN training.TrainingEventParticipants s ON p.PersonID = s.PersonID 
															AND TrainingEventParticipantTypeID != 2 -- 2 = Instructor
															AND s.TrainingEventParticipantID = (SELECT MAX(TrainingEventParticipantID) 
                                                                                             FROM training.TrainingEventParticipants
                                                                                            WHERE PersonID = p.PersonID AND TrainingEventParticipantTypeID != 2) -- 2 = Instructor
		             WHERE NOT EXISTS(SELECT PersonID 
							            FROM training.TrainingEventParticipants 
						               WHERE TrainingEventID = @TrainingEventID AND PersonID = p.PersonID)
                   ) z
            GROUP BY PersonID,IsVIP, IsParticipant, IsTraveling, DepartureCityID, DepartureDate, ReturnDate, HasLocalGovTrust, PassedLocalGovTrust, LocalGovTrustCertDate,
                     OtherVetting, PassedOtherVetting, OtherVettingDescription, OtherVettingDate, VisaStatusID, PaperworkStatusID, TravelDocumentStatusID;

        -- NO ERRORS,  COMMIT
        COMMIT;

        -- RETURN RESULT
        SELECT s.PersonID 
          FROM training.TrainingEventParticipants s
    INNER JOIN OPENJSON(@PersonsJSON) WITH (PersonID INT) p ON s.PersonID = p.PersonID
         WHERE TrainingEventID = @TrainingEventID
		 AND TrainingEventParticipantTypeID != 2 -- 2 = Instructor

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;