CREATE VIEW [training].[TrainingEventInstructorAttachmentsView]
AS
    SELECT TrainingEventInstructorAttachmentID AS TrainingEventAttachmentID, TrainingEventID, PersonID, a.FileID, 
           a.FileVersion, a.TrainingEventInstructorAttachmentTypeID, t.[Name] AS TrainingEventInstructorAttachmentType,
           f.[FileName], f.FileLocation, f.FileHash, f.ThumbnailPath, 
           a.[Description], a.IsDeleted, a.ModifiedByAppUserID, a.ModifiedDate,

           -- File
           (SELECT FileID, [FileName], f1.FileTypeID, t.[Name] AS FileType, FileLocation, FileHash, 
                   FileVersion, ThumbnailPath, f1.ModifiedByAppUserID, f1.ModifiedDate
              FROM files.Files f1
        INNER JOIN files.FileTypes t on f1.FileTypeID = t.FileTypeID
             WHERE f1.FileID = a.FileID FOR JSON PATH, INCLUDE_NULL_VALUES) FileJSON,

           -- Modified By User
           (SELECT AppUserID, ADOID, [First], [Middle], [Last], FullName, EmailAddress, PicturePath
              FROM users.AppUsersView u
             WHERE AppUserID = a.ModifiedByAppUserID FOR JSON PATH, INCLUDE_NULL_VALUES) ModifiedByUserJSON

      FROM training.TrainingEventInstructorAttachments a
INNER JOIN training.TrainingEventInstructorAttachmentTypes t ON a.TrainingEventInstructorAttachmentTypeID = t.TrainingEventInstructorAttachmentTypeID
INNER JOIN files.Files f ON a.FileID = f.FileID;