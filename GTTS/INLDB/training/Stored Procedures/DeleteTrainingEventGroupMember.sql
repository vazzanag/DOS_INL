CREATE PROCEDURE training.DeleteTrainingEventGroupMember
		@TrainingEventGroupID BIGINT,
		@PersonID BIGINT
AS
BEGIN

	SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
		DELETE FROM	[training].TrainingEventGroupMembers
		WHERE 
			TrainingEventGroupID = @TrainingEventGroupID AND
			PersonID = @PersonID;
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END