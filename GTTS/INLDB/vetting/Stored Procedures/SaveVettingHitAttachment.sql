CREATE PROCEDURE [vetting].[SaveVettingHitAttachment]
	@VettingHitFileAttachmentID BIGINT,
	@VettingHitID BIGINT,
    @FileID BIGINT,
    @FileVersion SMALLINT,
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
    IF (@VettingHitID IS NULL OR NOT EXISTS(SELECT * FROM vetting.VettingHits WHERE VettingHitID = @VettingHitID))
        THROW 50000,  'Associated Vetting Hits does not exist.',  1;

    BEGIN TRY
        BEGIN TRANSACTION

		
        IF (ISNULL(@VettingHitFileAttachmentID, -1 ) <= 0) 
        BEGIN
            -- INSERT NEW vetting.VettingHitFileAttachments
            INSERT INTO vetting.VettingHitFileAttachments(
				VettingHitID, FileID, FileVersion, [Description], IsDeleted, ModifiedByAppUserID)
            VALUES
				(
					@VettingHitID, @FileID, @FileVersion, @Description, @IsDeleted, @ModifiedByAppUserID
				);

            SET @AttachmentIdentity = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            IF (NOT EXISTS(SELECT * FROM vetting.VettingHitFileAttachments WHERE VettingHitFileAttachmentID = @VettingHitFileAttachmentID))
                THROW 50000,  'The requested vetting hit attachment to be updated does not exist.',  1;

            -- UPDATE EXISTING vetting.VettingHitFileAttachments RECORD
            UPDATE vetting.VettingHitFileAttachments SET
                    [Description] =                  @Description,
                    IsDeleted =                      @IsDeleted,
                    FileVersion =                    @FileVersion,
                    ModifiedByAppUserID =            @ModifiedByAppUserID,
                    ModifiedDate =                   GETUTCDATE()
                WHERE VettingHitFileAttachmentID = @VettingHitFileAttachmentID;

            SET @AttachmentIdentity = @VettingHitFileAttachmentID;
        END

        -- NO ERRORS,  COMMIT
        COMMIT;

        -- RETURN the Identity
        SELECT VettingHitFileAttachmentID, VettingHitID, FileID, FileVersion, [FileName], [FileHash],
			   [Description], ModifiedByAppUserID, ModifiedDate, ModifiedByUserJSON
		  FROM vetting.VettingHitAttachmentView  
			WHERE VettingHitFileAttachmentID = @AttachmentIdentity


    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;