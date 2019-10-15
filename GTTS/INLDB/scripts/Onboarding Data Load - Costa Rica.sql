/*
    NAME:   Onboarding Data Load Script
    
    DESCR:  Load data provided by the New Post Onboarding User Data Forms template file 
            received from Costa Rica into the different GTTS database tables.

    NOTES:  Before running this script:
    
                1) Load all of the Onboarding template values into their coresponding tabs in the 
                   ONBOARDING LISTS DATA UPLOAD.xlsx template file.
                
                2) Using the SSMS Import Data... tool, import the data from the different tabs in 
                   the ONBOARDING LISTS DATA UPLOAD.xlsx template file into their corresponding 
                   INLDB [migraton].[xxxx] schema tables as listed below:

                   Tab Name                             INLDB [migration].[xxxx] Table
                   ===============================      =========================================
                   OnboardingAuthorizingDocsList   ==>  OnboardingAuthorizingDocumentsList
                   OnboardingBusinessUnitsList     ==>  OnboardingBusinessUnitsList
                   OnboardingCitiesList            ==>  OnboardingCitiesList
                   OnboardingDefaultBudgetCalc     ==>  OnboardingDefaultBudgetCalcValues
                   OnboardingImplementingPartners  ==>  OnboardingImplementingPartners
                   OnboardingKeyActivitiesList     ==>  OnboardingKeyActivitiesList
                   OnboardingPostConfigValues      ==>  OnboardingPostConfigurationValues
                   OnboardingRanksList             ==>  OnboardingRanksList
                   OnboardingStatesList            ==>  OnboardingStatesList
                   OnboardingTrainEventFundSrcList ==>  OnboardingTrainingEventFundingSourcesList
                   OnboardingUsersList             ==>  OnboardingUsersList
                   OnboardingVettingAuthLawsList   ==>  OnboardingVettingAuthorizingLawsList
                   OnboardingVettingFundingList    ==>  OnboardingVettingFundingList
   
                3) Configure the @CountryID variable with the correct CountryID for the Country being onboarded.          
*/

-- Point to INLDB Database.
USE INLDB
GO

