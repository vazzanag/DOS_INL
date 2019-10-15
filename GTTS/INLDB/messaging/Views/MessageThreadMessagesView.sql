CREATE VIEW [messaging].[MessageThreadMessagesView]
AS
	SELECT 
		MessageThreadMessageID, 
		MessageThreadID,
		SenderAppUserID,
		au.[First] AS SenderAppUserFirst,
		au.Middle AS SenderAppUserMiddle,
		au.[Last] AS SenderAppUserLast,
		SentTime, 
		[Message],
		AttachmentFileID,
		f.[FileName] AS AttachmentFileName,
		f.FileLocation AS AttachmentFileLocation,
		f.FileHash AS AttachmentFileHash,
		f.ThumbnailPath AS AttachmentFileThumbnailPath,
		f.FileSize AS AttachmentFileSize,
		f.FileTypeID AS AttachmentFileTypeID,
		ft.[Name] AS AttachmentFileType
	FROM [messaging].MessageThreadMessages mtm 
	INNER JOIN [users].AppUsers au ON mtm.SenderAppUserID = au.AppUserID 
	LEFT JOIN files.Files f ON mtm.AttachmentFileID = f.FileID
	LEFT JOIN files.FileTypes ft ON f.FileTypeID = ft.FileTypeID;
