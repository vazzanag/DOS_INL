CREATE PROCEDURE training.SaveTrainingEventStudentAttachment
    @TrainingEventStudentAttachmentID BIGINT = NULL,
    @TrainingEventID BIGINT,
	@PersonID BIGINT,
    @FileID BIGINT,
    @FileVersion SMALLINT,
    @TrainingEventStudentAttachmentTypeID INT,
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

		IF (@TrainingEventStudentAttachmentTypeID IS NULL OR @TrainingEventStudentAttachmentTypeID <= 0)
		BEGIN
			SELECT @TrainingEventStudentAttachmentTypeID = TrainingEventStudentAttachmentTypeID
			FROM training.TrainingEventStudentAttachmentTypes WHERE [Name] = 'Other';

			IF (@TrainingEventStudentAttachmentTypeID IS NULL)
				SET @TrainingEventStudentAttachmentTypeID = 1;
		END

        IF (@TrainingEventStudentAttachmentID IS NULL OR @TrainingEventStudentAttachmentID <= 0) 
        BEGIN
            -- INSERT NEW training.TrainingEventStudentAttachment RECORD
            INSERT INTO training.TrainingEventStudentAttachments
				(TrainingEventID, PersonID, FileID, FileVersion, TrainingEventStudentAttachmentTypeID, [Description], IsDeleted, ModifiedByAppUserID)
            VALUES
				(@TrainingEventID, @PersonID, @FileID, @FileVersion, @TrainingEventStudentAttachmentTypeID, @Description, @IsDeleted, @ModifiedByAppUserID);

            SET @AttachmentIdentity = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            IF (NOT EXISTS(SELECT * FROM training.TrainingEventStudentAttachments WHERE TrainingEventStudentAttachmentID = @TrainingEventStudentAttachmentID))
                THROW 50000,  'The requested training event student attachment to be updated does not exist.',  1;

            -- UPDATE EXISTING training.TrainingEventStudentAttachment RECORD
            UPDATE training.TrainingEventStudentAttachments SET
                    TrainingEventStudentAttachmentTypeID =  @TrainingEventStudentAttachmentTypeID,
                    [Description] =                  @Description,
                    IsDeleted =                      @IsDeleted,
                    FileVersion =                    @FileVersion,
                    ModifiedByAppUserID =            @ModifiedByAppUserID,
                    ModifiedDate =                   GETUTCDATE()
                WHERE TrainingEventStudentAttachmentID = @TrainingEventStudentAttachmentID;

            SET @AttachmentIdentity = @TrainingEventStudentAttachmentID;
        END

        -- NO ERRORS,  COMMIT
        COMMIT;

        -- RETURN the Identity
        SELECT @AttachmentIdentity;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;