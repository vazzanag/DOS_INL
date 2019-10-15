CREATE PROCEDURE [dbo].[GetReferenceTables]
	@ReferenceList NVARCHAR(MAX),
    @CountryID INT = NULL,
    @PostID INT = NULL
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @sql NVARCHAR(MAX),
			@name NVARCHAR(100)

	DECLARE TABLE_CURSOR CURSOR FOR
			SELECT j.Reference
			  FROM OPENJSON(@ReferenceList) WITH (Reference NVARCHAR(100)) j

	OPEN TABLE_CURSOR
	FETCH NEXT FROM TABLE_CURSOR INTO @Name
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@name = 'TrainingEventTypes') 
			SELECT @name AS Reference, (SELECT * FROM training.TrainingEventTypes FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'RemovalReasons') 
			SELECT @name AS Reference, (SELECT * FROM training.RemovalReasons FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'RemovalCauses') 
			SELECT @name AS Reference, (SELECT * FROM training.RemovalCauses FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'KeyActivities') 
			SELECT @name AS Reference, (SELECT * FROM training.KeyActivities FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'USPartnerAgencies') 
			SELECT @name AS Reference, (SELECT * FROM unitlibrary.USPartnerAgencies FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'ProjectCodes') 
			SELECT @name AS Reference, (SELECT * FROM training.ProjectCodes FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'BusinessUnits') 
			SELECT @name AS Reference, (SELECT * FROM users.BusinessUnits FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'Countries') 
			SELECT @name AS Reference, (SELECT * FROM [location].Countries WHERE IsActive = 1 FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'States') 
			SELECT @name AS Reference, 
			    (SELECT * 
				   FROM [location].States 
			      WHERE CountryID = ISNULL(@CountryID, CountryID)
                 FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'AppUsers') 
			SELECT @name AS Reference, 
			    (SELECT * 
			       FROM users.AppUsersView 
			      WHERE PostID = ISNULL(@PostID, PostID)
                 FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'LanguageProficiencies') 
			SELECT @name AS Reference, (SELECT * FROM [location].LanguageProficiencies FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'Languages') 
			SELECT @name AS Reference, (SELECT * FROM [location].Languages FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'EducationLevels') 
			SELECT @name AS Reference, (SELECT * FROM persons.EducationLevels FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'Units') 
			SELECT @name AS Reference, (SELECT *, UnitBreakdown AS Breakdown FROM unitlibrary.Units u WHERE CountryID = ISNULL(@CountryID, CountryID) FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'Ranks') 
			SELECT @name AS Reference, (SELECT * FROM persons.Ranks WHERE CountryID = ISNULL(@CountryID, CountryID) FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'AuthorizingLaw') 
			SELECT @name AS Reference, 
                (SELECT PostID, UnitID, AuthorizingLawID, Code, [Description], IsActive, PostIsActive
                        ModifiedByAppUserID, PostModifiedByAppUser,PostModifiedDate
	               FROM vetting.AgencyAtPostAuthorizingLawsView p
	              WHERE p.PostID = @PostID AND IsActive = 1 AND PostIsActive = 1
                 FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'FundingSources') 
			SELECT @name AS Reference, 
                (SELECT PostID, UnitID, VettingFundingSourceID, Code, [Description], IsActive, PostIsActive, 
                        ModifiedByAppUserID, PostModifiedByAppUser, PostModifiedDate
	               FROM vetting.AgencyAtPostVettingFundingSourcesView 
	              WHERE PostID = @PostID AND IsActive = 1 AND PostIsActive = 1
                 FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'JobTitles') 
            SELECT @name AS Reference, 
			    (SELECT JobTitle 
                   FROM persons.PersonsUnitLibraryInfo p
             INNER JOIN unitlibrary.Units u ON p.UnitID = u.UnitID
			      WHERE u.CountryID = ISNULL(@CountryID, CountryID)
 			   GROUP BY p.JobTitle
			     FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData
		ELSE IF (@name = 'Posts')
            SELECT @name AS Reference, (SELECT * FROM [location].Posts WHERE CountryID = ISNULL(@CountryID, CountryID) ORDER BY [Name] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'VettingActivityTypes')
            SELECT @name AS Reference, (SELECT * FROM vetting.VettingActivityTypes ORDER BY [Name] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'VettingBatchTypes')
            SELECT @name AS Reference, (SELECT * FROM vetting.VettingBatchTypes ORDER BY Code FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'GovtLevels')
            SELECT @name AS Reference, (SELECT * FROM unitlibrary.GovtLevels ORDER BY [Name] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'UnitTypes')
            SELECT @name AS Reference, (SELECT * FROM unitlibrary.UnitTypes ORDER BY [Name] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'ReportingTypes')
            SELECT @name AS Reference, (SELECT * FROM unitlibrary.ReportingTypes ORDER BY [Name] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'NonAttendanceCauses')
            SELECT @name AS Reference, (SELECT * FROM training.NonAttendanceCauses ORDER BY [Description] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'NonAttendanceReasons')
            SELECT @name AS Reference, (SELECT * FROM training.NonAttendanceReasons ORDER BY [Description] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'TrainingEventRosterDistinctions')
            SELECT @name AS Reference, (SELECT * FROM training.TrainingEventRosterDistinctions ORDER BY [Code] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'VisaStatus')
            SELECT @name AS Reference, (SELECT * FROM training.VisaStatuses ORDER BY [Code] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'HitCredibilityLevels')
            SELECT @name AS Reference, (SELECT * FROM vetting.VettingHitCredibilityLevels ORDER BY [CredibilityLevelID] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'HitReferenceSites')
            SELECT @name AS Reference, (SELECT * FROM vetting.VettingHitReferenceSites ORDER BY [Code] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'HitViolationTypes')
            SELECT @name AS Reference, (SELECT * FROM vetting.VettingHitViolationTypes ORDER BY [Code] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'HitResults')
            SELECT @name AS Reference, (SELECT * FROM vetting.VettingHitResults ORDER BY [Code] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'LeahyHitResults')
            SELECT @name AS Reference, (SELECT * FROM vetting.VettingLeahyHitResults ORDER BY [Code] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE IF (@name = 'LeahyHitAppliesTo')
            SELECT @name AS Reference, (SELECT * FROM vetting.VettingLeahyHitAppliesTo ORDER BY [Code] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
        ELSE IF (@name = 'IAAs')
            SELECT @name AS Reference, (SELECT InterAgencyAgreementID AS IAAID, Code AS IAA, [Description] AS IAADescription FROM training.InterAgencyAgreements ORDER BY [Description] FOR JSON PATH, INCLUDE_NULL_VALUES) AS ReferenceData;
		ELSE
			SELECT NULL

		FETCH NEXT FROM TABLE_CURSOR INTO @name
	END
	CLOSE TABLE_CURSOR
	DEALLOCATE TABLE_CURSOR

END