CREATE PROCEDURE [training].[SaveTrainingEventParticipantAttachment]
    @TrainingEventParticipantAttachmentID BIGINT = NULL,
    @TrainingEventID BIGINT,
	@PersonID BIGINT,
    @ParticipantType NVARCHAR(20),
    @FileID BIGINT,
    @FileVersion SMALLINT,
    @TrainingEventParticipantAttachmentTypeID INT,
    @Description NVARCHAR(500),
    @IsDeleted BIT = 0,
    @ModifiedByAppUserID INT
AS
BEGIN
    DECLARE @FileIdentity INT,
            @AttachmentIdentity INT

    -- VERIFY THE ASSOCIATED files.file RECORD EXISTS
    IF (@FileID IS NULL OR NOT EXISTS(SELECT * FROM files.Files WHERE FileID = @FileID))
        THROW 50000,  'Associated File does not exist',  1;

    -- VERIFY THE ASSOCIATED training.TrainingEvents RECORD EXISTS
    IF (@TrainingEventID IS NULL OR NOT EXISTS(SELECT * FROM training.TrainingEvents WHERE TrainingEventID = @TrainingEventID))
        THROW 50000,  'Associated Training Event does not exist.',  1;

	-- VERIFY THE ASSOCIATED persons.Persons RECORD EXISTS
    IF (@PersonID IS NULL OR NOT EXISTS(SELECT * FROM persons.Persons WHERE PersonID = @PersonID))
        THROW 50000,  'Associated Person does not exist.',  1;

	BEGIN TRANSACTION
    BEGIN TRY
        IF (UPPER(@ParticipantType) = 'STUDENT')
        BEGIN
            IF (@TrainingEventParticipantAttachmentTypeID IS NULL OR @TrainingEventParticipantAttachmentTypeID <= 0)
		    BEGIN
			    SELECT @TrainingEventParticipantAttachmentTypeID = TrainingEventStudentAttachmentTypeID
			    FROM training.TrainingEventStudentAttachmentTypes WHERE [Name] = 'Other';

			    IF (@TrainingEventParticipantAttachmentTypeID IS NULL)
				    SET @TrainingEventParticipantAttachmentTypeID = 1;
		    END

            IF (@TrainingEventParticipantAttachmentID IS NULL OR @TrainingEventParticipantAttachmentID <= 0) 
            BEGIN
                -- INSERT NEW training.TrainingEventStudentAttachment RECORD
                INSERT INTO training.TrainingEventStudentAttachments
				    (TrainingEventID, PersonID, FileID, FileVersion, TrainingEventStudentAttachmentTypeID, [Description], IsDeleted, ModifiedByAppUserID)
                VALUES
				    (@TrainingEventID, @PersonID, @FileID, @FileVersion, @TrainingEventParticipantAttachmentTypeID, @Description, @IsDeleted, @ModifiedByAppUserID);

                SET @AttachmentIdentity = SCOPE_IDENTITY();
            END
            ELSE
            BEGIN
                IF (NOT EXISTS(SELECT * FROM training.TrainingEventStudentAttachments WHERE TrainingEventStudentAttachmentID = @TrainingEventParticipantAttachmentID))
                    THROW 50000,  'The requested training event student attachment to be updated does not exist.',  1;

                -- UPDATE EXISTING training.TrainingEventStudentAttachment RECORD
                UPDATE training.TrainingEventStudentAttachments SET
                        TrainingEventStudentAttachmentTypeID =  @TrainingEventParticipantAttachmentTypeID,
                        [Description] =                  @Description,
                        IsDeleted =                      @IsDeleted,
                        FileVersion =                    @FileVersion,
                        ModifiedByAppUserID =            @ModifiedByAppUserID,
                        ModifiedDate =                   GETUTCDATE()
                    WHERE TrainingEventStudentAttachmentID = @TrainingEventParticipantAttachmentID;

                SET @AttachmentIdentity = @TrainingEventParticipantAttachmentID;
            END

            -- NO ERRORS,  COMMIT
            COMMIT;

            -- RETURN the Identity
            SELECT @AttachmentIdentity;

        END
        ELSE IF (UPPER(@ParticipantType) = 'INSTRUCTOR')
        BEGIN

            IF (@TrainingEventParticipantAttachmentTypeID IS NULL OR @TrainingEventParticipantAttachmentTypeID <= 0)
		    BEGIN
			    SELECT @TrainingEventParticipantAttachmentTypeID = TrainingEventInstructorAttachmentTypeID
			    FROM training.TrainingEventInstructorAttachmentTypes WHERE [Name] = 'Other';

			    IF (@TrainingEventParticipantAttachmentTypeID IS NULL)
				    SET @TrainingEventParticipantAttachmentTypeID = 1;
		    END

            IF (@TrainingEventParticipantAttachmentID IS NULL OR @TrainingEventParticipantAttachmentID <= 0) 
            BEGIN
                -- INSERT NEW training.TrainingEventInstructorAttachments RECORD
                INSERT INTO training.TrainingEventInstructorAttachments
				    (TrainingEventID, PersonID, FileID, FileVersion, TrainingEventInstructorAttachmentTypeID, [Description], IsDeleted, ModifiedByAppUserID)
                VALUES
				    (@TrainingEventID, @PersonID, @FileID, @FileVersion, @TrainingEventParticipantAttachmentTypeID, @Description, @IsDeleted, @ModifiedByAppUserID);

                SET @AttachmentIdentity = SCOPE_IDENTITY();
            END
            ELSE
            BEGIN
                IF (NOT EXISTS(SELECT * FROM training.TrainingEventInstructorAttachments WHERE TrainingEventInstructorAttachmentID = @TrainingEventParticipantAttachmentID))
                    THROW 50000,  'The requested training event student attachment to be updated does not exist.',  1;

                -- UPDATE EXISTING training.TrainingEventInstructorAttachments RECORD
                UPDATE training.TrainingEventInstructorAttachments SET
                        TrainingEventInstructorAttachmentTypeID =  @TrainingEventParticipantAttachmentTypeID,
                        [Description] =                  @Description,
                        IsDeleted =                      @IsDeleted,
                        FileVersion =                    @FileVersion,
                        ModifiedByAppUserID =            @ModifiedByAppUserID,
                        ModifiedDate =                   GETUTCDATE()
                    WHERE TrainingEventInstructorAttachmentID = @TrainingEventParticipantAttachmentID;

                SET @AttachmentIdentity = @TrainingEventParticipantAttachmentID;
            END

            -- NO ERRORS,  COMMIT
            COMMIT;

            -- RETURN the Identity
            SELECT @AttachmentIdentity;

        END
        ELSE
            THROW 50000,  'Invalid participant type.',  1; 


    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
