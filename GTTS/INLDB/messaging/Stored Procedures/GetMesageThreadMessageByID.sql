CREATE PROCEDURE [messaging].[GetMessageThreadMessageByID]
	@MessageThreadMessageID INT
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
	WHERE MessageThreadMessageID = @MessageThreadMessageID;
END
