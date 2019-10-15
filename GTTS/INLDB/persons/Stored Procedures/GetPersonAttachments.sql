CREATE PROCEDURE [persons].[GetPersonAttachments]
    @PersonID BIGINT
AS
BEGIN
    SELECT PersonID, FileID, [FileName], FileLocation, PersonAttachmentTypeID, PersonAttachmentType, 
		   [Description], IsDeleted, ModifiedByAppUserID, FullName, ModifiedDate
      FROM persons.PersonAttachmentsView
     WHERE PersonID = @PersonID;
END;
