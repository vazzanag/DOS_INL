CREATE PROCEDURE [persons].[GetPersonAttachmentsByAttachmentType]
    @PersonID BIGINT,
    @AttachmentType NVARCHAR(400)
AS
BEGIN
    DECLARE @PersonAttachmentTypeID INT;

    SELECT @PersonAttachmentTypeID = PersonAttachmentTypeID FROM persons.PersonAttachmentTypes WHERE [Name] = TRIM(@AttachmentType);

    -- VERIFY THE ASSOCIATED files.file RECORD EXISTS
    IF (@PersonAttachmentTypeID IS NULL)
        THROW 50000, 'Attachment type does not exist',  1;

    SELECT PersonID, FileID, [FileName], FileLocation, PersonAttachmentTypeID, PersonAttachmentType, 
		   [Description], IsDeleted, ModifiedByAppUserID, FullName, ModifiedDate
      FROM persons.PersonAttachmentsView
     WHERE PersonID = @PersonID
       AND PersonAttachmentTypeID = @PersonAttachmentTypeID;
END;
