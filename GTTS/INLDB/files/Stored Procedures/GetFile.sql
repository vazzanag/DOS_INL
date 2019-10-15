CREATE PROCEDURE [files].[GetFile]
	@FileID BIGINT,
	@FileVersion INT = NULL
AS
BEGIN
	IF (@FileVersion IS NOT NULL)
	BEGIN
		SELECT FileID, [FileName], FileTypeID, FileLocation, FileHash, FileSize, 
			   FileVersion, ThumbnailPath, ModifiedDate, ModifiedByAppUserID, 
			   FileTypeName, FileTypeExtension, FileTypeDescription
		FROM   files.FilesView FOR SYSTEM_TIME ALL
		WHERE  FileID = @FileID
		AND    FileVersion = @FileVersion
	END
	ELSE
	BEGIN
		SELECT FileID, [FileName], FileTypeID, FileLocation, FileHash, FileSize, 
			   FileVersion, ThumbnailPath, ModifiedDate, ModifiedByAppUserID, 
			   FileTypeName, FileTypeExtension, FileTypeDescription
		FROM   files.FilesView 
		WHERE  FileID = @FileID
	END
END