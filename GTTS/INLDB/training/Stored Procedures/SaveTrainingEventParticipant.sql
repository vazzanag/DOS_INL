   CREATE PROCEDURE [training].[SaveTrainingEventParticipant]
    @ParticipantID BIGINT,
	@PersonID BIGINT,
    @ParticipantType NVARCHAR(15),
	@TrainingEventID BIGINT,
	@IsVIP BIT,
	@IsParticipant BIT,
	@IsTraveling BIT,	
	@DepartureCityID INT = null,
	@DepartureDate DATETIME = null,
	@ReturnDate DATETIME = null,
	@VisaStatusID SMALLINT = null,	
    @HasLocalGovTrust BIT = 0,
	@PassedLocalGovTrust BIT = null,
	@LocalGovTrustCertDate DATETIME = null,
    @OtherVetting BIT = 0,
	@PassedOtherVetting BIT = null,
	@OtherVettingDescription NVARCHAR(150) = null,
	@OtherVettingDate DATETIME = null,
	@PaperworkStatusID SMALLINT = null,			
	@TravelDocumentStatusID SMALLINT = null ,	
	@RemovedFromEvent BIT,
	@RemovalReasonID SMALLINT = null,		
	@RemovalCauseID SMALLINT = null,	
	@DateCanceled DATETIME = null,
	@Comments NVARCHAR(4000) = null,
	@ModifiedByAppUserID INT
AS
BEGIN
	BEGIN TRY
        DECLARE @Identity BIGINT;
		DECLARE @TrainingEventParticipantTypeID INT = 1;

		BEGIN TRANSACTION
		IF (UPPER(@ParticipantType) = 'STUDENT')
			SET @TrainingEventParticipantTypeID = 1;
		IF (UPPER(@ParticipantType) = 'INSTRUCTOR')
			SET @TrainingEventParticipantTypeID = 2;
		IF (UPPER(@ParticipantType) = 'ALTERNATE')
			SET @TrainingEventParticipantTypeID = 3;

			IF NOT EXISTS(SELECT * FROM [training].[TrainingEventParticipants] WHERE PersonID = @PersonID AND TrainingEventID = @TrainingEventID)
			    BEGIN
				    --INSERT NEW RECORD
				    INSERT INTO [training].[TrainingEventParticipants]
				    (
					    TrainingEventParticipantTypeID, PersonID, TrainingEventID, IsTraveling, 
					    DepartureCityID, DepartureDate, ReturnDate,  VisaStatusID, PaperworkStatusID, HasLocalGovTrust,
					    PassedLocalGovTrust, LocalGovTrustCertDate, OtherVetting, PassedOtherVetting, OtherVettingDescription, OtherVettingDate, 
					    TravelDocumentStatusID, RemovedFromEvent, RemovalReasonID, RemovalCauseID, DateCanceled, Comments, ModifiedByAppUserID
				    )
				    VALUES
				    (
					    @TrainingEventParticipantTypeID, @PersonID, @TrainingEventID, @IsTraveling, 
					    @DepartureCityID, @DepartureDate, @ReturnDate, @VisaStatusID, @PaperworkStatusID, @HasLocalGovTrust,
					    @PassedLocalGovTrust, @LocalGovTrustCertDate, @OtherVetting, @PassedOtherVetting, @OtherVettingDescription, @OtherVettingDate,
					    @TravelDocumentStatusID, @RemovedFromEvent, @RemovalReasonID, @RemovalCauseID, @DateCanceled, @Comments, @ModifiedByAppUserID
				    );

                    SET @Identity = SCOPE_IDENTITY();
		        END
		    ELSE
			    BEGIN
				    --UPDATE EXISTING RECORD
				    UPDATE [training].[TrainingEventParticipants] SET
							TrainingEventParticipantTypeID = @TrainingEventParticipantTypeID,
						    IsTraveling =				@IsTraveling,
						    DepartureCityID =			@DepartureCityID,
						    DepartureDate =				@DepartureDate,
						    ReturnDate =				@ReturnDate,
						    VisaStatusID =				@VisaStatusID, 
                            HasLocalGovTrust =             @HasLocalGovTrust,
						    PassedLocalGovTrust =	    @PassedLocalGovTrust,
						    LocalGovTrustCertDate =		@LocalGovTrustCertDate, 
                            OtherVetting =              @OtherVetting,
						    PassedOtherVetting =		@PassedOtherVetting,
						    OtherVettingDescription =	@OtherVettingDescription, 
						    OtherVettingDate =			@OtherVettingDate,
						    PaperworkStatusID =			@PaperworkStatusID, 
						    TravelDocumentStatusID =	@TravelDocumentStatusID, 
						    RemovedFromEvent =			@RemovedFromEvent, 
						    RemovalReasonID =			@RemovalReasonID, 
						    RemovalCauseID =			@RemovalCauseID,
						    DateCanceled =				@DateCanceled, 
						    Comments =					@Comments, 
						    ModifiedByAppUserID =		@ModifiedByAppUserID
				    WHERE	TrainingEventParticipantID = @ParticipantID;

                    SET @Identity = @ParticipantID;
			    END
       
		COMMIT;

		SELECT PersonID, TrainingEventID, PersonsUnitLibraryInfoID 
		  FROM training.TrainingEventParticipantsView
		 WHERE PersonID = @PersonID 
           AND TrainingEventID = @TrainingEventID;
		
		END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
