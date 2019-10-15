CREATE PROCEDURE [files].[GetFiles]
AS
BEGIN
	SELECT FileID, [FileName], FileTypeID, FileLocation, FileHash, FileSize, FileVersion, ThumbnailPath, ModifiedDate, 
		   ModifiedByAppUserID, FileTypeName, FileTypeExtension, FileTypeDescription, IsActive 
	  FROM files.FilesView
  ORDER BY [FileName]
END
