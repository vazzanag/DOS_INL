/*
    NAME:   ReverseLookupLocationValues
    
    DESCR:  This Stored Procedure will perform reverse lookups on [NewPostLocations] table 
            values that were uploaded from the Training Event template file being processed
            (identified by the @NewPostImportID parameter being passed in).  The results of the
            reverse lookup are then written back to the referenced records.  Any input value
            that was not matched into the GTTS DB, will have a "NULL" string value returned.
            This allows for the identification/reporting of unprocessed data in the 
            [NewPostImportExceptions] table.          
*/
CREATE PROCEDURE [migration].[ReverseLookupLocationValues]
    @NewPostImportID BIGINT = NULL	-- ID value that points to the [NewPostImportLog] record 
									-- for the template file that these Locations were  
                                    -- submitted in. Identifies the group of location rows to
                                    -- retrieve the City, State, & Country IDs for.
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- Declare a table variable to hold the lookup results from [location].[CitiesView].  
        DECLARE @CityStateCountryIDsTbl AS TABLE
        (
            NewPostLocationID BIGINT, 
            CityID  INT,
            StateID INT, 
            CountryID  INT
        );

        -- Insert corresponding City, State, & Country ID values into the table variable.
        INSERT INTO @CityStateCountryIDsTbl 
		(
			NewPostLocationID,
			CityID,
			StateID,
			CountryID
		)
        SELECT npl.[NewPostLocationID]
            ,(SELECT DISTINCT cv.[CityID]
                FROM [location].[CitiesView] cv
                WHERE UPPER(TRIM([migration].RemoveAccents(cv.[CityName]))) = UPPER(TRIM([migration].RemoveAccents(npl.[EventCity])))
                AND (UPPER(TRIM([migration].RemoveAccents(cv.[StateName]))) = UPPER(TRIM([migration].RemoveAccents(npl.[EventState]))) 
                     OR UPPER(TRIM(cv.[StateAbbreviation])) = UPPER(TRIM(npl.[EventState])))
				AND (UPPER(TRIM(cv.[CountryName])) = UPPER(TRIM(npl.[EventCountry])) 
					 OR UPPER(TRIM(cv.[CountryAbbreviation])) = UPPER(TRIM(npl.[EventCountry])))
            ) CityIDValue
            ,(SELECT DISTINCT cv.[StateID]
                FROM [location].[CitiesView] cv
                WHERE (UPPER(TRIM([migration].RemoveAccents(cv.[StateName]))) = UPPER(TRIM([migration].RemoveAccents(npl.[EventState]))) 
                       OR UPPER(TRIM(cv.[StateAbbreviation])) = UPPER(TRIM(npl.[EventState])))
				  AND (UPPER(TRIM(cv.[CountryName])) = UPPER(TRIM(npl.[EventCountry])) 
					   OR UPPER(TRIM(cv.[CountryAbbreviation])) = UPPER(TRIM(npl.[EventCountry])))
            ) StateIDValue
            ,(SELECT DISTINCT cv.[CountryID]
                FROM [location].[CitiesView] cv
                WHERE UPPER(TRIM(cv.[CountryName])) = UPPER(TRIM(npl.[EventCountry])) 
                    OR UPPER(TRIM(cv.[CountryAbbreviation])) = UPPER(TRIM(npl.[EventCountry]))
            ) CountryIDValue
        FROM [migration].[NewPostLocations] npl
        WHERE npl.[NewPostImportID] = @NewPostImportID;

		-- Declare a table variable to hold the lookup results of UNKNOWN Cities, States, Countries 
		-- from [location].[CitiesView].  
		DECLARE @UnknownCityStateCountryIDsTbl AS TABLE
		(
			NewPostLocationID BIGINT, 
			CityID INT,
			StateID INT,
			CountryID INT
		);

		-- Insert corresponding City, State, & Country ID values for UNKNOWN values into the table variable.
		INSERT INTO @UnknownCityStateCountryIDsTbl 
		(
			NewPostLocationID,
			CityID,
			StateID,
			CountryID
		)
		SELECT tblvar.NewPostLocationID,
			   (CASE WHEN tblvar.[CountryID] IS NULL AND tblvar.[StateID] IS NULL AND tblvar.[CityID] IS NULL			
						-- Country is UNKNOWN (NULL), State is UNKNOWN (NULL), City is UNKNOWN (NULL).
						THEN (SELECT DISTINCT cv.[CityID]
								FROM [location].[CitiesView] cv
							   WHERE UPPER(TRIM(cv.[CountryName])) = 'UNKNOWN' 
								 AND UPPER(TRIM(cv.[StateName])) = 'UNKNOWN' 
								 AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')

					 WHEN tblvar.[CountryID] IS NULL AND tblvar.[StateID] IS NOT NULL AND tblvar.[CityID] IS NULL		
						-- Country is UNKNOWN (NULL), State is KNOWN (NOT NULL), City is UNKNOWN (NULL).
						THEN (SELECT DISTINCT cv.[CityID]
								FROM [location].[CitiesView] cv
							   WHERE UPPER(TRIM(cv.[CountryName])) = 'UNKNOWN' 
								 AND cv.[StateID] = tblvar.[StateID] 
								 AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')

					 WHEN tblvar.[CountryID] IS NOT NULL AND tblvar.[StateID] IS NULL AND tblvar.[CityID] IS NULL		
						-- Country is KNOWN (NOT NULL), State is UNKNOWN (NULL), City is UNKNOWN (NULL).
						THEN (SELECT DISTINCT cv.[CityID]
								FROM [location].[CitiesView] cv
							   WHERE cv.[CountryID] = tblvar.[CountryID] 
								 AND UPPER(TRIM(cv.[StateName])) = 'UNKNOWN' 
								 AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')

					 WHEN tblvar.[CountryID] IS NOT NULL AND tblvar.[StateID] IS NOT NULL AND tblvar.[CityID] IS NULL	
						-- Country is KNOWN (NOT NULL), State is KNOWN (NOT NULL), City is UNKNOWN (NULL).
						THEN (SELECT DISTINCT cv.[CityID]
								FROM [location].[CitiesView] cv
							   WHERE cv.[CountryID] = tblvar.[CountryID] 
								 AND cv.[StateID] = tblvar.[StateID] 
								 AND UPPER(TRIM(cv.[CityName])) = 'UNKNOWN')
				 END),
			   (CASE WHEN tblvar.CountryID IS NULL AND tblvar.StateID IS NULL			
						-- Country is UNKNOWN (NULL), State is UNKNOWN (NULL).
						THEN (SELECT DISTINCT cv.[StateID]
			 					FROM [location].[CitiesView] cv
							   WHERE UPPER(TRIM(cv.[CountryName])) = 'UNKNOWN' 
								 AND UPPER(TRIM(cv.[StateName])) = 'UNKNOWN')

					 WHEN tblvar.CountryID IS NOT NULL AND tblvar.StateID IS NULL	
						-- Country is KNOWN (NOT NULL), State is UNKNOWN (NULL).
						THEN (SELECT DISTINCT cv.[StateID]
			 					FROM [location].[CitiesView] cv
							   WHERE cv.[CountryID] = tblvar.[CountryID] 
								 AND UPPER(TRIM(cv.[StateName])) = 'UNKNOWN')
				 END),
			   (CASE WHEN tblvar.CountryID IS NULL	
						-- Country is UNKNOWN (NULL).
						THEN (SELECT DISTINCT cv.[CountryID]
				  				FROM [location].[CitiesView] cv
							   WHERE UPPER(TRIM(cv.[CountryName])) = 'UNKNOWN')
				 END)
		FROM @CityStateCountryIDsTbl tblvar;

		-- Update the CityID column in the @CityStateCountryIDsTbl table variable (tgt)
		-- with the UNKNOWN CityID value from the @UnknownCityStateCountryIDsTbl table 
		-- variable (src) for those CityIDs in tgt that are NULL.
		UPDATE tgt
		   SET tgt.[CityID] = 
			   (SELECT src.[CityID]
	  			  FROM @UnknownCityStateCountryIDsTbl src
				 WHERE src.[NewPostLocationID] = tgt.[NewPostLocationID])
		  FROM @CityStateCountryIDsTbl tgt
		 WHERE tgt.CityID IS NULL;

		-- Update the StateID column in the @CityStateCountryIDsTbl table variable (tgt)
		-- with the UNKNOWN StateID value from the @UnknownCityStateCountryIDsTbl table 
		-- variable (src) for those StateID in tgt that are NULL.
		UPDATE tgt
		   SET tgt.[StateID] = 
			   (SELECT src.[StateID]
	  			  FROM @UnknownCityStateCountryIDsTbl src
				 WHERE src.[NewPostLocationID] = tgt.[NewPostLocationID])
		  FROM @CityStateCountryIDsTbl tgt
		 WHERE tgt.[StateID] IS NULL;

		-- Update the CountryID column in the @CityStateCountryIDsTbl table variable (tgt)
		-- with the UNKNOWN CountryID value from the @UnknownCityStateCountryIDsTbl table 
		-- variable (src) for those CountryID in tgt that are NULL.
		UPDATE tgt
		   SET tgt.[CountryID] = 
			   (SELECT src.[CountryID]
	  			  FROM @UnknownCityStateCountryIDsTbl src
				 WHERE src.[NewPostLocationID] = tgt.[NewPostLocationID])
		  FROM @CityStateCountryIDsTbl tgt
		 WHERE tgt.[CountryID] IS NULL;

        -- Update [NewPostLocations] rows with the values that were written into the table
        -- variable.
        BEGIN TRANSACTION
			
			UPDATE npl
               SET npl.[EventCityID] = tblvar.[CityID],
                   npl.[EventStateID] = tblvar.[StateID],
                   npl.[EventCountryID] = tblvar.[CountryID],	
                   npl.[ModifiedDate] = getutcdate()
              FROM [migration].[NewPostLocations] npl
              JOIN @CityStateCountryIDsTbl tblvar
                ON npl.[NewPostLocationID] = tblvar.[NewPostLocationID]
             WHERE [NewPostImportID] = @NewPostImportID;

        -- NO ERRORS, COMMIT
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
 END;