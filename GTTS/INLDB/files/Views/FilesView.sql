CREATE VIEW [files].[FilesView]
AS 
	SELECT files.Files.FileID, files.Files.FileName, files.Files.FileTypeID, files.Files.FileLocation, files.FileHash, files.FileSize,
		   files.FileVersion, files.Files.ThumbnailPath, files.Files.ModifiedDate, files.Files.ModifiedByAppUserID, files.FileTypes.Name AS FileTypeName, 
		   files.FileTypes.Extension AS FileTypeExtension,files.FileTypes.Description AS FileTypeDescription, files.FileTypes.IsActive
	  FROM files.Files 
INNER JOIN files.FileTypes ON files.Files.FileTypeID = files.FileTypes.FileTypeID
