CREATE VIEW [training].[TrainingEventProjectCodesView]
AS
    SELECT b.TrainingEventID, u.ProjectCodeID, 
	       p.Code, p.[Description], 
		   u.ModifiedByAppUserID, u.ModifiedDate,

           -- Project Codes
           (SELECT ProjectCodeID, [Name], Code, p1.IsActive
              FROM training.ProjectCodes p1 
             WHERE p1.ProjectCodeID = u.ProjectCodeID FOR JSON PATH, INCLUDE_NULL_VALUES) ProjectCodeJSON,

           -- Modified By User
           (SELECT AppUserID, [First], [Middle], [Last], FullName 
              FROM users.AppUsersView 
             WHERE AppUserID = u.ModifiedByAppUserID FOR JSON PATH, INCLUDE_NULL_VALUES) ModifiedByUserJSON

	  FROM training.TrainingEvents b
INNER JOIN training.TrainingEventProjectCodes u ON b.TrainingEventID = u.TrainingEventID
INNER JOIN training.ProjectCodes p ON p.ProjectCodeID = u.ProjectCodeID;