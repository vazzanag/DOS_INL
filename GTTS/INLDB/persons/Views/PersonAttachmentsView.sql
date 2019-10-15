CREATE VIEW [persons].[PersonAttachmentsView]
AS
    SELECT PersonID, p.FileID, f.[FileName], f.FileLocation, p.PersonAttachmentTypeID, pt.[Name] AS PersonAttachmentType, 
		   p.[Description], p.IsDeleted, p.ModifiedByAppUserID, u.FullName, p.ModifiedDate
      FROM persons.PersonAttachments p
INNER JOIN persons.PersonAttachmentTypes pt ON p.PersonAttachmentTypeID = pt.PersonAttachmentTypeID
INNER JOIN files.Files f ON p.FileID = f.FileID
INNER JOIN files.FileTypes ft ON f.FileTypeID = ft.FileTypeID
INNER JOIN users.AppUsersView u ON p.ModifiedByAppUserID = u.AppUserID
