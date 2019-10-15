CREATE VIEW training.TrainingEventStudentAttachmentsView
AS
    SELECT TrainingEventStudentAttachmentID, TrainingEventID, PersonID, a.FileID, a.FileVersion, a.TrainingEventStudentAttachmentTypeID, t.[Name] AS TrainingEventStudentAttachmentType,
           f.[FileName], f.FileLocation, f.FileHash, f.ThumbnailPath, 
           a.[Description], a.IsDeleted, a.ModifiedByAppUserID, a.ModifiedDate,

            -- File
           (SELECT FileID, [FileName], f1.FileTypeID, t.[Name] AS FileType, FileLocation, FileHash, FileVersion, ThumbnailPath, f1.ModifiedByAppUserID, f1.ModifiedDate
              FROM files.Files f1
        INNER JOIN files.FileTypes t on f1.FileTypeID = t.FileTypeID
             WHERE f1.FileID = a.FileID FOR JSON PATH, INCLUDE_NULL_VALUES) FileJSON,

           -- Modified By User
           (SELECT AppUserID, [First], [Middle], [Last], FullName
              FROM users.AppUsersView 
             WHERE AppUserID = a.ModifiedByAppUserID FOR JSON PATH, INCLUDE_NULL_VALUES) ModifiedByUserJSON

      FROM training.TrainingEventStudentAttachments a
INNER JOIN training.TrainingEventStudentAttachmentTypes t ON a.TrainingEventStudentAttachmentTypeID = t.TrainingEventStudentAttachmentTypeID
INNER JOIN files.Files f ON a.FileID = f.FileID
