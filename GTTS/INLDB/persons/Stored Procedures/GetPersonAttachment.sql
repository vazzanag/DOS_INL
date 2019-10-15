CREATE PROCEDURE [persons].[GetPersonAttachment]
    @PersonID BIGINT,
    @FileID BIGINT
AS
BEGIN
    SELECT PersonID, FileID, [FileName], FileLocation, PersonAttachmentTypeID, PersonAttachmentType, 
		   [Description], IsDeleted, ModifiedByAppUserID, FullName, ModifiedDate
      FROM persons.PersonAttachmentsView
     WHERE PersonID = @PersonID
       AND FileID = @FileID;
END;
