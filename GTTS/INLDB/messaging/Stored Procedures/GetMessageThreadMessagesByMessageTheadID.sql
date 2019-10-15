CREATE PROCEDURE [messaging].[GetMessageThreadMessagesByMessageThreadID]
	@MessageThreadID INT,
	@PageIndex INT,
	@PageSize INT
AS
BEGIN
	SELECT
		MessageThreadMessageID, 
		MessageThreadID,
		SenderAppUserID,
		SenderAppUserFirst,
		SenderAppUserMiddle,
		SenderAppUserLast,
		SentTime, 
		[Message],
		AttachmentFileID,
		AttachmentFileName,
		AttachmentFileLocation,
		AttachmentFileHash,
		AttachmentFileThumbnailPath,
		AttachmentFileSize,
		AttachmentFileType,
		AttachmentFileTypeID
	FROM [messaging].MessageThreadMessagesView
	WHERE MessageThreadID = @MessageThreadID
	ORDER BY SentTime DESC
	OFFSET (@PageIndex * @PageSize) ROWS
	FETCH NEXT @PageSize ROWS ONLY; 
END
