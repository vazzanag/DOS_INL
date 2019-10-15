CREATE PROCEDURE [vetting].[SaveCourtesyBatch]
	@CourtesyBatchID BIGINT,
	@VettingBatchID BIGINT,
	@VettingTypeID SMALLINT,  
	@VettingBatchNotes NVARCHAR(500),	
	@AssignedToAppUserID INT,	
	@ResultsSubmittedDate DATETIME,
	@ResultsSubmittedByAppUserID INT,
	@ModifiedByAppUserID INT
AS
BEGIN

	BEGIN TRANSACTION

	BEGIN TRY

		IF (ISNULL(@CourtesyBatchID, 0) = 0)
		BEGIN

			INSERT INTO vetting.CourtesyBatches
				(VettingBatchID, VettingTypeID, VettingBatchNotes, AssignedToAppUserID,	
				 ResultsSubmittedDate, ResultsSubmittedByAppUserID, ModifiedByAppUserID)
			VALUES
				(@VettingBatchID, @VettingTypeID, @VettingBatchNotes, @AssignedToAppUserID,	
				 @ResultsSubmittedDate, @ResultsSubmittedByAppUserID, @ModifiedByAppUserID)
		
			SELECT @CourtesyBatchID = SCOPE_IDENTITY();

		END
		ELSE
		BEGIN

			UPDATE vetting.CourtesyBatches
			SET
				VettingBatchID = @VettingBatchID,
				VettingTypeID = @VettingTypeID,  
				VettingBatchNotes = @VettingBatchNotes,	
				AssignedToAppUserID = @AssignedToAppUserID,	
				ResultsSubmittedDate = @ResultsSubmittedDate,
				ResultsSubmittedByAppUserID = @ResultsSubmittedByAppUserID,
				ModifiedByAppUserID = @ModifiedByAppUserID
			WHERE CourtesyBatchID = @CourtesyBatchID;

		END

		COMMIT;

		SELECT @CourtesyBatchID AS CourtesyBatchID;

	END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH

END