/*
    NAME:   ReverseLookupTrainingEventValues
    
    DESCR:  This Stored Procedure will perform reverse lookups on [NewPostTrainingEvents] table 
            values that were uploaded from the Training Event template file being processed
            (identified by the @NewPostImportID parameter being passed in).  The results of the
            reverse lookup are then written back to the referenced record.  Any input value
            that was not matched into the GTTS DB, will have a "NULL" string value returned.
            This allows for the identification/reporting of unprocessed data in the 
            [NewPostImportExceptions] table.          
*/
CREATE PROCEDURE [migration].[ReverseLookupTrainingEventValues]
    @NewPostImportID BIGINT = NULL	-- ID value that points to the [NewPostImportLog] record 
									-- for the template file that this Training Event was 
                                    -- submitted in.
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- Define local variables used in this SP.
		DECLARE @intCountryID AS INT = NULL;
		DECLARE @intPostID AS INT = NULL;
        DECLARE @strTrainingUnitName AS NVARCHAR(500) = NULL;
		DECLARE @intUnitID AS BIGINT = NULL;   
		DECLARE @strUnitLibraryAcronym AS NVARCHAR(32) = NULL;
		DECLARE @blnIsTrainingUnitInUnitLibrary AS BIT = NULL;
		DECLARE @intBusinessUnitID AS BIGINT = NULL;
		DECLARE @blnIsTrainingUnitInBusinessUnits AS BIT = NULL;
		DECLARE @strAcronym AS NVARCHAR(32) = NULL;  
        DECLARE @strOrganizerNames AS NVARCHAR(1000) = NULL;
        DECLARE @strOrganizerIDs AS NVARCHAR(300) = NULL;
        DECLARE @strEventTypeName AS NVARCHAR(100) = NULL;
        DECLARE @intEventTypeID AS INT = NULL;
        DECLARE @strKeyActitityNames AS NVARCHAR(1000) = NULL;
        DECLARE @strKeyActitityIDs AS NVARCHAR(300) = NULL;
        DECLARE @strFundingSourceNames AS NVARCHAR(1000) = NULL;
        DECLARE @strFundingSourceIDs AS NVARCHAR(300) = NULL;
        DECLARE @strAuthorizingDocNames AS NVARCHAR(1000) = NULL;
        DECLARE @strAuthorizingDocIDs AS NVARCHAR(300) = NULL;
        DECLARE @strImplementPartnerNames AS NVARCHAR(1000) = NULL;
        DECLARE @strPartnerIDsStage1 AS NVARCHAR(300) = NULL;
        DECLARE @strImplementPartnerIDs AS NVARCHAR(300) = NULL;        

		-- Get CountryID & Post ID values from [NewPostImportLog] table.
		SELECT @intCountryID = npil.[CountryID],
			   @intPostID = npil.[PostID]
		FROM [migration].[NewPostImportLog] npil
		WHERE npil.[NewPostImportID] = @NewPostImportID;

        -- Get values to look up.
        SELECT 
            @strTrainingUnitName = te.OfficeOrSection,
            @strOrganizerNames = te.OrganizerNames,
            @strEventTypeName = te.EventType,
            @strKeyActitityNames = te.KeyActivities,
            @strFundingSourceNames = te.FundingSources,
            @strAuthorizingDocNames = te.AuthorizingDocuments,
            @strImplementPartnerNames = te.ImplementingPartners
        FROM [migration].[NewPostTrainingEvents] te
        WHERE te.NewPostImportID = @NewPostImportID;

        -- Reverse lookup for OfficeOrSection.
		-- This is a multi-step process in order to validate the Training Unit Name (OfficeOrSection)
		-- against the Unit Library ([Units] table) and Business Units at the Post ([BusinessUnits] table).
		-- If the Training Unit was not found in the [BusinessUnits] table, it is automatically added.
		-- Determine if OfficeOrSection (@TrainingUnitName) exists in the Unit Library & get the UnitID value if it does.
		SELECT @intUnitID = NULLIF(u.[UnitID], 0),
			   @strUnitLibraryAcronym = NULLIF(u.UnitAcronym, '')
		  FROM [unitlibrary].[Units] u
		 WHERE u.[CountryID] = 2254 
		   AND (u.[UnitName] = @strTrainingUnitName OR u.[UnitNameEnglish] = @strTrainingUnitName)

		-- Set value of @blnIsTrainingUnitInUnitLibrary based on @intUnitID value.
		SET @blnIsTrainingUnitInUnitLibrary = IIF(@intUnitID = NULL, 0, 1);

		-- Determine if OfficeOrSection (@TrainingUnitName) exists as a Business Unit within the Post that is being imported
		-- and get the BusinessUnitID value if it does.
		SET @intBusinessUnitID = NULLIF((SELECT bu.[BusinessUnitID]  
										   FROM [users].[BusinessUnits] bu
										  WHERE (bu.[BusinessUnitName] = @strTrainingUnitName 
												 OR bu.[Acronym] = @strTrainingUnitName
												 OR bu.[Acronym] = @strUnitLibraryAcronym)
											AND bu.[PostID] = @intPostID), 0);

		-- Test if a matching Business Unit was found in the [BusinessUnits] table & add it to 
		-- the table if it was not found.
		IF @intBusinessUnitID IS NOT NULL
			-- Business Unit ID was found.
			BEGIN
				-- Set the value of @blnIsTrainingUnitInBusinessUnits to TRUE (1).
				SET @blnIsTrainingUnitInBusinessUnits = 1;
			END
		ELSE
			-- Business Unit ID was not found.  Need to create a new Business Unit record.
			BEGIN
				-- Set the value of @blnIsTrainingUnitInBusinessUnits to FALSE (0) & create a new [BusinessUnits] record.
				SET @blnIsTrainingUnitInBusinessUnits = 0;
				
				-- Set the value of @strAcronym based on whether or not @strUnitLibraryAcronym has a value.
				IF @strUnitLibraryAcronym IS NOT NULL
					BEGIN
						-- Use the acronym value from the Unit Library record of the Business Unit as the basis of the Business Unit acronym.
						SET @strAcronym = migration.GenerateBusinessUnitAcronym(@strTrainingUnitName, @strUnitLibraryAcronym, @intPostID);
					END
				ELSE
					BEGIN
						-- Use the Training Unit Name value from the Training Event template data as the basis of the Business Unit acronym.
						SET @strAcronym = migration.GenerateBusinessUnitAcronym(@strTrainingUnitName, NULL, @intPostID);
					END;				

				-- If the GenerateBusinessUnitAcronym() function failed to generate a valid acronym
				-- for the Business Unit, do not create a new Business Unit record.
				IF @strAcronym IS NOT NULL
					BEGIN
						-- Create new [BusinessUnits] record.		
						INSERT INTO [users].[BusinessUnits]
							([BusinessUnitName], [Acronym], [UnitLibraryUnitID], [PostID], [ModifiedByAppUserID])
						VALUES
							(@strTrainingUnitName, @strAcronym, @intUnitID, @intPostID, 2);

						-- Set @intBusinessUnitID to the new PK/Identity value of the [BusinessUnits] table.
						SET @intBusinessUnitID = SCOPE_IDENTITY();
					END
				ELSE
					BEGIN
						-- Set the BusinessUnitID to NULL to indicate that there is no associated Training Unit in the 
						-- [BusinessUnits] table for this Training Event.
						SET @intBusinessUnitID = NULL;
					END;
			END;

        -- Reverse lookup for Organizer Names.
		-- Replace any commas (,) in the delimited string with semi-colons (;).  Break apart the delimited string 
		-- into an array, look up each array element in the data table to find it's cooresponding ID value, and 
		-- then build a delimited string of name-value pairs which is then saved to a variable.
		SET @strOrganizerNames = REPLACE(@strOrganizerNames,',',';');
		SET @strOrganizerIDs = 
        (
        SELECT STRING_AGG(a.NameValue + ',' + ISNULL(TRIM(CAST(a.AppUserIDValue AS varchar)),'NULL'), ';')
        FROM 
        (
        SELECT TRIM(org.Names) AS NameValue,
				au.AppUserID AS AppUserIDValue
          FROM users.AppUsers au
        RIGHT JOIN (SELECT value AS Names
					  FROM string_split(@strOrganizerNames,';')) org 
        ON TRIM(org.Names) = CONCAT(au.First, ' ', au.Last)
        ) a
        );

        -- Reverse lookup for Training Event Type.
        SET @intEventTypeID =
        (
        SELECT tev.TrainingEventTypeID
          FROM training.TrainingEventTypes tev
         WHERE tev.Name = @strEventTypeName
        );

        -- Reverse lookup for Key Activities.
		-- Replace any commas (,) in the delimited string with semi-colons (;).  Break apart the delimited string 
		-- into an array, look up each array element in the data table to find it's cooresponding ID value, and 
		-- then build a delimited string of name-value pairs which is then saved to a variable.
		SET @strKeyActitityNames = REPLACE(@strKeyActitityNames,',',';');        
		SET @strKeyActitityIDs = 
        (
        SELECT STRING_AGG(a.NameValue + ',' + ISNULL(TRIM(CAST(a.KeyActIDValue AS varchar)),'NULL'), ';')
        FROM 
        (
        SELECT TRIM(list.Codes) AS NameValue,
			   ka.KeyActivityID AS KeyActIDValue
          FROM training.KeyActivities ka
        RIGHT JOIN (SELECT value AS Codes
					  FROM string_split(@strKeyActitityNames,';')) list 
        ON TRIM(list.Codes) = TRIM(ka.Code)
        ) a  
        );

        -- Reverse lookup for Project Codes (Funding Sources).
		-- Replace any commas (,) in the delimited string with semi-colons (;).  Break apart the delimited string 
		-- into an array, look up each array element in the data table to find it's cooresponding ID value, and 
		-- then build a delimited string of name-value pairs which is then saved to a variable.
		SET @strFundingSourceNames = REPLACE(@strFundingSourceNames,',',';');     
        SET @strFundingSourceIDs = 
        (
        SELECT STRING_AGG(a.NameValue + ',' + ISNULL(TRIM(CAST(a.ProjCodeIDValue AS varchar)),'NULL'), ';')
        FROM 
        (
        SELECT TRIM(list.Codes) AS NameValue,
               prj.ProjectCodeID AS ProjCodeIDValue
          FROM training.ProjectCodes prj
        RIGHT JOIN (SELECT value AS Codes
					  FROM string_split(@strFundingSourceNames,';')) list 
        ON TRIM(list.Codes) = TRIM(prj.Code)
        ) a  
        );

        -- Reverse lookup for Authorizing Documents (Inter-Agency Agreements (IAAs)).
		-- Replace any commas (,) in the delimited string with semi-colons (;).  Break apart the delimited string 
		-- into an array, look up each array element in the data table to find it's cooresponding ID value, and 
		-- then build a delimited string of name-value pairs which is then saved to a variable.
		SET @strAuthorizingDocNames = REPLACE(@strAuthorizingDocNames,',',';'); 
        SET @strAuthorizingDocIDs = 
        (
        SELECT STRING_AGG(a.NameValue + ',' + ISNULL(TRIM(CAST(a.IAACodeIDValue AS varchar)),'NULL'), ';')
        FROM 
        (
        SELECT TRIM(list.Codes) AS NameValue,
			   iaa.InterAgencyAgreementID AS IAACodeIDValue
          FROM training.InterAgencyAgreements iaa
        RIGHT JOIN (SELECT value AS Codes
					  FROM string_split(@strAuthorizingDocNames,';')) list 
        ON TRIM(list.Codes) = TRIM(iaa.Code)
        ) a  
        );

        -- Reverse lookup for Implementing Partners (US Partner Agencies).
		-- Replace any commas (,) in the delimited string with semi-colons (;).  Break apart the delimited string 
		-- into an array, look up each array element in the data table to find it's cooresponding ID value, and 
		-- then build a delimited string of name-value pairs which is then saved to a variable.

        -- This is a two stage process in order to look up the values in @strImplementPartnerNames.
        -- Stage 1: Reverse lookup against UnitName putting the results into an intermediate variable.
		SET @strImplementPartnerNames = REPLACE(@strImplementPartnerNames,',',';'); 
        SET @strPartnerIDsStage1 = 
        (
        SELECT STRING_AGG(a.NameValue + ',' + ISNULL(TRIM(CAST(a.UnitIDValue AS varchar)),'NULL'), ';')
        FROM 
        (
        SELECT TRIM(list.Names) AS NameValue,
			   unit.UnitID AS UnitIDValue
          FROM unitlibrary.Units unit
        RIGHT JOIN (SELECT value AS Names
					  FROM string_split(@strImplementPartnerNames,';')) list 
        ON TRIM(list.Names) = TRIM(unit.UnitName)
        ) a  
        );

        -- Stage 2: Reverse lookup against UnitAcronym.
        -- Using the intermediate variable (output from Stage 1) as the input into Stage 2,
        -- perform a UNION in order to SELECT for the Acronym if Stage 1 did not find a match.
        SET @strImplementPartnerIDs = 
        (
        SELECT STRING_AGG(b.NameValue + ',' + ISNULL(TRIM(CAST(b.IDValue AS varchar)),'NULL'), ';')
        FROM
        (
        -- Stage 1 found a match on the UnitName, keep existing Part2 value.
        SELECT tbl.Part1 AS NameValue, 
               tbl.Part2 AS IDValue
        FROM 
            (
            SELECT LEFT(value,CHARINDEX(',', value)-1) AS Part1,
				   TRIM(SUBSTRING(value, CHARINDEX(',', value)+1,100)) AS Part2
			  FROM string_split(@strPartnerIDsStage1,';')
            ) tbl
        WHERE tbl.Part2 <> 'NULL'
        UNION
        -- Stage 1 did not find a match on the UnitName, look up NameValue against the UnitAcronym
        -- column.
        SELECT tbl.Part1 AS NameValue,
            (
                SELECT u.UnitID
                  FROM unitlibrary.Units u
                 WHERE u.UnitAcronym = tbl.Part1

            ) AS IDValue
        FROM 
            (
            SELECT LEFT(value,CHARINDEX(',', value)-1) AS Part1,
				   TRIM(SUBSTRING(value, CHARINDEX(',', value)+1,100)) AS Part2
              FROM string_split(@strPartnerIDsStage1,';')
            ) tbl
        WHERE tbl.Part2 = 'NULL'
        ) b
        );

        -- Update [NewPostTrainingEvents] record for @NewPostImportID.
        BEGIN TRANSACTION
        
			UPDATE [migration].[NewPostTrainingEvents]
			SET [UnitID] = @intUnitID,
				[IsTrainingUnitInUnitLibrary] = @blnIsTrainingUnitInUnitLibrary,
			    [IsTrainingUnitInBusinessUnits] = @blnIsTrainingUnitInBusinessUnits,
				[TrainingUnitBusinessUnitID] = @intBusinessUnitID,
				[OrganizerNameIDs] = @strOrganizerIDs,
				[TrainingEventTypeID] = @intEventTypeID,
				[KeyActivityIDs] =  @strKeyActitityIDs,
				[FundingSourceIDs] = @strFundingSourceIDs,
				[AuthorizingDocumentIDs] = @strAuthorizingDocIDs,
				[ImplementingPartnerIDs] = @strImplementPartnerIDs,
				[ModifiedDate] = getutcdate()
			WHERE [NewPostImportID] = @NewPostImportID;

        -- NO ERRORS, COMMIT
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
 END;