BEGIN
    SET NOCOUNT ON;

    -- *******************************************************************
    -- Declare & set the Country ID of the Country being onboarded.  
    -- This is the CountryID value from the [location].[Countries] table.
    -- This value should be set prior to running this Onboarding script.
    -- *******************************************************************
    DECLARE @CountryID AS INT = 2059;   -- 2059 = Costa Rica
                                        -- This is intended to be converted to a passed-in
                                        -- parameter at runtime.

    -- ******************************************************
    -- Initialize local variables for use within this script.
    -- ******************************************************
    DECLARE @StartTime AS DATETIME2(7) = NULL;
	SET @StartTime = SYSUTCDATETIME();
    DECLARE @EndTime AS DATETIME2(7) = NULL;    
    DECLARE @CountryName AS NVARCHAR(75) = NULL;
    DECLARE @CountryCodeA2 AS NCHAR(2) = NULL;
    DECLARE @CountryCodeA3 AS NCHAR(3) = NULL;
    DECLARE @CountryINKCode AS NVARCHAR(15) = NULL;
    DECLARE @PostID AS INT = NULL;
    DECLARE @PostName AS NVARCHAR(100) = NULL;
    DECLARE @PostFullName AS NVARCHAR(255) = NULL;
    DECLARE @AppUserID AS INT = 2;          -- AppUser = ONBOARDING 
    DECLARE @RecCnt AS INT = 0;
    DECLARE @Text AS NVARCHAR(255) = NULL;
    SELECT @CountryName = c.CountryName,
        @CountryCodeA2 = c.GENCCodeA2,
        @CountryCodeA3 = c.GENCCodeA3,
        @CountryINKCode = c.INKCode,
        @PostID = p.PostID,
        @PostName = p.[Name],
		@PostFullName = p.FullName
    FROM [location].[Countries] c
    JOIN [location].[Posts] p ON p.CountryID = @CountryID
	JOIN [location].[PostTypes] pt ON pt.PostTypeID = p.PostTypeID
    WHERE c.CountryID = @CountryID
	  AND pt.PostTypeCode = 'E';            -- Post Type = Embassy

    SET @Text = 'Country Onboarding Data Load Process for ' + @PostFullName + ' in ' +  @CountryName + ' has STARTED (' + CAST(@StartTime AS NVARCHAR) + ')';
    PRINT REPLICATE('=', LEN(TRIM(@Text)));
    PRINT @Text;
    PRINT REPLICATE('=', LEN(TRIM(@Text)));
    PRINT '';
    
    -- Display local variables
    SELECT @CountryID AS CountryID,
           @CountryName AS CountryName,
           @CountryCodeA2 AS CountryCodeA2,
           @CountryCodeA3 AS CountryCodeA3,
           @CountryINKCode AS CountryINKCode,
           @PostID AS PostID,
           @PostName AS PostName,
		   @PostFullName AS PostFullName;
    PRINT '  CountryID      = ' + CAST(@CountryID AS NVARCHAR);
    PRINT '  CountryName    = ' + @CountryName;
    PRINT '  CountryCodeA2  = ' + @CountryCodeA2;
    PRINT '  CountryCodeA3  = ' + @CountryCodeA3;
    PRINT '  CountryINKCode = ' + @CountryINKCode;
    PRINT '  PostID         = ' + CAST(@PostID AS NVARCHAR);
    PRINT '  PostName       = ' + @PostName;
    PRINT '  PostFullName   = ' + @PostFullName;
	PRINT '';

    BEGIN TRY
        BEGIN TRANSACTION

        -- ******************************************
        -- Import States into the [States] table.
        -- ******************************************
        PRINT 'BEGIN States Import for ' + @CountryName + '.';
        DBCC CHECKIDENT ('[location].[States]');
        BEGIN
            BEGIN TRANSACTION
                -- Insert new States for the Onboarding Country.
                INSERT INTO [location].[States]
                    ([StateName], [CountryID], [IsActive], [ModifiedByAppUserID])
                SELECT ol.StateName, @CountryID, 1, @AppUserID
                  FROM [migration].[OnboardingStatesList] ol
                 WHERE ol.StateName NOT IN
                    (SELECT s.StateName
                       FROM [location].[States] s
                      WHERE s.CountryID = @CountryID);
                PRINT 'States for ' + @CountryName + ' inserted into [States] table.';
			COMMIT;
            
			BEGIN TRANSACTION
                -- Test if an 'Unknown' State record exists for the Onboarding Country.
                -- If not, create one.
                IF (NOT EXISTS(SELECT *
                                 FROM [location].[States] s
                                WHERE s.CountryID = @CountryID AND s.StateName = 'Unknown'))
                    -- 'Unknown' State does not exist.  Create 'Unknown' State.
                    BEGIN
                        PRINT 'Unknown State does not exist for ' + @CountryName + '.';
                        INSERT INTO [location].[States]
                            ([StateName], [StateCodeA2], [Abbreviation], [CountryID], [IsActive], [ModifiedByAppUserID])
                        VALUES ('Unknown', 'UK' , 'UNK', @CountryID, 1, @AppUserID);
                        PRINT 'Unknown State created for ' + @CountryName + '.';
                    END
                ELSE
                    -- 'Unknown' State does exists.  Do nothing.                
                    BEGIN
                        PRINT 'Unknown State already exists for ' + @CountryName + '.';
                    END;
            COMMIT;
        END;
        DBCC CHECKIDENT ('[location].[States]');
        PRINT 'END States Import for ' + @CountryName;
        PRINT '';

        -- **************************************
        -- Import Cities into the [Cities] table.
        -- **************************************
        PRINT 'BEGIN Cities Import for ' + @CountryName;
        DBCC CHECKIDENT ('[location].[Cities]');	
		BEGIN
			-- Step 1: Identify those Cities in the [Cities] table which are currently related to the "Unknown" State
			--		   in the Onboarding Country.  These [Cities] records need to be updated with the correct StateID 
			--		   based on the State Name associated to the City in the [OnboardingCitiesList] table.
            BEGIN TRANSACTION
                -- Create a table variable of these Cities.
                DECLARE @CitiesWithUnkownStatesTbl AS TABLE
                (
                    ActualCityID  INT,
                    ActualCityName NVARCHAR(MAX), 
                    CurrentUnknownStateID INT, 
                    CorrectStateName NVARCHAR(MAX),
                    CorrectStateID INT
                );

                -- Insert known Cities with unknown States into the the table variable.
                INSERT INTO @CitiesWithUnkownStatesTbl
                    (ActualCityID, ActualCityName, CurrentUnknownStateID, CorrectStateName,	CorrectStateID)
                SELECT c.CityID, c.CityName, s.StateID, obcl.StateName, s2.StateID
                  FROM [location].[Cities] c
                  JOIN [location].[States] s ON s.StateID = c.StateID
                  JOIN [migration].[OnboardingCitiesList] obcl 
                  JOIN [location].[States] s2 ON s2.StateName = obcl.StateName
                    ON UPPER(TRIM([migration].RemoveAccents(obcl.CityName))) = UPPER(TRIM([migration].RemoveAccents(c.CityName)))
                 WHERE s.CountryID = @CountryID AND s.StateName = 'Unknown';

                -- Update the StateID value in the [Cities] table with the corrected StateID 
                -- from the @CitiesWithUnkownStatesTbl table variable.
                UPDATE c
                   SET c.StateID = tblvar.CorrectStateID,
                       c.ModifiedByAppUserID = @AppUserID
                  FROM [location].[Cities] c
                  JOIN @CitiesWithUnkownStatesTbl tblvar ON tblvar.ActualCityID = c.CityID;
            COMMIT;

			-- Step 2: Any Cities in the [OnboardingCitiesList] table that do not already exist in the [Cities] table
			--		   will need to be added to the [Cities] table.
            BEGIN TRANSACTION
                -- Create a table variable of the rest of the Cities to load into the database for the Onboarding Country.
                DECLARE @RemainingCitiesToInsertTbl AS TABLE
                (
                    StateName NVARCHAR(MAX),
                    StateID INT,
                    CityName NVARCHAR(MAX)
                );

                -- Insert a list of the remaining Cities to load into the database into the table variable.
                INSERT INTO @RemainingCitiesToInsertTbl
                    (StateName, StateID, CityName)
                SELECT ol.StateName, NULL, ol.CityName
                  FROM [migration].[OnboardingCitiesList] ol
                 WHERE (ol.CityName NOT IN
                    (SELECT c.CityName
                       FROM [location].[Cities] c
                       JOIN [location].[States] s ON s.StateID = c.StateID
                       WHERE s.CountryID = @CountryID)
                    AND ol.StateName NOT IN
                    (SELECT s.StateName
                       FROM [location].[Cities] c
                       JOIN location.States s ON s.StateID = c.StateID
                       WHERE s.CountryID = @CountryID))
                OR (ol.CityName NOT IN
                    (SELECT c.CityName
                       FROM [location].[Cities] c
                       JOIN [location].[States] s ON s.StateID = c.StateID
                       WHERE s.CountryID = @CountryID)
                    AND ol.StateName IN
                    (SELECT s.StateName
                       FROM [location].[Cities] c
                       JOIN location.States s ON s.StateID = c.StateID
                       WHERE s.CountryID = @CountryID))	
                ORDER BY ol.StateName, ol.CityName

                -- Update the StateID value in the @RemainingCitiesToInsertTbl table variable 
                -- with the actual StateID value from the [States] table.  
                UPDATE tblvar
                    SET tblvar.StateID = s.StateID
                   FROM @RemainingCitiesToInsertTbl tblvar
                   JOIN [location].[States] s 
                     ON UPPER(TRIM([migration].RemoveAccents(s.StateName))) = UPPER(TRIM([migration].RemoveAccents(tblvar.StateName)))

                -- Insert the remaining Cities listed in the table variable into the [Cities] table.
                INSERT INTO [location].[Cities]
                    ([CityName], [StateID], [IsActive], [ModifiedByAppUserID]) 
                SELECT tblvar.CityName, tblvar.StateID, 1, @AppUserID
                  FROM @RemainingCitiesToInsertTbl tblvar
            COMMIT;

			-- Step 3: Test if 'Unknown' City records exist for each of the States previously created for the 
			--		   Onboarding Country.  If any State does not have an 'Unknown' City, create one.
            BEGIN TRANSACTION            
                IF (NOT EXISTS(SELECT * 
                                 FROM [location].[Cities] c
                                 JOIN [location].[States] s ON s.StateID = c.StateID
                                WHERE s.CountryID = @CountryID 
                                  AND s.StateName <> 'Unknown'
                                  AND c.CityName = 'Unknown'))
                    -- 'Unknown' Cities for the States in the Onboarding Country do not exist.
                    -- Create the missing 'Unknown' Cities for the States in the Onboarding Country.
                    BEGIN
                        PRINT 'Unknown Cities do not exist for the newly added States in ' + @CountryName + '.';
                            INSERT INTO [location].[Cities]
                                ([CityName], [StateID], [IsActive], [ModifiedByAppUserID]) 
                            SELECT 'Unknown', s.StateID, 1, @AppUserID
                              FROM [location].[States] s
                             WHERE s.CountryID = @CountryID 
                               AND s.StateName <> 'Unknown';
                        PRINT 'Unknown Cities for the newly added States were created for ' + @CountryName;;
                    END
                ELSE
                    -- 'Unknown' City does exists.  Do nothing.                   
                    BEGIN
                        PRINT 'Unknown Cities already exist for ' + @CountryName + '.';
                    END;
            COMMIT;
        END;
		DBCC CHECKIDENT ('[location].[Cities]');
        PRINT 'END Cities Import for ' + @CountryName;
        PRINT '';

        -- *****************************************************
        -- Import Business Units into the [BusinessUnits] table.
        -- *****************************************************
        PRINT 'BEGIN Business Units Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[users].[BusinessUnits]');
        BEGIN TRANSACTION
            IF (NOT EXISTS(SELECT * 
                            FROM [users].[BusinessUnits] bu
                            WHERE bu.PostID = @PostID))         
            -- No Business Units exist for the Onboarding Country.
                BEGIN
                    -- Insert new Business Units for the Onboarding Country.
                    INSERT INTO [users].[BusinessUnits]
                        ([BusinessUnitName],
                         [Acronym],
                         [PostID],
                         [IsActive],
                         [IsDeleted],
                         [VettingPrefix],
                         [HasDutyToInform],
                         [ModifiedByAppUserID])
                    SELECT ol.BusinessUnitName, 
                           ol.Acronym, 
                           @PostID,
                           1, 
                           0, 
                           ol.Acronym, 
                           (CASE ol.HasDutyToInform WHEN 'Y' THEN 1 ELSE 0 END), 
                           @AppUserID
                      FROM [migration].[OnboardingBusinessUnitsList] ol
                     WHERE ol.BusinessUnitName NOT IN
                        (SELECT bu.BusinessUnitName
                           FROM [users].[BusinessUnits] bu
                          WHERE bu.PostID = @PostID);
                        PRINT 'Business Units for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [BusinessUnits] table.';
                END
            ELSE
                -- Business Units already exist.  Do nothing.                   
                BEGIN
                    PRINT 'Business Units already exist for ' + @CountryName + '.';
                END;			
        COMMIT;
        DBCC CHECKIDENT ('[users].[BusinessUnits]');
        PRINT 'END Business Units Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- **************************************************************************
        -- Import GTTS Users, into the [AppUsers] table.
        -- Users are matched on 'ONBOARDING-' + ol.EmailAddress = [AppUsers].[ADOID].  
        -- **************************************************************************    
        PRINT 'BEGIN Users Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[users].[AppUsers]');
		BEGIN TRANSACTION
            -- Insert new Users for the Onboarding Post/Country.
            -- Users are matched on 'ONBOARDING-' + ol.EmailAddress = [AppUsers].[ADOID].
            INSERT INTO [users].[AppUsers]
                ([ADOID], [First], [Last], [EmailAddress], [CountryID], [PostID], [ModifiedByAppUserID])			
            SELECT DISTINCT 'ONBOARDING-' + ol.EmailAddress, ol.FirstName, ol.LastName, ol.EmailAddress, @CountryID, @PostID, @AppUserID
              FROM [migration].[OnboardingUsersList] ol
             WHERE 'ONBOARDING-' + ol.EmailAddress NOT IN 			 
                (SELECT au.ADOID
                   FROM [migration].[OnboardingUsersList] ol
                   JOIN [users].[AppUsers] au ON au.ADOID = 'ONBOARDING-' + ol.EmailAddress);
            PRINT 'Users for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [AppUsers] table.';
        COMMIT;
        DBCC CHECKIDENT ('[users].[AppUsers]');     
        PRINT 'END Users Import for ' + @PostFullName + ' in ' +  @CountryName;        
        PRINT '';

        -- **************************************************************************
        -- Import GTTS User Business Units into the [AppUserBusinessUnits] tables.
        -- Users are matched on 'ONBOARDING-' + ol.EmailAddress = [AppUsers].[ADOID].        
        -- NOTES: [DefaultBusinessUnit] = TRUE (1)
        --        [Writeable] is set by the database automatically = FALSE (0) 
        -- **************************************************************************        
        PRINT 'BEGIN User Business Units Import for ' + @PostFullName + ' in ' +  @CountryName;  
        SET @RecCnt = (SELECT COUNT(*) FROM [users].[AppUserBusinessUnits]);
        PRINT '[AppUserBusinessUnits] Before Record Count = ' + CAST(@RecCnt AS NVARCHAR);
        BEGIN TRANSACTION
            -- Insert new User Business Unit assignments for the new Users in the Onboarding Post/Country.
            INSERT INTO [users].[AppUserBusinessUnits]
                ([AppUserID] ,[BusinessUnitID] ,[DefaultBusinessUnit] ,[ModifiedByAppUserID])
            SELECT DISTINCT au.AppUserID, bu.BusinessUnitID, 1, @AppUserID
              FROM [migration].[OnboardingUsersList] ol
              JOIN [users].[AppUsers] au ON au.ADOID = 'ONBOARDING-' + ol.EmailAddress
              JOIN [users].[BusinessUnits] bu ON bu.BusinessUnitName = ol.BusinessUnit
             WHERE au.PostID = bu.PostID
               AND ( ('ONBOARDING-' + ol.EmailAddress NOT IN
                        (SELECT au.ADOID
                           FROM [users].[AppUserBusinessUnits] abu
                           JOIN [users].[AppUsers] au ON au.AppUserID = abu.AppUserID))
                  OR ('ONBOARDING-' + ol.EmailAddress NOT IN
                        (SELECT au.ADOID
                           FROM [users].[AppUserBusinessUnits] abu
                           JOIN [users].[AppUsers] au ON au.AppUserID = abu.AppUserID
                           JOIN [users].[BusinessUnits] bu ON bu.BusinessUnitID = abu.BusinessUnitID
                           JOIN [migration].[OnboardingUsersList] ol ON au.ADOID = 'ONBOARDING-' + ol.EmailAddress
                          WHERE bu.BusinessUnitName = ol.BusinessUnit)) );
            PRINT 'User Business Unit Assignments for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [AppUserBusinessUnits] table.';
        COMMIT;
        SET @RecCnt = (SELECT COUNT(*) FROM [users].[AppUserBusinessUnits]);
        PRINT '[AppUserBusinessUnits] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);        
        PRINT 'END User Business Units Import for ' + @PostFullName + ' in ' +  @CountryName; 
        PRINT '';

        -- **************************************************************************
        -- Import GTTS User Roles into the [AppUserRoles] table.
        -- Users are matched on 'ONBOARDING-' + ol.EmailAddress = [AppUsers].[ADOID].  
        -- User Role Codes:
        --      AppRoleID   Code                        Name
        --          1	    INLGTTSVIEWONLY	            GTTS View Only
        --          2	    INLPROGRAMMANAGER	        Program Manager
        --          3	    INLVETTINGCOORDINATOR       Vetting Coordinator
        --          4	    INLCOURTESYVETTER	        Courtesy Vetter
        --          5	    INLLOGISTICSCOORDINATOR     Logisitics Cooridinator
        --          6	    INLPOSTADMIN	            Post Administrator
        --          7	    INLAGENCYADMIN	            Agency Administrator
        --          8	    INLGLOBALADMIN	            GTTS Global Administrator
        -- **************************************************************************
        PRINT 'BEGIN User Roles Import for ' + @PostFullName + ' in ' +  @CountryName;            
        SET @RecCnt = (SELECT COUNT(*) FROM [users].[AppUserRoles]);
        PRINT '[AppUserRoles] Before Record Count = ' + CAST(@RecCnt AS NVARCHAR);
        BEGIN TRANSACTION
            -- Insert new User Roles for the new Users in the Onboarding Post/Country. 
            INSERT INTO [users].[AppUserRoles]
                ([AppUserID] ,[AppRoleID] ,[DefaultRole] ,[ModifiedByAppUserID])
            SELECT au.AppUserID, ar.AppRoleID, 0, @AppUserID
              FROM [migration].[OnboardingUsersList] ol
              JOIN [users].[AppUsers] au ON au.ADOID = 'ONBOARDING-' + ol.EmailAddress
              JOIN [users].[AppRoles] ar ON ar.Name = ol.Role
             WHERE ('ONBOARDING-' + ol.EmailAddress NOT IN
                   (SELECT au.ADOID
                       FROM [users].[AppUserRoles] aur
                       JOIN [users].[AppUsers] au ON au.AppUserID = aur.AppUserID))
                OR ('ONBOARDING-' + ol.EmailAddress NOT IN
                    (SELECT au.ADOID
                       FROM [users].[AppUserRoles] aur
                       JOIN [users].[AppUsers] au ON au.AppUserID = aur.AppUserID
                       JOIN [users].[AppRoles] ar ON ar.AppRoleID = aur.AppRoleID
                       JOIN [migration].[OnboardingUsersList] ol ON au.ADOID = 'ONBOARDING-' + ol.EmailAddress
                      WHERE ar.Name = ol.Role));
            PRINT 'Users Roles assigned to Users for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [AppUserRoles] table.';
        COMMIT;
        SET @RecCnt = (SELECT COUNT(*) FROM [users].[AppUserRoles]);
        PRINT '[AppUserRoles] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);         
        PRINT 'END User Roles Import for ' + @PostFullName + ' in ' +  @CountryName;   
        PRINT '';

        -- ****************************************************************
        -- Import Implementing Partners into the [USPartnerAgencies] table.
        -- ****************************************************************
        PRINT 'BEGIN Implementing Partners Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[unitlibrary].[USPartnerAgencies]');   
        BEGIN TRANSACTION
            -- Insert new Implementing Partners for the Onboarding Country.
            INSERT INTO [unitlibrary].[USPartnerAgencies]
                    ([Name], [Initials], [IsActive], [ModifiedByAppUserID])
            SELECT oip.FullName, oip.Acronym, 1, @AppUserID
              FROM [migration].[OnboardingImplementingPartners] oip
             WHERE oip.FullName NOT IN (SELECT usp.Name FROM [unitlibrary].[USPartnerAgencies] usp);
            PRINT 'Implementing Partners for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [USPartnerAgencies] table.';
        COMMIT;  
        DBCC CHECKIDENT ('[unitlibrary].[USPartnerAgencies]');
        PRINT 'END Implementing Partners Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- *************************************************************************************************
        -- Generate new Implementing Partner records for the Post in the [ImplementingPartnersAtPost] table.
        -- *************************************************************************************************
        PRINT 'BEGIN Implementing Partners At Post Configuration for ' + @PostFullName + ' in ' +  @CountryName;
        SET @RecCnt = (SELECT COUNT(*) FROM [unitlibrary].[ImplementingPartnersAtPost]);      
        PRINT '[ImplementingPartnersAtPost] Before Record Count = ' + CAST(@RecCnt AS NVARCHAR)        
        BEGIN TRANSACTION
            INSERT INTO [unitlibrary].[ImplementingPartnersAtPost]
                ([PostID], [USPartnerAgencyID], [IsActive], [ModifiedByAppUserID])		
            SELECT @PostID, usp.AgencyID, 1, @AppUserID
              FROM [migration].[OnboardingImplementingPartners] oip
              JOIN [unitlibrary].[USPartnerAgencies] usp ON usp.Name = oip.FullName
             WHERE usp.IsActive = 1 
               AND oip.FullName NOT IN
                    (SELECT usp2.Name
                       FROM [unitlibrary].[ImplementingPartnersAtPost] ipp
                       JOIN [unitlibrary].[USPartnerAgencies] usp2 ON usp2.AgencyID = ipp.USPartnerAgencyID
                      WHERE ipp.PostID = @PostID);
			PRINT 'Implementing Partners At Post for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [ImplementingPartnersAtPost] table.';
        COMMIT;
        SET @RecCnt = (SELECT COUNT(*) FROM [unitlibrary].[ImplementingPartnersAtPost]);
        PRINT '[ImplementingPartnersAtPost] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);	
        PRINT 'END Implementing Partners At Post Configuration for ' + @PostFullName + ' in ' +  @CountryName;       
        PRINT '';

        -- ************************************
        -- Import Ranks into the [Ranks] table.
        -- ************************************
        PRINT 'BEGIN Ranks Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[persons].[Ranks]');
        BEGIN TRANSACTION
            IF (NOT EXISTS(SELECT * 
                             FROM [persons].[Ranks] r
                            WHERE r.CountryID = @CountryID))         
                -- No Ranks exist for the Onboarding Country.
                BEGIN
                    -- Insert new Ranks for the Onboarding Country.
                    INSERT INTO [persons].[Ranks]
                    ([RankName], [CountryID], [ModifiedByAppUserID]) 
                    SELECT ol.RankName, @CountryID, @AppUserID
                      FROM [migration].[OnboardingRanksList] ol
                     WHERE ol.RankName NOT IN
                        (SELECT r.RankName 
                           FROM [persons].[Ranks] r
                          WHERE r.CountryID = @CountryID);
                    PRINT 'Ranks for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [Ranks] table.';
                END;
        COMMIT;
        DBCC CHECKIDENT ('[persons].[Ranks]');
        PRINT 'END Ranks Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- *******************************************************
        -- Import new Vetting Types into the [VettingTypes] table.
        -- *******************************************************
        PRINT 'BEGIN New Vetting Types Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[vetting].[VettingTypes]');
        BEGIN TRANSACTION
            -- Insert new Vetting Types from the Onboarding Country.
            INSERT INTO [vetting].[VettingTypes]
                ([Description], [Code], [IsActive], [ModifiedByAppUserID])
            SELECT obul.BusinessUnitName, obul.Acronym, 1, @AppUserID
              FROM [migration].[OnboardingBusinessUnitsList] obul
             WHERE UPPER(TRIM(obul.CourtesyVettingUnit)) = 'Y'
               AND obul.BusinessUnitName NOT IN (SELECT vt.Description FROM [vetting].[VettingTypes] vt);
            PRINT 'New Vetting Types from ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [VettingTypes] table.';
        COMMIT;   
		DBCC CHECKIDENT ('[vetting].[VettingTypes]');
        PRINT 'END New Vetting Types Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- *************************************************************************************************
        -- Generate new Vetting Types at Post records for the Post in the [PostVettingTypes] table.
        -- *************************************************************************************************
        PRINT 'BEGIN Vetting Types At Post Configuration for ' + @PostFullName + ' in ' +  @CountryName;
        SET @RecCnt = (SELECT COUNT(*) FROM [vetting].[PostVettingTypes]);      
        PRINT '[PostVettingTypes] Before Record Count = ' + CAST(@RecCnt AS NVARCHAR)        
        BEGIN TRANSACTION
            INSERT INTO [vetting].[PostVettingTypes]
                ([PostID], [VettingTypeID], [IsActive], [ModifiedByAppUserID])		
            SELECT @PostID, vt.VettingTypeID, 1, @AppUserID
              FROM [migration].[OnboardingBusinessUnitsList] obul
              JOIN [vetting].[VettingTypes] vt ON vt.Description = obul.BusinessUnitName
             WHERE UPPER(TRIM(obul.CourtesyVettingUnit)) = 'Y' AND vt.IsActive = 1		   
               AND obul.BusinessUnitName NOT IN
                    (SELECT vt2.Description
                       FROM [vetting].[PostVettingTypes] pvt
                       JOIN [vetting].[VettingTypes] vt2 ON vt2.VettingTypeID = pvt.VettingTypeID
                      WHERE pvt.PostID = @PostID);
			PRINT 'Vetting Types At Post for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [PostVettingTypes] table.';
		COMMIT;
        SET @RecCnt = (SELECT COUNT(*) FROM [vetting].[PostVettingTypes]);
        PRINT '[PostVettingTypes] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);	
        PRINT 'END Vetting Types At Post Configuration for ' + @PostFullName + ' in ' +  @CountryName;       
        PRINT '';

        -- *****************************************************************************************
        -- Import Vetting Funding Sources into the [VettingFundingSources] table.
        -- *****************************************************************************************
        PRINT 'BEGIN Vetting Funding Sources Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[vetting].[VettingFundingSources]');
        BEGIN TRANSACTION
            -- Insert new Vetting Funding Sources for the Onboarding Country.
            INSERT INTO [vetting].[VettingFundingSources]
                ([Code], [Description], [IsActive], [ModifiedByAppUserID])        
            SELECT ol.Code, ol.Description, 1, @AppUserID
              FROM [migration].[OnboardingVettingFundingList] ol
             WHERE ol.Code NOT IN (SELECT vfs.Code FROM [vetting].[VettingFundingSources] vfs);
            PRINT 'Vetting Funding Sources for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [VettingFundingSources] table.';
        COMMIT;
        DBCC CHECKIDENT ('[vetting].[VettingFundingSources]');
        PRINT 'END Vetting Funding Sources Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- ***********************************************************************************************************
        -- Generate new Vetting Funding Sources records for the Post in the [AgencyAtPostVettingFundingSources] table.
        -- ***********************************************************************************************************
        PRINT 'BEGIN Agency At Post Vetting Funding Sources Configuration for ' + @PostFullName + ' in ' +  @CountryName;
        SET @RecCnt = (SELECT COUNT(*) FROM [vetting].[AgencyAtPostAuthorizingLaws]);
        PRINT '[AgencyAtPostVettingFundingSources] Before Record Count = ' + CAST(@RecCnt AS NVARCHAR)        
        BEGIN TRANSACTION
            INSERT INTO [vetting].[AgencyAtPostVettingFundingSources]
                ([PostID], [VettingFundingSourceID], [IsActive], [ModifiedByAppUserID])
            SELECT @PostID, vf.VettingFundingSourceID, 1, @AppUserID
              FROM [migration].[OnboardingVettingFundingList] ol
              JOIN [vetting].[VettingFundingSources] vf ON vf.Code = ol.Code
             WHERE vf.IsActive = 1
               AND ol.Code NOT IN
                (SELECT vf.Code
                   FROM [vetting].[AgencyAtPostVettingFundingSources] a
                   JOIN [vetting].[VettingFundingSources] vf ON vf.VettingFundingSourceID = a.VettingFundingSourceID
                  WHERE a.PostID = @PostID);            
			PRINT 'Agency At Post Vetting Funding Sources for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [AgencyAtPostVettingFundingSources] table.';
		COMMIT;
        SET @RecCnt = (SELECT COUNT(*) FROM [vetting].[AgencyAtPostAuthorizingLaws]);
        PRINT '[AgencyAtPostVettingFundingSources] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);	
        PRINT 'END Agency At Post Vetting Funding Sources Configuration for ' + @PostFullName + ' in ' +  @CountryName;       
        PRINT '';

        -- *****************************************************************************************
        -- Import Vetting Authorizing Laws into the [AuthorizingLaws] table.
        -- *****************************************************************************************
        PRINT 'BEGIN Vetting Authorizing Laws Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[vetting].[AuthorizingLaws]');
        BEGIN TRANSACTION
            -- Insert new Vetting Authorizing Laws for the Onboarding Country.
            INSERT INTO [vetting].[AuthorizingLaws]
                ([Code], [Description], [IsActive], [ModifiedByAppUserID])        
            SELECT ol.Code, ol.Description, 1, @AppUserID
              FROM [migration].[OnboardingVettingAuthorizingLawsList] ol
             WHERE ol.Code NOT IN (SELECT al.Code FROM [vetting].[AuthorizingLaws] al);
            PRINT 'Vetting Funding Sources for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [VettingFundingSources] table.';
        COMMIT;
        DBCC CHECKIDENT ('[vetting].[AuthorizingLaws]');
        PRINT 'END Vetting Authorizing Laws Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- **********************************************************************************************
        -- Generate new Authorizing Laws records for the Post in the [AgencyAtPostAuthorizingLaws] table.
        -- **********************************************************************************************
        PRINT 'BEGIN Agency At Post Authorizing Laws Configuration for ' + @PostFullName + ' in ' +  @CountryName;
        SET @RecCnt = (SELECT COUNT(*) FROM [vetting].[AgencyAtPostAuthorizingLaws]);
        PRINT '[AgencyAtPostAuthorizingLaws] Before Record Count = ' + CAST(@RecCnt AS NVARCHAR)        
		BEGIN TRANSACTION             
            INSERT INTO [vetting].[AgencyAtPostAuthorizingLaws]
                ([PostID], [AuthorizingLawID], [IsActive], [ModifiedByAppUserID])
            SELECT @PostID, al.AuthorizingLawID, 1, @AppUserID
              FROM [migration].[OnboardingVettingAuthorizingLawsList] ol
              JOIN [vetting].[AuthorizingLaws] al ON al.Code = ol.Code
             WHERE al.IsActive = 1
               AND ol.Code NOT IN
                (SELECT al.Code
                   FROM [vetting].[AgencyAtPostAuthorizingLaws] a
                   JOIN [vetting].[AuthorizingLaws] al ON al.AuthorizingLawID = a.AuthorizingLawID
                  WHERE a.PostID = @PostID);
            PRINT 'Agency At Post Authorizing Laws for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [AgencyAtPostAuthorizingLaws] table.';
		COMMIT;
        SET @RecCnt = (SELECT COUNT(*) FROM [vetting].[AgencyAtPostAuthorizingLaws]);
        PRINT '[AgencyAtPostAuthorizingLaws] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);	
        PRINT 'END Agency At Post Authorizing Laws Configuration for ' + @PostFullName + ' in ' +  @CountryName;       
        PRINT '';

        -- ****************************************************************
        -- Import Key Activities & Programs into the [KeyActivities] table.
        -- ****************************************************************
        PRINT 'BEGIN Key Activities & Programs Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[training].[KeyActivities]');
        BEGIN TRANSACTION
            -- Insert new Key Activities & Programs for the Onboarding Country.
            INSERT INTO [training].[KeyActivities]
                ([Code], [Description], [IsActive], [ModifiedByAppUserID])        
            SELECT okal.Code, okal.Description, 1, @AppUserID
              FROM [migration].[OnboardingKeyActivitiesList] okal
             WHERE okal.Code NOT IN (SELECT ka.Code FROM [training].[KeyActivities] ka);          
            PRINT 'Key Activities & Programs for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [KeyActivities] table.';
        COMMIT;
        DBCC CHECKIDENT ('[training].[KeyActivities]');
        PRINT 'END Key Activities & Programs Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- ********************************************************************************************
        -- Generate new Key Activities At Post records for the Post in the [KeyActivitiesAtPost] table.
        -- ********************************************************************************************
        PRINT 'BEGIN Key Activities At Post Configuration for ' + @PostFullName + ' in ' +  @CountryName;
        SET @RecCnt = (SELECT COUNT(*) FROM [training].[KeyActivitiesAtPost]);      
        PRINT '[KeyActivitiesAtPost] Before Record Count = ' + CAST(@RecCnt AS NVARCHAR)        
        BEGIN TRANSACTION
            INSERT INTO [training].[KeyActivitiesAtPost]
                ([PostID], [KeyActivityID], [IsActive], [ModifiedByAppUserID])		
            SELECT @PostID, ka.KeyActivityID, 1, @AppUserID
              FROM [migration].[OnboardingKeyActivitiesList] okal
              JOIN [training].[KeyActivities] ka ON ka.Code = okal.Code
             WHERE ka.IsActive = 1 
               AND okal.Code NOT IN
                    (SELECT ka2.Code
                       FROM [training].[KeyActivitiesAtPost] kaap
                       JOIN [training].[KeyActivities] ka2 ON ka2.KeyActivityID = kaap.KeyActivityID
                       WHERE kaap.PostID = @PostID);
			PRINT 'Key Activities At Post for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [KeyActivitiesAtPost] table.';
        COMMIT;
        SET @RecCnt = (SELECT COUNT(*) FROM [training].[KeyActivitiesAtPost]);
        PRINT '[KeyActivitiesAtPost] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);	
        PRINT 'END Key Activities At Post Configuration for ' + @PostFullName + ' in ' +  @CountryName;       
        PRINT '';

        -- ********************************************************************
        -- Import Authorizing Documents into the [InterAgencyAgreements] table.
        -- ********************************************************************        
        PRINT 'BEGIN Authorizing Documents Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[training].[InterAgencyAgreements]');
        BEGIN TRANSACTION
            -- Insert new Authorizing Documents (InterAgencyAgreements or IAAs) for the Onboarding Country.
            INSERT INTO [training].[InterAgencyAgreements]
                ([Code], [Description], [IsActive], [ModifiedByAppUserID])        
            SELECT oadl.Code, oadl.Description, 1, @AppUserID
              FROM [migration].[OnboardingAuthorizingDocumentsList] oadl
             WHERE oadl.Code NOT IN (SELECT iaa.Code FROM [training].[InterAgencyAgreements] iaa);
            PRINT 'Authorizing Documents for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [InterAgencyAgreements] table.';
        COMMIT; 
        DBCC CHECKIDENT ('[training].[InterAgencyAgreements]');
        PRINT 'END Authorizing Documents Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- **********************************************************************************************************
        -- Generate new Authorizing Documents At Post records for the Post in the [AuthorizingDocumentsAtPost] table.
        -- **********************************************************************************************************
        PRINT 'BEGIN Authorizing Documents At Post Configuration for ' + @PostFullName + ' in ' +  @CountryName;
        SET @RecCnt = (SELECT COUNT(*) FROM [training].[AuthorizingDocumentsAtPost]);      
        PRINT '[AuthorizingDocumentsAtPost] Before Record Count = ' + CAST(@RecCnt AS NVARCHAR)        
        BEGIN TRANSACTION
            INSERT INTO [training].[AuthorizingDocumentsAtPost]
                ([PostID], [InterAgencyAgreementID], [IsActive], [ModifiedByAppUserID])		
            SELECT @PostID, iaa.InterAgencyAgreementID, 1, @AppUserID
              FROM [migration].[OnboardingAuthorizingDocumentsList] oadl
              JOIN [training].[InterAgencyAgreements] iaa ON iaa.Code = oadl.Code
             WHERE iaa.IsActive = 1 
               AND oadl.Code NOT IN
                    (SELECT iaa2.Code
                       FROM [training].[AuthorizingDocumentsAtPost] adap
                       JOIN [training].[InterAgencyAgreements] iaa2 ON iaa2.InterAgencyAgreementID = adap.InterAgencyAgreementID
                      WHERE adap.PostID = @PostID);
            PRINT 'Authorizing Documents At Post for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [AuthorizingDocumentsAtPost] table.';
		COMMIT;
        SET @RecCnt = (SELECT COUNT(*) FROM [training].[AuthorizingDocumentsAtPost]);
        PRINT '[AuthorizingDocumentsAtPost] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);	
        PRINT 'END Authorizing Documents At Post Configuration for ' + @PostFullName + ' in ' +  @CountryName;       
        PRINT '';

        -- ********************************************************************
        -- Import Training Event Funding Sources into the [ProjectCodes] table.
        -- ********************************************************************
        PRINT 'BEGIN Training Event Funding Sources Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[training].[ProjectCodes]');
        BEGIN TRANSACTION
            -- Insert new Training Event Funding Sources for the Onboarding Country.
            INSERT INTO [training].[ProjectCodes]
                ([Code], [Description], [IsActive], [ModifiedByAppUserID])        
            SELECT ol.Code, ol.Description, 1, @AppUserID
              FROM [migration].[OnboardingTrainingEventFundingSourcesList] ol
             WHERE ol.Code NOT IN (SELECT pc.Code FROM [training].[ProjectCodes] pc);
            PRINT 'Training Event Funding Sources for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [ProjectCodes] table.';
        COMMIT;   
        DBCC CHECKIDENT ('[training].[ProjectCodes]');
        PRINT 'END Training Event Funding Sources Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- *********************************************************************************************************
        -- Generate new Training Event Funding Sources records for the Post in the [AgencyAtPostProjectCodes] table.
        -- *********************************************************************************************************
        PRINT 'BEGIN Agency At Post Project Codes Configuration for ' + @PostFullName + ' in ' +  @CountryName;
        SET @RecCnt = (SELECT COUNT(*) FROM [training].[AgencyAtPostProjectCodes]);
        PRINT '[AgencyAtPostProjectCodes] Before Record Count = ' + CAST(@RecCnt AS NVARCHAR);        
        BEGIN TRANSACTION
            INSERT INTO [training].[AgencyAtPostProjectCodes]
                ([PostID], [ProjectCodeID], [IsActive], [ModifiedByAppUserID])
            SELECT @PostID, pc.ProjectCodeID, 1, @AppUserID
              FROM [migration].[OnboardingTrainingEventFundingSourcesList] ol
              JOIN [training].ProjectCodes pc ON pc.Code = ol.Code
             WHERE pc.IsActive = 1
               AND ol.Code NOT IN 
                    (SELECT pc.Code
                       FROM [training].[AgencyAtPostProjectCodes] a
                       JOIN [training].[ProjectCodes] pc ON pc.ProjectCodeID = a.ProjectCodeID
                      WHERE a.PostID = @PostID);
            PRINT 'Agency At Post Project Codes for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [AgencyAtPostProjectCodes] table.';
		COMMIT;
        SET @RecCnt = (SELECT COUNT(*) FROM [training].[AgencyAtPostProjectCodes]);
        PRINT '[AgencyAtPostProjectCodes] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);		
        PRINT 'END Agency At Post Project Codes Configuration for ' + @PostFullName + ' in ' +  @CountryName;       
        PRINT '';

        -- ***************************************************************************
        -- Import Post Configuration Values into the [PostVettingConfiguration] table.
        -- ***************************************************************************
        PRINT 'BEGIN Post Configuration Values Import for ' + @PostFullName + ' in ' +  @CountryName;
        BEGIN TRANSACTION
            IF (NOT EXISTS(SELECT * 
                             FROM [vetting].[PostVettingConfiguration] pvc
                            WHERE pvc.PostID = @PostID))         
                -- No Post Configuration Values exist for the Onboarding Country.
                BEGIN
                    -- Insert new Post Configuration Values for the Onboarding Country.
                    INSERT INTO [vetting].[PostVettingConfiguration]
                        ([PostID], 
                         [MaxBatchSize], 
                         [LeahyBatchLeadTime], 
                         [CourtesyBatchLeadTime], 
                         [CourtesyCheckTimeFrame], 
                         [CloseOutNotificiationsTime], 
                         [POL_POC_Email], 
                         [ModifiedByAppUserID])
                    SELECT @PostID, 
                           opcv.VettingBatchSize, 
                           opcv.LeahyVettingTime, 
                           opcv.CourtesyVettingTime, 
                           opcv.CourtesyNameCheckTime, 
                           opcv.CloseOutNotificiationsTime, 
                           opcv.POL_POC_Email, 
                           @AppUserID			
                      FROM [migration].[OnboardingPostConfigurationValues] opcv
                     WHERE @PostID NOT IN (SELECT pvc.PostID FROM [vetting].[PostVettingConfiguration] pvc WHERE pvc.PostID = @PostID);			 
                    PRINT 'Post Configuration Values for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [PostVettingConfiguration] table.';
                END;
        COMMIT;
        PRINT 'END Post Configuration Values Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

		-- ********************************************
        -- Configure Country-level Unit Library record.
        -- ********************************************
        PRINT 'BEGIN Unit Library Country record configuration for ' + @PostFullName + ' in ' +  @CountryName;
        BEGIN TRANSACTION
            IF (NOT EXISTS(SELECT * 
                         FROM [unitlibrary].[Units] u
                        WHERE u.CountryID = @CountryID))         
                -- No Unit Library records exist for the Onboarding Country.
			    BEGIN
                    -- Insert new Country-level Unit Library record for the Onboarding Country.
                    INSERT INTO [unitlibrary].[Units]
                        ([CountryID],				-- @AppUserID
                         [UnitName],				-- @CountryName
                         [UnitNameEnglish],			-- @CountryName
                         [IsMainAgency],			-- TRUE (1)
                         [UnitAcronym],				-- @CountryCodeA3
                         [UnitGenID],				-- @CountryCodeA3 + '00001'
                         [UnitTypeID],				-- Government (2)
                         [GovtLevelID],				-- Country (1)
                         [VettingBatchTypeID],		-- N/A, No vetting required (3)
                         [VettingActivityTypeID],	-- N/A, Not Applicable (4)
                         [IsActive],				-- TRUE (1)
                         [ModifiedByAppUserID])		-- @AppUserID (2) = ONBOARDING
                    VALUES
                        (@CountryID,                -- @AppUserID
                         @CountryName,              -- @CountryName
                         @CountryName,              -- @CountryName
                         1,                         -- TRUE (1)
                         @CountryCodeA3,            -- @CountryCodeA3
                         @CountryCodeA3 + '00001',  -- @CountryCodeA3 + '00001'
                         2,                         -- Government (2)
                         1,                         -- Country (1)
                         3,                         -- N/A, No vetting required (3)
                         4,                         -- N/A, Not Applicable (4)
                         1,                         -- TRUE (1)
                         @AppUserID);               -- @AppUserID (2) = ONBOARDING
				    PRINT 'Country-level Unit Library record for ' + @PostFullName + ' in ' +  @CountryName + ' was inserted into [Units] table.';
			    END;
        COMMIT;
        PRINT 'END Unit Library Country record configuration for ' + @PostFullName + ' in ' +  @CountryName;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH;

    PRINT '';
	SET @EndTime = SYSUTCDATETIME();
    SET @Text = 'Country Onboarding Data Load Process for ' + @PostFullName + ' in ' +  @CountryName + ' has FINISHED (' + CAST(@EndTime AS NVARCHAR) + ')';
	PRINT REPLICATE('=', LEN(TRIM(@Text)));
    PRINT @Text;
	PRINT 'Elapsed Time = ' + CAST(DATEDIFF_BIG(ms, @StartTime, @EndTime) AS NVARCHAR) + ' milliseconds';
    PRINT REPLICATE('=', LEN(TRIM(@Text)));

	SET NOCOUNT OFF;
END;