CREATE PROCEDURE [training].[GetTrainingEventReferences]
AS
BEGIN
    SELECT * FROM training.TrainingEventTypes ORDER BY [Name];
    SELECT * FROM training.KeyActivities ORDER BY [Code];
    SELECT * FROM unitlibrary.USPartnerAgencies ORDER BY [Name];
    SELECT * FROM training.ProjectCodes ORDER BY [Code];
    SELECT * FROM users.BusinessUnits ORDER BY Acronym;
    SELECT * FROM [location].Countries ORDER BY CountryName;
	SELECT * FROM [location].States ORDER BY StateName;
    SELECT InterAgencyAgreementID AS IAAID, Code AS IAA, [Description] AS IAADescription, ModifiedByAppUserID FROM training.InterAgencyAgreements ORDER BY InterAgencyAgreementID;
    SELECT * FROM users.AppUsersView ORDER BY [Last], [First]
	SELECT * FROM training.VisaStatuses
END;
