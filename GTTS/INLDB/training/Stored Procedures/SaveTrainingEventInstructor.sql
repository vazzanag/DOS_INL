CREATE PROCEDURE [training].[SaveTrainingEventInstructor]
	@PersonID BIGINT,
	@TrainingEventID BIGINT,
	@IsTraveling BIT,	
	@PersonsVettingID BIGINT = null,
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

		BEGIN TRANSACTION
	
		IF NOT EXISTS(SELECT * FROM training.TrainingEventParticipants WHERE PersonID = @PersonID AND TrainingEventID = @TrainingEventID AND TrainingEventParticipantTypeID = 2)
			BEGIN

				--INSERT NEW RECORD
				INSERT INTO training.TrainingEventParticipants
				(
					TrainingEventParticipantTypeId, PersonID, TrainingEventID, PersonsVettingID, IsTraveling, OtherVetting, PassedOtherVetting, OtherVettingDate, OtherVettingDescription,
					DepartureCityID, DepartureDate, ReturnDate,  VisaStatusID, PaperworkStatusID, HasLocalGovTrust, PassedLocalGovTrust, LocalGovTrustCertDate,
					TravelDocumentStatusID, RemovedFromEvent, RemovalReasonID, RemovalCauseID, DateCanceled, Comments, ModifiedByAppUserID
				)
				VALUES
				(
					2, @PersonID, @TrainingEventID, @PersonsVettingID, @IsTraveling, @OtherVetting, @PassedOtherVetting, @OtherVettingDate, @OtherVettingDescription,
					@DepartureCityID, @DepartureDate, @ReturnDate,  @VisaStatusID, @PaperworkStatusID, @HasLocalGovTrust, @PassedLocalGovTrust,  @LocalGovTrustCertDate,
					@TravelDocumentStatusID, @RemovedFromEvent, @RemovalReasonID, @RemovalCauseID, @DateCanceled, @Comments, @ModifiedByAppUserID
				)

		END

		ELSE
			BEGIN
				--UPDATE EXISTING RECORD
				UPDATE training.TrainingEventParticipants SET
						PersonsVettingID =			@PersonsVettingID,
						IsTraveling =				@IsTraveling,
						DepartureCityID =			@DepartureCityID,
						DepartureDate =				@DepartureDate,
						ReturnDate =				@ReturnDate,
                        HasLocalGovTrust =             @HasLocalGovTrust,
                        PassedLocalGovTrust =       @PassedLocalGovTrust,
                        LocalGovTrustCertDate =     @LocalGovTrustCertDate,
                        OtherVetting =              @OtherVetting,
                        PassedOtherVetting =        @PassedOtherVetting,
                        OtherVettingDate =          @OtherVettingDate,
                        OtherVettingDescription =   @OtherVettingDescription,
						VisaStatusID =				@VisaStatusID, 
						PaperworkStatusID =			@PaperworkStatusID, 
						TravelDocumentStatusID =	@TravelDocumentStatusID, 
						RemovedFromEvent =			@RemovedFromEvent, 
						RemovalReasonID =			@RemovalReasonID, 
						RemovalCauseID =			@RemovalCauseID,
						DateCanceled =				@DateCanceled, 
						Comments =					@Comments, 
						ModifiedByAppUserID =		@ModifiedByAppUserID
				WHERE	PersonID = @PersonID AND TrainingEventID = @TrainingEventID  
			END

		COMMIT;

		SELECT PersonID, TrainingEventID 
		  FROM training.TrainingEventParticipants
		 WHERE PersonID = @PersonID  AND TrainingEventID = @TrainingEventID
		 AND TrainingEventParticipantTypeID = 2
		
		END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
