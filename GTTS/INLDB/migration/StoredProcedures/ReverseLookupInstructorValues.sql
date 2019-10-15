/*
    NAME:   ReverseLookupInstructorValues
    
    DESCR:  This Stored Procedure will perform reverse lookups on [NewPostInstructors] table 
            values that were uploaded from the Training Event template file being processed
            (identified by the @NewPostImportID parameter being passed in).  The results of the
            reverse lookup are then written back to the referenced records.  Any input value
            that was not matched into the GTTS DB, will have a "NULL" string value returned.
            This allows for the identification/reporting of unprocessed data in the 
            [NewPostImportExceptions] table.          
*/
CREATE PROCEDURE [migration].[ReverseLookupInstructorValues]
    @NewPostImportID BIGINT = NULL	-- ID value that points to the [NewPostImportLog] record 
									-- for the template file that these Instructors were  
                                    -- submitted in. Identifies the group of Instructor rows to
                                    -- retrieve the various reverse lookup values for.
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- Get CountryID value for the template file being processed.
        DECLARE @CountryID AS INT;
        SET @CountryID = (SELECT npil.CountryID
                            FROM migration.NewPostImportLog npil
                           WHERE npil.NewPostImportID = @NewPostImportID);

        -- Declare a table variable to hold the lookup results from [location].[CitiesView].
        DECLARE @CityStateCountryIDsTbl AS TABLE
        (
            NewPostInstructorID BIGINT, 
            POBCityID INT,
            POBStateID INT, 
            POBCountryID INT,
            ResidenceCityID INT,
            ResidenceStateID INT, 
            ResidenceCountryID INT,
            DepartureCityID INT            
        );

        -- Insert corresponding POB and Residence City, State, & Country ID values into the table variable.
        INSERT INTO @CityStateCountryIDsTbl 
        (
            NewPostInstructorID, 
            POBCityID, 
            POBStateID, 
            POBCountryID, 
            ResidenceCityID, 
            ResidenceStateID, 
            ResidenceCountryID,
            DepartureCityID
        )
        SELECT 
            npi.[NewPostInstructorID],
            (SELECT DISTINCT cv.[CityID]
			   FROM [location].[CitiesView] cv
              WHERE UPPER(TRIM([migration].RemoveAccents(cv.[CityName]))) = UPPER(TRIM([migration].RemoveAccents(npi.[POBCity])))
                AND (UPPER(TRIM([migration].RemoveAccents(cv.[StateName]))) = UPPER(TRIM([migration].RemoveAccents(npi.[POBState]))) 
                     OR UPPER(TRIM(cv.[StateAbbreviation])) = UPPER(TRIM(npi.[POBState])))
                AND (UPPER(TRIM(cv.[CountryName])) = UPPER(TRIM(npi.[POBCountry])) 
                     OR UPPER(TRIM(cv.[CountryAbbreviation])) = UPPER(TRIM(npi.[POBCountry])))
            ) POBCityIDValue,
            (SELECT DISTINCT cv.[StateID]
               FROM [location].[CitiesView] cv
              WHERE (UPPER(TRIM([migration].RemoveAccents(cv.[StateName]))) = UPPER(TRIM([migration].RemoveAccents(npi.[POBState]))) 
                     OR UPPER(TRIM(cv.[StateAbbreviation])) = UPPER(TRIM(npi.[POBState])))
                AND (UPPER(TRIM(cv.[CountryName])) = UPPER(TRIM(npi.[POBCountry])) 
                     OR UPPER(TRIM(cv.[CountryAbbreviation])) = UPPER(TRIM(npi.[POBCountry])))
            ) POBStateIDValue,
            (SELECT DISTINCT cv.[CountryID]
               FROM [location].[CitiesView] cv
              WHERE UPPER(TRIM(cv.[CountryName])) = UPPER(TRIM(npi.[POBCountry])) 
                 OR UPPER(TRIM(cv.[CountryAbbreviation])) = UPPER(TRIM(npi.[POBCountry]))
            ) POBCountryIDValue,
            (SELECT DISTINCT cv.[CityID]
               FROM [location].[CitiesView] cv
              WHERE UPPER(TRIM([migration].RemoveAccents(cv.[CityName]))) = UPPER(TRIM([migration].RemoveAccents(npi.[ResidenceCity])))
                AND (UPPER(TRIM([migration].RemoveAccents(cv.[StateName]))) = UPPER(TRIM([migration].RemoveAccents(npi.[ResidenceState]))) 
                     OR UPPER(TRIM(cv.[StateAbbreviation])) = UPPER(TRIM(npi.[ResidenceState])))
                AND (UPPER(TRIM(cv.[CountryName])) = UPPER(TRIM(npi.[ResidenceCountry])) 
                     OR UPPER(TRIM(cv.[CountryAbbreviation])) = UPPER(TRIM(npi.[ResidenceCountry])))
            ) ResidenceCityIDValue,
            (SELECT DISTINCT cv.[StateID]
               FROM [location].[CitiesView] cv
              WHERE (UPPER(TRIM([migration].RemoveAccents(cv.[StateName]))) = UPPER(TRIM([migration].RemoveAccents(npi.[ResidenceState]))) 
                     OR UPPER(TRIM(cv.[StateAbbreviation])) = UPPER(TRIM(npi.[ResidenceState])))
                AND (UPPER(TRIM(cv.[CountryName])) = UPPER(TRIM(npi.[ResidenceCountry])) 
                     OR UPPER(TRIM(cv.[CountryAbbreviation])) = UPPER(TRIM(npi.[ResidenceCountry])))
            ) ResidenceStateIDValue,
            (SELECT DISTINCT cv.[CountryID]
               FROM [location].[CitiesView] cv
              WHERE UPPER(TRIM(cv.[CountryName])) = UPPER(TRIM(npi.[ResidenceCountry])) 
                 OR UPPER(TRIM(cv.[CountryAbbreviation])) = UPPER(TRIM(npi.[ResidenceCountry]))
            ) ResidenceCountryIDValue,
            (SELECT DISTINCT cv.[CityID]
               FROM [location].[CitiesView] cv
              WHERE UPPER(TRIM([migration].RemoveAccents(cv.[CityName]))) = UPPER(TRIM([migration].RemoveAccents(npi.DepartureCity)))
                AND (UPPER(TRIM([migration].RemoveAccents(cv.[StateName]))) = UPPER(TRIM([migration].RemoveAccents(npi.[ResidenceState]))) 
                     OR UPPER(TRIM(cv.[StateAbbreviation])) = UPPER(TRIM(npi.[ResidenceState])))
                AND (UPPER(TRIM(cv.[CountryName])) = UPPER(TRIM(npi.[ResidenceCountry])) 
                     OR UPPER(TRIM(cv.[CountryAbbreviation])) = UPPER(TRIM(npi.[ResidenceCountry])))
            ) DepartureCityIDValue
        FROM [migration].[NewPostInstructors] npi
        WHERE npi.[NewPostImportID] = @NewPostImportID;

        -- Declare a table variable to hold the lookup results of UNKNOWN Cities, States, Countries from [location].[CitiesView].  
        DECLARE @UnknownCityStateCountryIDsTbl AS TABLE
        (
            NewPostInstructorID BIGINT, 
            POBCityID INT,
            POBStateID INT, 
            POBCountryID INT,
            ResidenceCityID INT,
            ResidenceStateID INT, 
            ResidenceCountryID INT,
            DepartureCityID INT       
        );

        -- Insert corresponding City, State, & Country ID values for UNKNOWN values into the table variable.
        INSERT INTO @UnknownCityStateCountryIDsTbl 
        (
            NewPostInstructorID, 
            POBCityID, 
            POBStateID, 
            POBCountryID, 
            ResidenceCityID, 
            ResidenceStateID, 
            ResidenceCountryID,
            DepartureCityID
        )
        SELECT 
            tblvar.[NewPostInstructorID],
            -- Returns POBCityID value.
            (CASE WHEN tblvar.[POBCountryID] IS NULL AND tblvar.[POBStateID] IS NULL AND tblvar.[POBCityID] IS NULL			
					   -- Country is UNKNOWN (NULL), State is UNKNOWN (NULL), City is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[CityID]
                               FROM [location].[CitiesView] cv
                              WHERE UPPER(TRIM(cv.[CountryName])) = 'UNKNOWN' 
                                AND UPPER(TRIM(cv.[StateName])) = 'UNKNOWN' 
                                AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')

				  WHEN tblvar.[POBCountryID] IS NULL AND tblvar.[POBStateID] IS NOT NULL AND tblvar.[POBCityID] IS NULL		
                       -- Country is UNKNOWN (NULL), State is KNOWN (NOT NULL), City is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[CityID]
                               FROM [location].[CitiesView] cv
                              WHERE UPPER(TRIM(cv.[CountryName])) = 'UNKNOWN' 
                                AND cv.[StateID] = tblvar.[POBStateID] 
                                AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')

                  WHEN tblvar.[POBCountryID] IS NOT NULL AND tblvar.[POBStateID] IS NULL AND tblvar.[POBCityID] IS NULL		
                       -- Country is KNOWN (NOT NULL), State is UNKNOWN (NULL), City is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[CityID]
                               FROM [location].[CitiesView] cv
						      WHERE cv.[CountryID] = tblvar.[POBCountryID] 
                                AND UPPER(TRIM(cv.[StateName])) = 'UNKNOWN' 
                                AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')

                  WHEN tblvar.[POBCountryID] IS NOT NULL AND tblvar.[POBStateID] IS NOT NULL AND tblvar.[POBCityID] IS NULL	
                       -- Country is KNOWN (NOT NULL), State is KNOWN (NOT NULL), City is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[CityID]
                               FROM [location].[CitiesView] cv
                              WHERE cv.[CountryID] = tblvar.[POBCountryID] 
                                AND cv.[StateID] = tblvar.[POBStateID] 
                                AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')
             END),
            -- Returns POBStateID value.         
            (CASE WHEN tblvar.[POBCountryID] IS NULL AND tblvar.[POBStateID] IS NULL			
                       -- Country is UNKNOWN (NULL), State is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[StateID]
                               FROM [location].[CitiesView] cv
                              WHERE UPPER(TRIM(cv.[CountryName])) = 'UNKNOWN' 
                                AND UPPER(TRIM(cv.[StateName])) = 'UNKNOWN')

                  WHEN tblvar.[POBCountryID] IS NOT NULL AND tblvar.[POBStateID] IS NULL	
                       -- Country is KNOWN (NOT NULL), State is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[StateID]
                               FROM [location].[CitiesView] cv
                              WHERE cv.[CountryID] = tblvar.[POBCountryID] 
                                AND UPPER(TRIM(cv.[StateName])) = 'UNKNOWN')
             END),
            -- Returns POBCountryID value.     
            (CASE WHEN tblvar.[POBCountryID] IS NULL	
                       -- Country is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[CountryID]
                               FROM [location].[CitiesView] cv
                              WHERE UPPER(TRIM(cv.[CountryName])) = 'UNKNOWN')
             END),
            -- Returns ResidenceCityID value.
            (CASE WHEN tblvar.[ResidenceCountryID] IS NULL AND tblvar.[ResidenceStateID] IS NULL AND tblvar.[ResidenceCityID] IS NULL			
                       -- Country is UNKNOWN (NULL), State is UNKNOWN (NULL), City is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[CityID]
                               FROM [location].[CitiesView] cv
                              WHERE UPPER(TRIM(cv.[CountryName])) = 'UNKNOWN' 
                                AND UPPER(TRIM(cv.[StateName])) = 'UNKNOWN' 
                                AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')

                  WHEN tblvar.[ResidenceCountryID] IS NULL AND tblvar.[ResidenceStateID] IS NOT NULL AND tblvar.[ResidenceCityID] IS NULL		
                       -- Country is UNKNOWN (NULL), State is KNOWN (NOT NULL), City is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[CityID]
                               FROM [location].[CitiesView] cv
                              WHERE UPPER(TRIM(cv.[CountryName])) = 'UNKNOWN' 
                                AND cv.[StateID] = tblvar.[ResidenceStateID] 
                                AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')

                  WHEN tblvar.[ResidenceCountryID] IS NOT NULL AND tblvar.[ResidenceStateID] IS NULL AND tblvar.[ResidenceCityID] IS NULL		
                       -- Country is KNOWN (NOT NULL), State is UNKNOWN (NULL), City is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[CityID]
                               FROM [location].[CitiesView] cv
                              WHERE cv.[CountryID] = tblvar.[ResidenceCountryID] 
                                AND UPPER(TRIM(cv.[StateName])) = 'UNKNOWN' 
                                AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')

                  WHEN tblvar.[ResidenceCountryID] IS NOT NULL AND tblvar.[ResidenceStateID] IS NOT NULL AND tblvar.[ResidenceCityID] IS NULL	
                       -- Country is KNOWN (NOT NULL), State is KNOWN (NOT NULL), City is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[CityID]
                               FROM [location].[CitiesView] cv
                              WHERE cv.[CountryID] = tblvar.[ResidenceCountryID] 
                                AND cv.[StateID] = tblvar.[ResidenceStateID] 
                                AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')
              END),
            -- Returns ResidenceStateID value.         
            (CASE WHEN tblvar.[ResidenceCountryID] IS NULL AND tblvar.[ResidenceStateID] IS NULL			
                       -- Country is UNKNOWN (NULL), State is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[StateID]
                               FROM [location].[CitiesView] cv
                              WHERE UPPER(TRIM(cv.[CountryName])) = 'UNKNOWN' 
                                AND UPPER(TRIM(cv.[StateName])) = 'UNKNOWN')

                  WHEN tblvar.[ResidenceCountryID] IS NOT NULL AND tblvar.[ResidenceStateID] IS NULL	
                       -- Country is KNOWN (NOT NULL), State is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[StateID]
                               FROM [location].[CitiesView] cv
                              WHERE cv.[CountryID] = tblvar.[ResidenceCountryID] 
                                AND UPPER(TRIM(cv.[StateName])) = 'UNKNOWN')
             END),
            -- Returns ResidenceCountryID value.     
            (CASE WHEN tblvar.[ResidenceCountryID] IS NULL	
                       -- Country is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[CountryID]
                               FROM [location].[CitiesView] cv
                              WHERE UPPER(TRIM(cv.[CountryName])) = 'UNKNOWN')
             END),
            -- Returns DepartureCityID value.
            (CASE WHEN tblvar.[ResidenceCountryID] IS NULL AND tblvar.[ResidenceStateID] IS NULL AND tblvar.[DepartureCityID] IS NULL			
                       -- Country is UNKNOWN (NULL), State is UNKNOWN (NULL), City is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[CityID]
                               FROM [location].[CitiesView] cv
                              WHERE UPPER(TRIM(cv.[CountryName])) = 'UNKNOWN' 
                                AND UPPER(TRIM(cv.[StateName])) = 'UNKNOWN' 
                                AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')

                  WHEN tblvar.[ResidenceCountryID] IS NULL AND tblvar.[ResidenceStateID] IS NOT NULL AND tblvar.[DepartureCityID] IS NULL		
                       -- Country is UNKNOWN (NULL), State is KNOWN (NOT NULL), City is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[CityID]
                               FROM [location].[CitiesView] cv
                              WHERE UPPER(TRIM(cv.[CountryName])) = 'UNKNOWN' 
                                AND cv.[StateID] = tblvar.[ResidenceStateID] 
                                AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')

                  WHEN tblvar.[ResidenceCountryID] IS NOT NULL AND tblvar.[ResidenceStateID] IS NULL AND tblvar.[DepartureCityID] IS NULL		
                       -- Country is KNOWN (NOT NULL), State is UNKNOWN (NULL), City is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[CityID]
                               FROM [location].[CitiesView] cv
                              WHERE cv.[CountryID] = tblvar.[ResidenceCountryID] 
                                AND UPPER(TRIM(cv.[StateName])) = 'UNKNOWN' 
                                AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')

                  WHEN tblvar.[ResidenceCountryID] IS NOT NULL AND tblvar.[ResidenceStateID] IS NOT NULL AND tblvar.[DepartureCityID] IS NULL	
                       -- Country is KNOWN (NOT NULL), State is KNOWN (NOT NULL), City is UNKNOWN (NULL).
                       THEN (SELECT DISTINCT cv.[CityID]
                               FROM [location].[CitiesView] cv
                              WHERE cv.[CountryID] = tblvar.[ResidenceCountryID] 
                                AND cv.[StateID] = tblvar.[ResidenceStateID] 
                                AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')
             END)
        FROM @CityStateCountryIDsTbl tblvar;

        -- Update the POBCityID column in the @CityStateCountryIDsTbl table variable (tgt)
        -- with the UNKNOWN POBCityID value from the @UnknownCityStateCountryIDsTbl table 
        -- variable (src) for those POBCityIDs in tgt that are NULL.
        UPDATE tgt
        SET tgt.[POBCityID] = 
			(SELECT src.[POBCityID]
               FROM @UnknownCityStateCountryIDsTbl src
              WHERE src.[NewPostInstructorID] = tgt.[NewPostInstructorID])
        FROM @CityStateCountryIDsTbl tgt
        WHERE tgt.[POBCityID] IS NULL;

        -- Update the POBStateID column in the @CityStateCountryIDsTbl table variable (tgt)
        -- with the UNKNOWN POBStateID value from the @UnknownCityStateCountryIDsTbl table 
        -- variable (src) for those POBStateIDs in tgt that are NULL.
        UPDATE tgt
        SET tgt.[POBStateID] = 
            (SELECT src.[POBStateID]
               FROM @UnknownCityStateCountryIDsTbl src
              WHERE src.[NewPostInstructorID] = tgt.[NewPostInstructorID])
        FROM @CityStateCountryIDsTbl tgt
        WHERE tgt.[POBStateID] IS NULL;

        -- Update the POBCountryID column in the @CityStateCountryIDsTbl table variable (tgt)
        -- with the UNKNOWN POBCountryID value from the @UnknownCityStateCountryIDsTbl table 
        -- variable (src) for those POBCountryIDs in tgt that are NULL.
        UPDATE tgt
        SET tgt.[POBCountryID] = 
            (SELECT src.[POBCountryID]
               FROM @UnknownCityStateCountryIDsTbl src
              WHERE src.[NewPostInstructorID] = tgt.[NewPostInstructorID])
        FROM @CityStateCountryIDsTbl tgt
        WHERE tgt.[POBCountryID] IS NULL;

        -- Update the ResidenceCityID column in the @CityStateCountryIDsTbl table variable (tgt)
        -- with the UNKNOWN ResidenceCityID value from the @UnknownCityStateCountryIDsTbl table 
        -- variable (src) for those ResidenceCityIDs in tgt that are NULL.
        UPDATE tgt
        SET tgt.[ResidenceCityID] = 
            (SELECT src.[ResidenceCityID]
               FROM @UnknownCityStateCountryIDsTbl src
              WHERE src.[NewPostInstructorID] = tgt.[NewPostInstructorID])
        FROM @CityStateCountryIDsTbl tgt
        WHERE tgt.[ResidenceCityID] IS NULL;
        
        -- Update the ResidenceStateID column in the @CityStateCountryIDsTbl table variable (tgt)
        -- with the UNKNOWN ResidenceStateID value from the @UnknownCityStateCountryIDsTbl table 
        -- variable (src) for those ResidenceStateIDs in tgt that are NULL.
        UPDATE tgt
        SET tgt.[ResidenceStateID] = 
            (SELECT src.[ResidenceStateID]
               FROM @UnknownCityStateCountryIDsTbl src
               WHERE src.[NewPostInstructorID] = tgt.[NewPostInstructorID])
        FROM @CityStateCountryIDsTbl tgt
        WHERE tgt.[ResidenceStateID] IS NULL;
        
        -- Update the ResidenceCountryID column in the @CityStateCountryIDsTbl table variable (tgt)
        -- with the UNKNOWN ResidenceCountryID value from the @UnknownCityStateCountryIDsTbl table 
        -- variable (src) for those ResidenceCountryIDs in tgt that are NULL.
        UPDATE tgt
        SET tgt.[ResidenceCountryID] = 
            (SELECT src.[ResidenceCountryID]
               FROM @UnknownCityStateCountryIDsTbl src
              WHERE src.[NewPostInstructorID] = tgt.[NewPostInstructorID])
        FROM @CityStateCountryIDsTbl tgt
        WHERE tgt.[ResidenceCountryID] IS NULL;

        -- Update the DepartureCityID column in the @CityStateCountryIDsTbl table variable (tgt)
        -- with the UNKNOWN DepartureCityID value from the @UnknownCityStateCountryIDsTbl table 
        -- variable (src) for those DepartureCityIDs in tgt that are NULL.
        UPDATE tgt
        SET tgt.[DepartureCityID] = 
            (SELECT src.[DepartureCityID]
               FROM @UnknownCityStateCountryIDsTbl src
              WHERE src.[NewPostInstructorID] = tgt.[NewPostInstructorID])
        FROM @CityStateCountryIDsTbl tgt
        WHERE tgt.[DepartureCityID] IS NULL;

        -- Update [NewPostInstructors] rows with the results of the reverse lookups.
        BEGIN TRANSACTION

            UPDATE [migration].[NewPostInstructors]
               SET [GenderFlag] =  (IIF(UPPER(TRIM(npi.[Gender])) = 'MALE', 'M', 'F')),
                   [USCitizenFlag] = (IIF(UPPER(TRIM(npi.[IsUSCitizen])) = 'YES', 1, 0)),
                   [POBCityID] = tblvar.POBCityID,
                   [POBStateID] = tblvar.POBStateID,
                   [POBCountryID] = tblvar.POBCountryID,
                   [ResidenceCityID] = tblvar.ResidenceCityID,
                   [ResidenceStateID] = tblvar.ResidenceStateID,
                   [ResidenceCountryID] = tblvar.ResidenceCountryID,
                   [ResidenceLocationID] = (SELECT lv.LocationID 
                                              FROM location.LocationsView lv 
                                             WHERE lv.CityID = tblvar.ResidenceCityID
			   						           AND lv.AddressLine1 IS NULL 
			   						           AND lv.AddressLine2 IS NULL 
			   						           AND lv.AddressLine3 IS NULL),
                   [HighestEducationID] = (SELECT el.[EducationLevelID] 
                                             FROM [persons].[EducationLevels] el 
                                            WHERE el.[Code] = npi.[HighestEducation]),  
                   [EnglishLanguageProficiencyID] = (SELECT lp.[LanguageProficiencyID] 
                                                       FROM [location].[LanguageProficiencies] lp 
                                                      WHERE lp.[Code] = npi.[EnglishLanguageProficiency]), 
                   [UnitID] = COALESCE(unitlibrary.FindUnitIDFromParticipantUpload('UnitBreakdown', npi.[UnitBreakdown], @CountryID),
                                       unitlibrary.FindUnitIDFromParticipantUpload('UnitGenID', npi.[UnitGenID], @CountryID),
                                       unitlibrary.FindUnitIDFromParticipantUpload('UnitAlias', npi.[UnitAlias], @CountryID)),
                   [RankID] = (SELECT r.[RankID]
                                 FROM persons.[Ranks] r
                                WHERE [migration].RemoveAccents(r.[RankName]) = [migration].RemoveAccents(npi.[Rank]) 
								  AND r.[CountryID] = @CountryID),
                   [UnitCommanderFlag] = (SELECT IIF(UPPER(TRIM(npi.[UnitCommander])) = 'YES', 1, 0)),
                   [IsVettingRequired] = (CASE UPPER(TRIM(LEFT(npi.[VettingType], 16)))
											   WHEN 'NONE' THEN 0				-- FALSE 
                                               WHEN 'COURTESY VETTING' THEN 1	-- TRUE
                                               WHEN 'LEAHY VETTING' THEN 1		-- TRUE
										  END),
                   [IsLeahyVettingReq] = (CASE UPPER(TRIM(LEFT(npi.[VettingType], 16)))
											   WHEN 'NONE' THEN 0				-- FALSE 
                                               WHEN 'COURTESY VETTING' THEN 0	-- FALSE
                                               WHEN 'LEAHY VETTING' THEN 1		-- TRUE
										  END),
                  [HasLocalGovTrustFlag] = (CASE UPPER(TRIM(LEFT(npi.[HasLocalGovTrust], 14)))
												  WHEN 'YES, PASSED' THEN 1	-- TRUE 
												  WHEN 'YES, FAILED' THEN 1	-- TRUE
												  WHEN 'NO, NOT VETTED' THEN 0	-- FALSE
                                             END),
				   [PassedLocalGovTrustFlag] = (CASE UPPER(TRIM(LEFT(npi.[HasLocalGovTrust], 14)))
													 WHEN 'YES, PASSED' THEN 1	-- TRUE 
													 WHEN 'YES, FAILED' THEN 0	-- FALSE
													 WHEN 'NO, NOT VETTED' THEN 0	-- FALSE
												END),
                   [LocalGovTrustCertDate] = (IIF(UPPER(TRIM(LEFT(npi.[HasLocalGovTrust], 14))) = 'NO, NOT VETTED', 
                                                NULL, npi.[LocalGovTrustCertDate])),
                   [OtherVettingFlag] = (CASE UPPER(TRIM(LEFT(npi.[PassedExternalVetting], 14)))
											  WHEN 'YES, PASSED' THEN 1		-- TRUE 
                                              WHEN 'YES, FAILED' THEN 1		-- TRUE
                                              WHEN 'NO, NOT VETTED' THEN 0	-- FALSE
                                         END),
                   [PassedOtherVettingFlag] = (CASE UPPER(TRIM(LEFT(npi.[PassedExternalVetting], 14)))
                                                    WHEN 'YES, PASSED' THEN 1		-- TRUE 
                                                    WHEN 'YES, FAILED' THEN 0		-- FALSE
                                                    WHEN 'NO, NOT VETTED' THEN 0	-- FALSE
                                               END),
                   [ExternalVettingDate] = (IIF(UPPER(TRIM(LEFT(npi.[PassedExternalVetting], 14))) = 'NO, NOT VETTED', 
                                                NULL, npi.[ExternalVettingDate])),
                   [DepartureCityID] = tblvar.DepartureCityID,
                   [ModifiedDate] = getutcdate()
              FROM [migration].[NewPostInstructors] npi
              JOIN @CityStateCountryIDsTbl tblvar
                ON npi.NewPostInstructorID = tblvar.NewPostInstructorID
             WHERE npi.[NewPostImportID] = @NewPostImportID;

        -- NO ERRORS, COMMIT
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
 END;