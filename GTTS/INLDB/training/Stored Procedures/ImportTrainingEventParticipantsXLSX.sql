CREATE PROCEDURE training.ImportTrainingEventParticipantsXLSX
	@TrainingEventID BIGINT,
	@ModifiedByAppUserID INT
AS
BEGIN

	SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

		 UPDATE [training].[ParticipantsXLSX]
		    SET LoadStatus = 'Imported',
			    ModifiedByAppUserID = @ModifiedByAppUserID
		  WHERE TrainingEventID = @TrainingEventID

		COMMIT;

		SELECT @TrainingEventID

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END

