CREATE VIEW training.TrainingEventAttachmentsView
AS
    SELECT TrainingEventAttachmentID, TrainingEventID, a.FileID, a.FileVersion, a.TrainingEventAttachmentTypeID, t.[Name] AS TrainingEventAttachmentType,
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

      FROM training.TrainingEventAttachments a
INNER JOIN training.TrainingEventAttachmentTypes t ON a.TrainingEventAttachmentTypeID = t.TrainingEventAttachmentTypeID
INNER JOIN files.Files f ON a.FileID = f.FileID
