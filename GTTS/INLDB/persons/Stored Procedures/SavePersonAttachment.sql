CREATE PROCEDURE [persons].[SavePersonAttachment]
    @PersonID BIGINT,
    @FileID BIGINT,
    @FileVersion SMALLINT,
    @PersonAttachmentType NVARCHAR(100),
    @Description NVARCHAR(500),
    @IsDeleted BIT = 0,
    @ModifiedByAppUserID INT
AS
BEGIN
    DECLARE @FileIdentity INT,
            @AttachmentIdentity INT,
            @PersonAttachmentTypeID INT;

    -- VERIFY THE ASSOCIATED files.file RECORD EXISTS
    IF (@FileID IS NULL OR NOT EXISTS(SELECT * FROM files.Files WHERE FileID = @FileID))
        THROW 50000,  'Associated File does not exist',  1;

    BEGIN TRY
        BEGIN TRANSACTION

        SELECT @PersonAttachmentTypeID = PersonAttachmentTypeID FROM persons.PersonAttachmentTypes WHERE [Name] = @PersonAttachmentType;

		IF (@PersonAttachmentType IS NULL OR @PersonAttachmentType = '')
		BEGIN
			SELECT @PersonAttachmentTypeID = PersonAttachmentTypeID
			FROM persons.PersonAttachmentTypes WHERE [Name] = 'Other';

			IF (@PersonAttachmentTypeID IS NULL)
				SET @PersonAttachmentTypeID = 1;
		END;
;

        --IF (@FileID IS NULL OR @FileID <= 0) 
        IF (NOT EXISTS(SELECT * FROM persons.PersonAttachments WHERE PersonID = @PersonID AND FileID = @FileID))
        BEGIN
            -- INSERT NEW persons.PersonAttachments RECORD
            INSERT INTO persons.PersonAttachments
				(PersonID, FileID, PersonAttachmentTypeID, [Description], IsDeleted, ModifiedByAppUserID)
            VALUES
				(@PersonID, @FileID, @PersonAttachmentTypeID, @Description, @IsDeleted, @ModifiedByAppUserID);

        END
        ELSE
        BEGIN
            -- UPDATE EXISTING training.TrainingEventAttachment RECORD
            UPDATE persons.PersonAttachments SET
                    PersonAttachmentTypeID =         @PersonAttachmentTypeID,
                    [Description] =                  @Description,
                    IsDeleted =                      @IsDeleted,
                    ModifiedByAppUserID =            @ModifiedByAppUserID,
                    ModifiedDate =                   GETUTCDATE()
                WHERE PersonID = @PersonID AND FileID = @FileID;
        END

        -- NO ERRORS,  COMMIT
        COMMIT;

        -- RETURN the Identity
        SELECT @PersonID, @FileID;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
