CREATE PROCEDURE [files].[SaveFile]
    @FileID BIGINT = NULL,
    @FileName NVARCHAR(200),
    @FileHash VARBINARY(64),
    @FileLocation NVARCHAR(500),
    @FileSize INT,
    @ThumbnailPath NVARCHAR(200) = NULL,
    @ModifiedByAppUserID INT
AS
BEGIN
    DECLARE @Identity BIGINT,
            @FileTypeID INT,
            @Extension NVARCHAR(10)

    BEGIN TRY
        BEGIN TRANSACTION

        IF (@FileID IS NULL OR @FileID <= 0) 
        BEGIN
            -- GET FILE EXTENSION FROM @FileName
            IF (CHARINDEX('.', @FileName) > 0)
                SELECT @Extension = REVERSE(LEFT(REVERSE(@FileName), CHARINDEX('.', REVERSE(@FileName))));
            ELSE
                SET @Extension = '.*';

            -- DETERMINE FileType
            IF (EXISTS(SELECT * FROM files.FileTypes WHERE Extension = @Extension))
                SELECT @FileTypeID = FileTypeID FROM files.FileTypes WHERE Extension = @Extension;
            ELSE
                SELECT @FileTypeID = FileTypeID FROM files.FileTypes WHERE [Name] = 'Unknown';

            -- INSERT NEW files.File RECORD
            INSERT INTO files.Files
				([FileName], FileHash, FileTypeID, FileLocation, FileSize, ThumbnailPath, ModifiedByAppUserID)
            VALUES
				(@FileName, @FileHash, @FileTypeID, @FileLocation, @FileSize, @ThumbnailPath, @ModifiedByAppUserID);

            SET @Identity = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            IF (NOT EXISTS(SELECT * FROM files.Files WHERE FileID = @FileID))
                THROW 50000,  'The requested file to be updated does not exist.',  1;

            -- UPDATE EXISTING files.File RECORD
            UPDATE files.Files SET
                    FileLocation =           @FileLocation,
                    FileHash =               @FileHash,
					FileSize =               @FileSize,
                    ThumbnailPath =          @ThumbnailPath,
                    ModifiedByAppUserID =    @ModifiedByAppUserID,
                    FileVersion =            (FileVersion + 1),
                    ModifiedDate =           GETUTCDATE()
                WHERE FileID = @FileID;

            SET @Identity = @FileID;
        END;

        -- NO ERRORS,  COMMIT
        COMMIT;

        -- RETURN the Identity
        SELECT @Identity;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
