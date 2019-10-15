CREATE PROCEDURE training.SaveTrainingEventGroup
		@TrainingEventGroupID BIGINT = NULL,
		@TrainingEventID BIGINT,
		@GroupName NVARCHAR(100),
		@ModifiedByAppUserID BIGINT
AS
BEGIN

	SET NOCOUNT ON;

    DECLARE @Identity BIGINT
    BEGIN TRY
        BEGIN TRANSACTION

        -- DETERMINE IF INSERT OR UPDATE BASED ON PASSED @TrainingEventID VALUE
        IF (@TrainingEventGroupID IS NULL) 
            BEGIN
                PRINT 'INSERTING NEW RECORD'

                -- INSERT NEW RECORD
                INSERT INTO training.TrainingEventGroups
                (
					TrainingEventID, GroupName, ModifiedByAppUserID
				)
                VALUES 
                (
					@TrainingEventID, @GroupName, @ModifiedByAppUserID
				)

                SET @Identity = SCOPE_IDENTITY();

            END
        ELSE
            BEGIN
                PRINT 'UPDATING EXISTING RECORD'

                IF NOT EXISTS(SELECT * FROM training.TrainingEventGroups WHERE TrainingEventGroupID = @TrainingEventGroupID)
                    THROW 50000,  'The requested training event group to be updated does not exist.',  1

                -- UPDATE RECORD
                UPDATE training.TrainingEventGroups SET
                        TrainingEventID =                @TrainingEventID, 
                        GroupName =						 @GroupName, 
                        ModifiedByAppUserID =            @ModifiedByAppUserID
                WHERE TrainingEventGroupID = @TrainingEventGroupID

                SET @Identity = @TrainingEventGroupID
            END
		SELECT 
			TrainingEventGroupID,
			[TrainingEventID],
			TrainingEventName,
			[GroupName],
			[ModifiedByAppUserID]
		FROM [training].[TrainingEventGroupsView]
		WHERE TrainingEventGroupID = @Identity;
        -- NO ERRORS,  COMMIT
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END