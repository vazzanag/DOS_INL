CREATE PROCEDURE training.SaveTrainingEventAttachment
    @TrainingEventAttachmentID BIGINT = NULL,
    @TrainingEventID BIGINT,
    @FileID BIGINT,
    @FileVersion SMALLINT,
    @TrainingEventAttachmentTypeID INT,
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

    BEGIN TRY
        BEGIN TRANSACTION

		IF (@TrainingEventAttachmentTypeID IS NULL OR @TrainingEventAttachmentTypeID <= 0)
		BEGIN
			SELECT @TrainingEventAttachmentTypeID = TrainingEventAttachmentTypeID
			FROM training.TrainingEventAttachmentTypes WHERE [Name] = 'Other';

			IF (@TrainingEventAttachmentTypeID IS NULL)
				SET @TrainingEventAttachmentTypeID = 1;
		END

        IF (@TrainingEventAttachmentID IS NULL OR @TrainingEventAttachmentID <= 0) 
        BEGIN
            -- INSERT NEW training.TrainingEventAttachment RECORD
            INSERT INTO training.TrainingEventAttachments
				(TrainingEventID, FileID, FileVersion, TrainingEventAttachmentTypeID, [Description], IsDeleted, ModifiedByAppUserID)
            VALUES
				(@TrainingEventID, @FileID, @FileVersion, @TrainingEventAttachmentTypeID, @Description, @IsDeleted, @ModifiedByAppUserID);

            SET @AttachmentIdentity = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            IF (NOT EXISTS(SELECT * FROM training.TrainingEventAttachments WHERE TrainingEventAttachmentID = @TrainingEventAttachmentID))
                THROW 50000,  'The requested training event attachment to be updated does not exist.',  1;

            -- UPDATE EXISTING training.TrainingEventAttachment RECORD
            UPDATE training.TrainingEventAttachments SET
                    TrainingEventAttachmentTypeID =  @TrainingEventAttachmentTypeID,
                    [Description] =                  @Description,
                    IsDeleted =                      @IsDeleted,
                    FileVersion =                    @FileVersion,
                    ModifiedByAppUserID =            @ModifiedByAppUserID,
                    ModifiedDate =                   GETUTCDATE()
                WHERE TrainingEventAttachmentID = @TrainingEventAttachmentID;

            SET @AttachmentIdentity = @TrainingEventAttachmentID;
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