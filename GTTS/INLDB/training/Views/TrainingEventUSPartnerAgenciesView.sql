CREATE VIEW [training].[TrainingEventUSPartnerAgenciesView]
AS 
    SELECT b.TrainingEventID, u.AgencyID, u.ModifiedByAppUserID, u.ModifiedDate,
	       a.[Name], a.Initials, a.IsActive,

           -- Agency 
           (SELECT a.AgencyID, [Name], Initials, IsActive, ModifiedByAppUserID, ModifiedDate
              FROM unitlibrary.USPartnerAgencies a
             WHERE a.AgencyID = u.AgencyID FOR JSON PATH, INCLUDE_NULL_VALUES) AgencyJSON,

           -- Modified By User
           (SELECT AppUserID, [First], [Middle], [Last], FullName
              FROM users.AppUsersView 
             WHERE AppUserID = u.ModifiedByAppUserID FOR JSON PATH, INCLUDE_NULL_VALUES) ModifiedByUserJSON

	  FROM training.TrainingEvents b
INNER JOIN training.TrainingEventUSPartnerAgencies u ON b.TrainingEventID = u.TrainingEventID
INNER JOIN unitlibrary.USPartnerAgencies a ON a.AgencyID = u.AgencyID;