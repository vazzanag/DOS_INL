/*
    NAME:   Onboarding Data Load Script
    
    DESCR:  Load data provided by the New Post Onboarding User Data Forms template file 
            received from Colombia into the different GTTS database tabless.

    NOTES:  Before running this script:
    
                1) Load all of the Onboarding template values into the appropriate Onboarding...List Excel files.
                
                2) Using the SSMS Import Data... tool, import the Onboarding...List Excel files into their 
                   corresponding [migraton] schema tables as listed below:

                   Excel Import File                                  INLDB [migration]. Table
                   ==============================================     =========================================
                   OnboardingAuthorizingDocumentsList.xlsx        ==> OnboardingAuthorizingDocumentsList
                   OnboardingCitiesList.xlsx                      ==> OnboardingCitiesList
                   OnboardingKeyActivitiesList.xlsx               ==> OnboardingKeyActivitiesList
                   OnboardingPostConfigurationValues.xlsx         ==> OnboardingPostConfigurationValues
                   OnboardingRanksList.xlsx                       ==> OnboardingRanksList
                   OnboardingStatesList.xlsx                      ==> OnboardingStatesList.xlsx
                   OnboardingTrainingEventFundingSourcesList.xlsx ==> OnboardingTrainingEventFundingSourcesList
                   OnboardingUsersList.xlsx                       ==> OnboardingUsersList
                   OnboardingVettingAuthorizingLawsList.xlsx      ==> OnboardingVettingAuthorizingLawsList
                   OnboardingVettingFundingList.xlsx              ==> OnboardingVettingFundingList
    
                3) Configure the @CountryID variable with the correct CountryID for the Country being onboarded.

    ONBOARDING LOG:     COUNTRY NAME        COUNTRY ID      DATE LOADED INTO GTTS
                        Colombia            2053            
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
    DECLARE @CountryID AS INT = 2053;

    -- ******************************************************
    -- Initialize local variables for use within this script.
    -- ******************************************************
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

    SET @Text = 'Country Onboarding Data Load Process for ' + @PostFullName + ' in ' +  @CountryName + ' has STARTED';
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
        IF (NOT EXISTS(SELECT * 
				         FROM [location].[States] s 
				        WHERE s.CountryID = @CountryID AND s.StateName <> 'Unknown'))
            -- No States exist for the Onboarding Country that are not an 'Unknown' State.
            BEGIN
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
                -- Test if an 'Unknown' State record exists for the Onboarding Country.
                -- If not, create one.
				IF (NOT EXISTS(SELECT *
								 FROM [location].[States] s
								WHERE s.CountryID = @CountryID AND s.StateName = 'Unknown'))
					-- 'Unknown' State does not exist.  Create 'Unknown' State.
					BEGIN
						PRINT 'Unknown State does not exist for ' + @CountryName + '.';
                        INSERT INTO [location].[States]
                                    ([StateName],
                                     [StateCodeA2], 
                                     [Abbreviation], 
                                     [CountryID], 
                                     [IsActive], 
                                     [ModifiedByAppUserID])
                        VALUES ('Unknown', 'UK' , 'UNK', @CountryID, 1, @AppUserID);
                        PRINT 'Unknown State created for ' + @CountryName + '.';
					END
				ELSE
					-- 'Unknown' State does exists.  Do nothing.                
					BEGIN
						PRINT 'Unknown State already exists for ' + @CountryName + '.';
					END;
            END;
        DBCC CHECKIDENT ('[location].[States]');
        PRINT 'END States Import for ' + @CountryName;
        PRINT '';

        -- ****************************************************
        -- Import Cities into the [Cities] table.
        -- ****************************************************
        PRINT 'BEGIN Cities Import for ' + @CountryName;
        DBCC CHECKIDENT ('[location].[Cities]');
        IF (NOT EXISTS(SELECT * 
                         FROM [location].[Cities] c
                         JOIN [location].[States] s ON s.StateID = c.StateID
                        WHERE s.CountryID = @CountryID AND c.CityName <> 'Unknown'))         
           -- No Cities exist for the Onboarding Country that are not an 'Unknown' City.
            BEGIN
                -- Insert new Cities for Onboarding Country that were previously imported
                -- into the [migration].[LoadOnboardingCities] table.
                INSERT INTO [location].[Cities]
                        ([CityName], [StateID], [IsActive], [ModifiedByAppUserID]) 
                SELECT ol.CityName, s.StateID, 1, @AppUserID
                  FROM [migration].[OnboardingCitiesList] ol
                  JOIN [location].[States] s ON s.StateName = ol.StateName;
                PRINT 'Cities for ' + @CountryName + ' inserted into [Cities] table.';
                -- Test if 'Unknown' City records exist for each of the States previously 
                -- created for the the Onboarding Country.  If not, create them.
                IF (NOT EXISTS(SELECT * 
				                 FROM [location].[Cities] c
				                 JOIN [location].[States] s ON s.StateID = c.StateID
				                WHERE s.CountryID = @CountryID 
				                  AND s.StateName <> 'Unknown'
				                  AND c.CityName = 'Unknown'))
                    -- 'Unknown' Cities for the States in the Onboarding Country do not
                    -- exist.  Create 'Unknown' Cities for the States in the Onboarding 
                    -- Country.
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
					-- 'Unknown' State does exists.  Do nothing.                   
					BEGIN
						PRINT 'Unknown Cities already exist for ' + @CountryName + '.';
					END;
            END;
        DBCC CHECKIDENT ('[location].[Cities]');
        PRINT 'END Cities Import for ' + @CountryName;
        PRINT '';

        -- *****************************************************
        -- Import Business Units into the [BusinessUnits] table.
        -- *****************************************************
        PRINT 'BEGIN Business Units Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[users].[BusinessUnits]');
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
						  WHERE bu.PostID = @PostID) 
                PRINT 'Business Units for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [BusinessUnits] table.';
            END;
        DBCC CHECKIDENT ('[users].[BusinessUnits]');
        PRINT 'END Business Units Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- **************************************************************************
        -- Import GTTS Users, into the [AppUsers] table.
        -- Users are matched on 'ONBOARDING-' + ol.EmailAddress = [AppUsers].[ADOID].  
        -- **************************************************************************    
        PRINT 'BEGIN Users Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[users].[AppUsers]');
        BEGIN
            -- Insert new Users for the Onboarding Post/Country.
            -- Users are matched on 'ONBOARDING-' + ol.EmailAddress = [AppUsers].[ADOID].
            INSERT INTO [users].[AppUsers]
                ([ADOID], [First], [Last], [EmailAddress], [CountryID], [PostID], [ModifiedByAppUserID])			
            SELECT 'ONBOARDING-' + ol.EmailAddress, ol.FirstName, ol.LastName, ol.EmailAddress, @CountryID, @PostID, @AppUserID
              FROM [migration].[OnboardingUsersList] ol
             WHERE 'ONBOARDING-' + ol.EmailAddress NOT IN 			 
                    (SELECT au.ADOID
                       FROM [migration].[OnboardingUsersList] ol
                       JOIN [users].[AppUsers] au ON au.ADOID = 'ONBOARDING-' + ol.EmailAddress)
            PRINT 'Users for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [AppUsers] table.';
        END
        DBCC CHECKIDENT ('[users].[AppUsers]');     
        PRINT 'END Users Import for ' + @PostFullName + ' in ' +  @CountryName;        
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
        BEGIN
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
                      WHERE ar.Name = ol.Role))
            PRINT 'Users Roles assigned to Users for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [AppUserRoles] table.';
        END
        SET @RecCnt = (SELECT COUNT(*) FROM [users].[AppUserRoles]);
        PRINT '[AppUserRoles] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);         
        PRINT 'END User Roles Import for ' + @PostFullName + ' in ' +  @CountryName;   
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
        BEGIN
            -- Insert new User Business Unit assignments for the new Users in the Onboarding Post/Country.
            INSERT INTO [users].[AppUserBusinessUnits]
                ([AppUserID] ,[BusinessUnitID] ,[DefaultBusinessUnit] ,[ModifiedByAppUserID])
		    SELECT au.AppUserID, bu.BusinessUnitID, 1, @AppUserID
              FROM [migration].[OnboardingUsersList] ol
              JOIN [users].[AppUsers] au ON au.ADOID = 'ONBOARDING-' + ol.EmailAddress
		      JOIN [users].[BusinessUnits] bu ON bu.BusinessUnitName = ol.BusinessUnit
             WHERE ('ONBOARDING-' + ol.EmailAddress NOT IN
                    (SELECT au.ADOID
                       FROM [users].[AppUserBusinessUnits] abu
                       JOIN [users].[AppUsers] au ON au.AppUserID = abu.AppUserID))
                OR ('ONBOARDING-' + ol.EmailAddress NOT IN
                    (SELECT au.ADOID
                       FROM [users].[AppUserBusinessUnits] abu
                       JOIN [users].[AppUsers] au ON au.AppUserID = abu.AppUserID
                       JOIN [users].[BusinessUnits] bu ON bu.BusinessUnitID = abu.BusinessUnitID
                       JOIN [migration].[OnboardingUsersList] ol ON au.ADOID = 'ONBOARDING-' + ol.EmailAddress
                      WHERE bu.BusinessUnitName = ol.BusinessUnit))
            PRINT 'User Business Unit Assignments for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [AppUserBusinessUnits] table.';
        END
        SET @RecCnt = (SELECT COUNT(*) FROM [users].[AppUserBusinessUnits]);
        PRINT '[AppUserBusinessUnits] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);        
        PRINT 'END User Business Units Import for ' + @PostFullName + ' in ' +  @CountryName; 
        PRINT '';

        -- *****************************************************
        -- Import Ranks into the [Ranks] table.
        -- *****************************************************
        PRINT 'BEGIN Ranks Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[persons].[Ranks]');
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
						  WHERE r.CountryID = @CountryID)
                PRINT 'Ranks for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [Ranks] table.';
            END;
        DBCC CHECKIDENT ('[persons].[Ranks]');
        PRINT 'END Ranks Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';






        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- Add new Vetting Types from Post that don't already exist.
        -- NOTE: Colombia only does POL Vetting and does this outside
        --       of GTTS.  Table already contains this Vetting Type.  
        -- ************************************************************
        PRINT 'BEGIN Vetting Types Configuration for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[vetting].[VettingTypes]');
        -- **** NEED TO CREATE THE UPLOAD FILE, UPLOAD TABLE & ADD    ****
        -- **** NEW CODE HERE TO READ, MATCH, & IMPORT THE ONBOARDING ****
        -- **** DATA INTO THE DATABASE FOR THE ONBOARDING COUNTRY.    **** 
        PRINT 'Political (POL) Vetting Type already exists.'
        DBCC CHECKIDENT ('[vetting].[VettingTypes]');
        PRINT 'END Vetting Types Configuration for ' + @PostFullName + ' in ' +  @CountryName;        
        PRINT '';

        -- ************************************************************
        -- Configure specific Vetting Types for the Post.
        -- NOTE: Colombia only does POL Vetting at this time.  This 
        -- value is currently hard-coded in the following code block.          
        -- ************************************************************
        PRINT 'BEGIN Vetting At Post Configuration for ' + @PostFullName + ' in ' +  @CountryName;
        SET @RecCnt = (SELECT COUNT(*) FROM [vetting].[PostVettingTypes]);
        -- **** NEED TO CREATE THE UPLOAD FILE, UPLOAD TABLE & ADD    ****
        -- **** NEW CODE HERE TO READ, MATCH, & IMPORT THE ONBOARDING ****
        -- **** DATA INTO THE DATABASE FOR THE ONBOARDING COUNTRY.    ****         
        PRINT '[PostVettingTypes] Before Record Count = ' + CAST(@RecCnt AS NVARCHAR);
        IF (NOT EXISTS(SELECT * 
                         FROM [vetting].[PostVettingTypes] pvt
                        WHERE pvt.PostID = @PostID))         
           -- No Post-specific Vetting Types exist for the Onboarding Country.
            BEGIN
                -- Insert new Post-specific Vetting Types for the Onboarding Country.
				INSERT INTO [vetting].[PostVettingTypes]
					([PostID], 
					 [VettingTypeID], 
					 [IsActive], 
					 [ModifiedByAppUserID])
                VALUES
                    (@PostID, 
					 1,			-- Political (POL)
					 1, 
					 @AppUserID);
                PRINT 'Post Vetting Types for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [PostVettingTypes] table.';
            END;
        SET @RecCnt = (SELECT COUNT(*) FROM [vetting].[PostVettingTypes]);
        PRINT '[PostVettingTypes] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);
        PRINT 'END Vetting At Post Configuration for ' + @PostFullName + ' in ' +  @CountryName;        
        PRINT '';
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************
        -- ************************************************************






        -- *****************************************************************************************
        -- Import Vetting Funding Sources into the [VettingFundingSources] table.
        -- *****************************************************************************************
        PRINT 'BEGIN Vetting Funding Sources Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[vetting].[VettingFundingSources]');
        BEGIN
            -- Insert new Vetting Funding Sources for the Onboarding Country.
            INSERT INTO [vetting].[VettingFundingSources]
                    ([Code], [Description], [IsActive], [ModifiedByAppUserID])        
            SELECT ol.Code, ol.Description, 1, @AppUserID
              FROM [migration].[OnboardingVettingFundingList] ol
             WHERE ol.Code NOT IN (SELECT vfs.Code FROM [vetting].[VettingFundingSources] vfs);
            PRINT 'Vetting Funding Sources for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [VettingFundingSources] table.';
        END
        DBCC CHECKIDENT ('[vetting].[VettingFundingSources]');
        PRINT 'END Vetting Funding Sources Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- ***********************************************************************************************************
        -- Generate new Vetting Funding Sources records for the Post in the [AgencyAtPostVettingFundingSources] table.
        -- ***********************************************************************************************************
        PRINT 'BEGIN Agency At Post Vetting Funding Sources Configuration for ' + @PostFullName + ' in ' +  @CountryName;
        SET @RecCnt = (SELECT COUNT(*) FROM [vetting].[AgencyAtPostAuthorizingLaws]);
        PRINT '[AgencyAtPostVettingFundingSources] Before Record Count = ' + CAST(@RecCnt AS NVARCHAR)        
		BEGIN
			INSERT INTO [vetting].[AgencyAtPostVettingFundingSources]
					([PostID], [VettingFundingSourceID], [IsActive], [ModifiedByAppUserID])
			SELECT @PostID, vf.VettingFundingSourceID, 1, @AppUserID
			  FROM [migration].[OnboardingVettingFundingList] ol
			  JOIN [vetting].[VettingFundingSources] vf ON vf.Code = ol.Code
			 WHERE ol.Code NOT IN
					(SELECT vf.Code
					   FROM [vetting].[AgencyAtPostVettingFundingSources] a
					   JOIN [vetting].[VettingFundingSources] vf ON vf.VettingFundingSourceID = a.VettingFundingSourceID);
			PRINT 'Agency At Post Vetting Funding Sources for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [AgencyAtPostVettingFundingSources] table.';
		END
        SET @RecCnt = (SELECT COUNT(*) FROM [vetting].[AgencyAtPostAuthorizingLaws]);
        PRINT '[AgencyAtPostVettingFundingSources] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);	
        PRINT 'END Agency At Post Vetting Funding Sources Configuration for ' + @PostFullName + ' in ' +  @CountryName;       
        PRINT '';

        -- *****************************************************************************************
        -- Import Vetting Authorizing Laws into the [AuthorizingLaws] table.
        -- *****************************************************************************************
        PRINT 'BEGIN Vetting Authorizing Laws Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[vetting].[AuthorizingLaws]');
        BEGIN
            -- Insert new Vetting Authorizing Laws for the Onboarding Country.
            INSERT INTO [vetting].[AuthorizingLaws]
                    ([Code], [Description], [IsActive], [ModifiedByAppUserID])        
            SELECT ol.Code, ol.Description, 1, @AppUserID
              FROM [migration].[OnboardingVettingAuthorizingLawsList] ol
             WHERE ol.Code NOT IN (SELECT al.Code FROM [vetting].[AuthorizingLaws] al);
            PRINT 'Vetting Funding Sources for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [VettingFundingSources] table.';
        END
        DBCC CHECKIDENT ('[vetting].[AuthorizingLaws]');
        PRINT 'END Vetting Authorizing Laws Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- **********************************************************************************************
        -- Generate new Authorizing Laws records for the Post in the [AgencyAtPostAuthorizingLaws] table.
        -- **********************************************************************************************
        PRINT 'BEGIN Agency At Post Authorizing Laws Configuration for ' + @PostFullName + ' in ' +  @CountryName;
        SET @RecCnt = (SELECT COUNT(*) FROM [vetting].[AgencyAtPostAuthorizingLaws]);
        PRINT '[AgencyAtPostAuthorizingLaws] Before Record Count = ' + CAST(@RecCnt AS NVARCHAR)        
		BEGIN
			INSERT INTO [vetting].[AgencyAtPostAuthorizingLaws]
					([PostID], [AuthorizingLawID], [IsActive], [ModifiedByAppUserID])
			SELECT @PostID, al.AuthorizingLawID, 1, @AppUserID
			  FROM [migration].[OnboardingVettingAuthorizingLawsList] ol
			  JOIN [vetting].[AuthorizingLaws] al ON al.Code = ol.Code
			 WHERE ol.Code NOT IN
					(SELECT al.Code
					   FROM [vetting].[AgencyAtPostAuthorizingLaws] a
					   JOIN [vetting].[AuthorizingLaws] al ON al.AuthorizingLawID = a.AuthorizingLawID);
			PRINT 'Agency At Post Authorizing Laws for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [AgencyAtPostAuthorizingLaws] table.';
		END
        SET @RecCnt = (SELECT COUNT(*) FROM [vetting].[AgencyAtPostAuthorizingLaws]);
        PRINT '[AgencyAtPostAuthorizingLaws] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);	
        PRINT 'END Agency At Post Authorizing Laws Configuration for ' + @PostFullName + ' in ' +  @CountryName;       
        PRINT '';

        -- *****************************************************************************************
        -- Import Key Activities & Programs into the [KeyActivities] table.
        -- *****************************************************************************************
        PRINT 'BEGIN Key Activities & Programs Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[training].[KeyActivities]');
        BEGIN
            -- Insert new Key Activities & Programs for the Onboarding Country.
            INSERT INTO [training].[KeyActivities]
                    ([Code], [Description], [IsActive], [ModifiedByAppUserID])        
            SELECT ol.Code, ol.Description, 1, @AppUserID
              FROM [migration].[OnboardingKeyActivitiesList] ol
             WHERE ol.Code NOT IN (SELECT ka.Code FROM [training].[KeyActivities] ka);
            PRINT 'Key Activities & Programs for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [KeyActivities] table.';
        END
        DBCC CHECKIDENT ('[training].[KeyActivities]');
        PRINT 'END Key Activities & Programs Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- ****************************************************
        -- KeyActivitiesAtPost
        -- Table does not exist.  Needs to be created.
        -- ****************************************************
        PRINT 'BEGIN Agency At Post Key Activities Configuration for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '  TBD ==> [KeyActivitiesAtPost] table does not exist at this time.'
        PRINT 'END Agency At Post Key Activities Configuration for ' + @PostFullName + ' in ' +  @CountryName;       
        PRINT '';

        -- *****************************************************************************************
        -- Import Authorizing Documents into the [InterAgencyAgreements] table.
        -- *****************************************************************************************        
        PRINT 'BEGIN Authorizing Documents Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[training].[InterAgencyAgreements]');
		BEGIN
			-- Insert new Authorizing Documents (InterAgencyAgreements or IAAs) for the Onboarding Country.
			INSERT INTO [training].[InterAgencyAgreements]
					([Code], [Description], [IsActive], [ModifiedByAppUserID])        
			SELECT ol.Code, ol.Description, 1, @AppUserID
			  FROM [migration].[OnboardingAuthorizingDocumentsList] ol
			 WHERE ol.Code NOT IN (SELECT iaa.Code FROM [training].[InterAgencyAgreements] iaa);
			PRINT 'Authorizing Documents for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [InterAgencyAgreements] table.';
        END  
        DBCC CHECKIDENT ('[training].[InterAgencyAgreements]');
        PRINT 'END Authorizing Documents Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- ****************************************************
        -- AgencyAtPostAuthorizingDocuments
        -- Table does not exist.  Needs to be created.
        -- ****************************************************
        PRINT 'BEGIN Agency At Post Authorizing Documents Configuration for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '  TBD ==> [AgencyAtPostAuthorizingDocuments] table does not exist at this time.'
        PRINT 'END Agency At Post Authorizing Documents Configuration for ' + @PostFullName + ' in ' +  @CountryName;       
        PRINT '';

        -- *****************************************************************************************
        -- Import Training Event Funding Sources into the [ProjectCodes] table.
        -- *****************************************************************************************
        PRINT 'BEGIN Training Event Funding Sources Import for ' + @PostFullName + ' in ' +  @CountryName;
        DBCC CHECKIDENT ('[training].[ProjectCodes]');
        BEGIN
			-- Insert new Training Event Funding Sources for the Onboarding Country.
			INSERT INTO [training].[ProjectCodes]
					([Code], [Description], [IsActive], [ModifiedByAppUserID])        
			SELECT ol.Code, ol.Description, 1, @AppUserID
			  FROM [migration].[OnboardingTrainingEventFundingSourcesList] ol
			 WHERE ol.Code NOT IN (SELECT pc.Code FROM [training].[ProjectCodes] pc);
			PRINT 'Training Event Funding Sources for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [ProjectCodes] table.';
        END    
        DBCC CHECKIDENT ('[training].[ProjectCodes]');
        PRINT 'END Training Event Funding Sources Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

        -- *********************************************************************************************************
        -- Generate new Training Event Funding Sources records for the Post in the [AgencyAtPostProjectCodes] table.
        -- *********************************************************************************************************
        PRINT 'BEGIN Agency At Post Project Codes Configuration for ' + @PostFullName + ' in ' +  @CountryName;
        SET @RecCnt = (SELECT COUNT(*) FROM [training].[AgencyAtPostProjectCodes]);
        PRINT '[AgencyAtPostProjectCodes] Before Record Count = ' + CAST(@RecCnt AS NVARCHAR);        
		BEGIN
			INSERT INTO [training].[AgencyAtPostProjectCodes]
					([PostID], [ProjectCodeID], [IsActive], [ModifiedByAppUserID])
			SELECT @PostID, pc.ProjectCodeID, 1, @AppUserID
			  FROM [migration].[OnboardingTrainingEventFundingSourcesList] ol
			  JOIN [training].ProjectCodes pc ON pc.Code = ol.Code
			 WHERE ol.Code NOT IN 
						(SELECT pc.Code
						   FROM [training].[AgencyAtPostProjectCodes] a
						   JOIN [training].[ProjectCodes] pc ON pc.ProjectCodeID = a.ProjectCodeID);
			PRINT 'Agency At Post Project Codes for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [AgencyAtPostProjectCodes] table.';
		END
        SET @RecCnt = (SELECT COUNT(*) FROM [training].[AgencyAtPostProjectCodes]);
        PRINT '[AgencyAtPostProjectCodes] After Record Count = ' + CAST(@RecCnt AS NVARCHAR);		
        PRINT 'END Agency At Post Project Codes Configuration for ' + @PostFullName + ' in ' +  @CountryName;       
        PRINT '';

        -- ***************************************************************************
        -- Import Post Configuration Values into the [PostVettingConfiguration] table.
        -- ***************************************************************************
        PRINT 'BEGIN Post Configuration Values Import for ' + @PostFullName + ' in ' +  @CountryName;
        IF (NOT EXISTS(SELECT * 
                         FROM [vetting].[PostVettingConfiguration] pvc
                        WHERE pvc.PostID = @PostID))         
           -- No Post Configuration Values exist for the Onboarding Country.
            BEGIN
                -- Insert new Post Configuration Values for the Onboarding Country.
                INSERT INTO [vetting].[PostVettingConfiguration]
                   ([PostID], [MaxBatchSize], [LeahyBatchLeadTime], [CourtesyBatchLeadTime], [ModifiedByAppUserID])
				SELECT @PostID, opcv.MaxBatchSize, opcv.LeahyBatchLeadTime, opcv.CourtesyBatchLeadTime, @AppUserID			
				  FROM [migration].[OnboardingPostConfigurationValues] opcv
				 WHERE @PostID NOT IN (SELECT pvc.PostID FROM [vetting].[PostVettingConfiguration] pvc WHERE pvc.PostID = @PostID)			 
				PRINT 'Post Configuration Values for ' + @PostFullName + ' in ' +  @CountryName + ' inserted into [PostVettingConfiguration] table.';
            END;
        PRINT 'END Post Configuration Values Import for ' + @PostFullName + ' in ' +  @CountryName;
        PRINT '';

		-- ********************************************
        -- Configure Country-level Unit Library record.
        -- ********************************************
        PRINT 'BEGIN Unit Library Country record configuration for ' + @PostFullName + ' in ' +  @CountryName;
        IF (NOT EXISTS(SELECT * 
                         FROM [unitlibrary].[Units] u
                        WHERE u.CountryID = @CountryID))         
           -- No Unit Library records exist for the Onboarding Country.
			BEGIN
                -- Insert new Country-level Unit Library record for the Onboarding Country.
				INSERT INTO [unitlibrary].[Units]
                   ([CountryID],				-- @AppUserID
					[UnitName],					-- @CountryName
					[UnitNameEnglish],			-- @CountryName
					[IsMainAgency],				-- TRUE (1)
 					[UnitAcronym],				-- @CountryCodeA3
					[UnitGenID],				-- @CountryCodeA3 + '00001'
 					[UnitTypeID],				-- Government (2)
					[GovtLevelID],				-- Country (1)
					[VettingBatchTypeID],		-- N/A, No vetting required (3)
					[VettingActivityTypeID],	-- N/A, Not Applicable (4)
					[IsActive],					-- TRUE (1)
					[ModifiedByAppUserID])		-- @AppUserID (2) = ONBOARDING
				VALUES
					(@CountryID, @CountryName, @CountryName, 1, @CountryCodeA3, @CountryCodeA3 + '00001', 2, 1, 3, 4, 1,  @AppUserID)		 
				PRINT 'Country-level Unit Library record for ' + @PostFullName + ' in ' +  @CountryName + ' was inserted into [Units] table.';
			END;
        PRINT 'END Unit Library Country record configuration for ' + @PostFullName + ' in ' +  @CountryName;


        -- NO ERRORS, COMMIT
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH;

    PRINT '';
    SET @Text = 'Country Onboarding Data Load Process for ' + @PostFullName + ' in ' +  @CountryName + ' has FINISHED';
    PRINT REPLICATE('=', LEN(TRIM(@Text)));
    PRINT @Text;
    PRINT REPLICATE('=', LEN(TRIM(@Text)));

	SET NOCOUNT OFF;
END;