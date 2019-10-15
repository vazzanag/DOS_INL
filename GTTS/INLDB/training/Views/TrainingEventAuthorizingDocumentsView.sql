CREATE VIEW [training].[TrainingEventAuthorizingDocumentsView]
AS
    SELECT b.TrainingEventID, i.InterAgencyAgreementID AS IAAID, i.ModifiedByAppUserID, i.ModifiedDate,

           -- IAAs
           (SELECT InterAgencyAgreementID AS IAAID, t.Code AS IAA, t.[Description] AS IAADescription
              FROM training.InterAgencyAgreements t 
             WHERE InterAgencyAgreementID = i.InterAgencyAgreementID FOR JSON PATH, INCLUDE_NULL_VALUES) IAAsAsJSON,

           -- Modified By User
           (SELECT AppUserID, [First], [Middle], [Last], FullName
              FROM users.AppUsersView 
             WHERE AppUserID = i.ModifiedByAppUserID FOR JSON PATH, INCLUDE_NULL_VALUES) ModifiedByUserAsJSON

	  FROM training.TrainingEvents b
	  INNER JOIN training.TrainingEventAuthorizingDocuments i ON b.TrainingEventID = i.TrainingEventID