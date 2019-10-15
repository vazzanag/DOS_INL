CREATE PROCEDURE training.SaveTrainingEventGroupMember
		@TrainingEventGroupID BIGINT = NULL,
		@PersonID BIGINT,
		@MemberTypeID BIGINT,
		@ModifiedByAppUserID BIGINT
AS
BEGIN

	SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION

        -- DETERMINE IF INSERT OR UPDATE BASED ON PASSED @TrainingEventID VALUE
        IF NOT EXISTS(SELECT * FROM training.TrainingEventGroupMembers WHERE TrainingEventGroupID = @TrainingEventGroupID AND PersonID = @PersonID)
            BEGIN
                PRINT 'INSERTING NEW RECORD'

                -- INSERT NEW RECORD
                INSERT INTO training.TrainingEventGroupMembers
                (
					TrainingEventGroupID, PersonID, GroupMemberTypeID, ModifiedByAppUserID
				)
                VALUES 
                (
					@TrainingEventGroupID, @PersonID, @MemberTypeID, @ModifiedByAppUserID
				)
            END
        ELSE
            BEGIN
                PRINT 'UPDATING EXISTING RECORD'

                -- UPDATE RECORD
                UPDATE training.TrainingEventGroupMembers SET
                        GroupMemberTypeID =   @MemberTypeID, 
                        ModifiedByAppUserID =            @ModifiedByAppUserID
                WHERE 
					TrainingEventGroupID = @TrainingEventGroupID AND
					PersonID = @PersonID;
            END

		SELECT 
			TrainingEventGroupID,
			PersonID
		FROM [training].[TrainingEventGroupMembersView]
		WHERE
			TrainingEventGroupID = @TrainingEventGroupID AND
			PersonID = @PersonID;
        -- NO ERRORS,  COMMIT
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END