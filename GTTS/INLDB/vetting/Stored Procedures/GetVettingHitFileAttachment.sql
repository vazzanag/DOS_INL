CREATE PROCEDURE [vetting].[GetVettingHitFileAttachment]
	@VettingHitFileAttachmentID BIGINT,
	@FileVersion BIGINT
AS
BEGIN
	IF (@FileVersion IS NOT NULL)
	BEGIN
		SELECT VettingHitFileAttachmentID, VettingHitID, FileID, FileVersion, [FileName], [FileHash],
			   [Description], ModifiedByAppUserID, ModifiedDate, ModifiedByUserJSON
		  FROM vetting.VettingHitAttachmentView  
			WHERE VettingHitFileAttachmentID = @VettingHitFileAttachmentID
				AND FileVersion = @FileVersion

	 END
	 ELSE
	 BEGIN
		SELECT VettingHitFileAttachmentID, VettingHitID, FileID, FileVersion, [FileName], [FileHash],
			   [Description], ModifiedByAppUserID, ModifiedDate, ModifiedByUserJSON
		  FROM vetting.VettingHitAttachmentView  
			WHERE VettingHitFileAttachmentID = @VettingHitFileAttachmentID
	 END
END