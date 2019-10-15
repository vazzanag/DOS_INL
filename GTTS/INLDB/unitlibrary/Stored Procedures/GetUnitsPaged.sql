CREATE PROCEDURE [unitlibrary].[GetUnitsPaged]
    @PageSize INT = NULL, 
    @PageNumber INT = NULL, 
    @SortDirection NVARCHAR(5), 
    @SortColumn NVARCHAR(50),
    @CountryID INT,
    @IsMainAgency BIT,
    @UnitMainAgencyID BIGINT = NULL,
    @IsActive BIT = NULL
AS
BEGIN
	
	-- VALIDATE PARAMETERS
	IF (@IsMainAgency = 0 AND @UnitMainAgencyID IS NULL)
		THROW 51000, 'Invalid parameters.  UnitMainAgencyID must be specified when IsMainAgency is 0', 1;

	-- NO PAGING SPECIFIED, RETURN FULL DATASET
	IF (@PageSize IS NULL OR @PageNumber IS NULL)
	BEGIN
		SELECT UnitID, ISNULL(UnitParentID, 0) AS UnitParentID, UnitParentName, UnitParentNameEnglish, 
			   CountryID, CountryName, UnitLocationID, ConsularDistrictID, UnitName, UnitNameEnglish, UnitAgencyName, UnitBreakdownLocalLang,
			   UnitBreakdown, UnitParents, IsMainAgency, UnitMainAgencyID, UnitAcronym, UnitGenID, UnitTypeID, UnitType, GovtLevelID, 
			   GovtLevel, UnitLevelID, UnitLevel, VettingBatchTypeID, VettingBatchTypeCode, VettingActivityTypeID,
			   VettingActivityType, ReportingTypeID, ReportingType, UnitHeadPersonID, CommanderFirstName, 
			   CommanderLastName, UnitHeadJobTitle, UnitHeadRankID, RankName,
			   [UnitHeadFirstMiddleNames],
				[UnitHeadLastNames],
				[UnitHeadIDNumber],
				[UnitHeadGender],
				[UnitHeadDOB],
				[UnitHeadPoliceMilSecID],
				[UnitHeadPOBCityID], 
				[UnitHeadResidenceCityID],
				[UnitHeadContactEmail],
				[UnitHeadContactPhone],
				[UnitHeadHighestEducationID],
				[UnitHeadEnglishLanguageProficiencyID],
			   HQLocationID, POCName, POCEmailAddress, 
			   POCTelephone, VettingPrefix, HasDutyToInform, IsLocked, ModifiedByAppUserID, ModifiedDate, 
			   UnitAliasJson
		  FROM unitlibrary.UnitsView
		 WHERE ((CountryID = ISNULL(@CountryID, CountryID)
				AND IsMainAgency = ISNULL(@IsMainAgency, IsMainAgency)
				AND UnitMainAgencyID = ISNULL(@UnitMainAgencyID, UnitMainAgencyID))
			OR (CountryID = ISNULL(@CountryID, CountryID)
				AND UnitID = ISNULL(@UnitMainAgencyID, UnitMainAgencyID)))
           AND IsActive = ISNULL(@IsActive, IsActive)
	    ORDER BY	-- DYNAMIC SORT
		CASE WHEN @SortDirection = 'ASC' THEN
			CASE @SortColumn
				WHEN 'UnitID'                   THEN RIGHT('000000000000' + RTRIM(UnitID), 12)
				WHEN 'UnitName'                 THEN UnitName
				WHEN 'Acronym'                  THEN UnitAcronym
				WHEN 'UnitNameEnglish'          THEN UnitNameEnglish
                WHEN 'UnitName'                 THEN UnitName
                WHEN 'UnitParentName'           THEN UnitParentName
                WHEN 'UnitParentNameEnglish'    THEN UnitParentNameEnglish
                WHEN 'UnitParentNameEnglish'    THEN UnitParentNameEnglish
                WHEN 'GovtLevel'                THEN GovtLevel
                WHEN 'VettingActivityType'      THEN VettingActivityType
                WHEN 'VettingBatchTypeCode'     THEN VettingBatchTypeCode
                WHEN 'CommanderFirstName'       THEN CommanderFirstName
                WHEN 'CommanderLastName'        THEN CommanderLastName

			END 
		END ASC,
		CASE WHEN @SortDirection = 'DESC' THEN
			CASE @SortColumn
				WHEN 'UnitID'                   THEN RIGHT('000000000000' + RTRIM(UnitID), 12)
				WHEN 'UnitName'                 THEN UnitName
				WHEN 'Acronym'                  THEN UnitAcronym
				WHEN 'UnitNameEnglish'          THEN UnitNameEnglish
                WHEN 'UnitName'                 THEN UnitName
                WHEN 'UnitParentName'           THEN UnitParentName
                WHEN 'UnitParentNameEnglish'    THEN UnitParentNameEnglish
                WHEN 'UnitParentNameEnglish'    THEN UnitParentNameEnglish
                WHEN 'GovtLevel'                THEN GovtLevel
                WHEN 'VettingActivityType'      THEN VettingActivityType
                WHEN 'VettingBatchTypeCode'     THEN VettingBatchTypeCode
                WHEN 'CommanderFirstName'       THEN CommanderFirstName
                WHEN 'CommanderLastName'        THEN CommanderLastName
			END
		END DESC
	END
	ELSE
	BEGIN
		-- PAGING PARAMETERS SPECIFIED, GENERATE REQUESTED PAGE
		-- THEN JOIN TO TABLE TO GET FULL THE RESET OF DATA
		;WITH paged AS 
		(
			SELECT UnitID
			  FROM unitlibrary.UnitsView
		     WHERE ((CountryID = ISNULL(@CountryID, CountryID)
				    AND IsMainAgency = ISNULL(@IsMainAgency, IsMainAgency)
				    AND UnitMainAgencyID = ISNULL(@UnitMainAgencyID, UnitMainAgencyID))
			    OR (CountryID = ISNULL(@CountryID, CountryID)
				    AND UnitID = ISNULL(@UnitMainAgencyID, UnitMainAgencyID)))
               AND IsActive = ISNULL(@IsActive, IsActive)
		  ORDER BY		-- DYNAMIC SORT
			CASE WHEN @SortDirection = 'ASC' THEN
				CASE @SortColumn
					WHEN 'UnitID'                   THEN RIGHT('000000000000' + RTRIM(UnitID), 12)
				    WHEN 'UnitName'                 THEN UnitName
				    WHEN 'Acronym'                  THEN UnitAcronym
				    WHEN 'UnitNameEnglish'          THEN UnitNameEnglish
                    WHEN 'UnitName'                 THEN UnitName
                    WHEN 'UnitParentName'           THEN UnitParentName
                    WHEN 'UnitParentNameEnglish'    THEN UnitParentNameEnglish
                    WHEN 'UnitParentNameEnglish'    THEN UnitParentNameEnglish
                    WHEN 'GovtLevel'                THEN GovtLevel
                    WHEN 'VettingActivityType'      THEN VettingActivityType
                    WHEN 'VettingBatchTypeCode'     THEN VettingBatchTypeCode
                    WHEN 'CommanderFirstName'       THEN CommanderFirstName
                    WHEN 'CommanderLastName'        THEN CommanderLastName
				END 
			END ASC,
			CASE WHEN @SortDirection = 'DESC' THEN
				CASE @SortColumn
					WHEN 'UnitID'                   THEN RIGHT('000000000000' + RTRIM(UnitID), 12)
				    WHEN 'UnitName'                 THEN UnitName
				    WHEN 'Acronym'                  THEN UnitAcronym
				    WHEN 'UnitNameEnglish'          THEN UnitNameEnglish
                    WHEN 'UnitName'                 THEN UnitName
                    WHEN 'UnitParentName'           THEN UnitParentName
                    WHEN 'UnitParentNameEnglish'    THEN UnitParentNameEnglish
                    WHEN 'UnitParentNameEnglish'    THEN UnitParentNameEnglish
                    WHEN 'GovtLevel'                THEN GovtLevel
                    WHEN 'VettingActivityType'      THEN VettingActivityType
                    WHEN 'VettingBatchTypeCode'     THEN VettingBatchTypeCode
                    WHEN 'CommanderFirstName'       THEN CommanderFirstName
                    WHEN 'CommanderLastName'        THEN CommanderLastName
				END
			END DESC
			OFFSET @PageSize * (@PageNumber - 1) ROWS	-- DETERMINE OFFSET
			FETCH NEXT @PageSize ROWS ONLY				-- FETCH @PageSize RECORDS
		)
		SELECT u.UnitID, ISNULL(UnitParentID, 0) AS UnitParentID, UnitParentName, UnitParentNameEnglish, 
			   CountryID, CountryName, UnitLocationID, ConsularDistrictID, UnitName, UnitNameEnglish, UnitAgencyName, UnitBreakdownLocalLang,
			   UnitBreakdown, UnitParents, IsMainAgency, UnitMainAgencyID, UnitAcronym, UnitGenID, UnitTypeID, UnitType, GovtLevelID, 
			   GovtLevel, UnitLevelID, UnitLevel, VettingBatchTypeID, VettingBatchTypeCode, VettingActivityTypeID,
			   VettingActivityType, ReportingTypeID, ReportingType, UnitHeadPersonID, CommanderFirstName, 
			   CommanderLastName, UnitHeadJobTitle, UnitHeadRankID, RankName, HQLocationID, POCName, POCEmailAddress, 
			   POCTelephone, VettingPrefix, HasDutyToInform, IsLocked, ModifiedByAppUserID, ModifiedDate, 
			   UnitAliasJson
		   FROM paged p
	 INNER JOIN unitlibrary.UnitsView u ON p.UnitID = u.UnitID
	   ORDER BY		-- DYNAMIC SORT
		CASE WHEN @SortDirection = 'ASC' THEN
			CASE @SortColumn
				WHEN 'UnitID'                   THEN RIGHT('000000000000' + RTRIM(u.UnitID), 12)
				WHEN 'UnitName'                 THEN UnitName
				WHEN 'Acronym'                  THEN UnitAcronym
				WHEN 'UnitNameEnglish'          THEN UnitNameEnglish
                WHEN 'UnitName'                 THEN UnitName
                WHEN 'UnitParentName'           THEN UnitParentName
                WHEN 'UnitParentNameEnglish'    THEN UnitParentNameEnglish
                WHEN 'UnitParentNameEnglish'    THEN UnitParentNameEnglish
                WHEN 'GovtLevel'                THEN GovtLevel
                WHEN 'VettingActivityType'      THEN VettingActivityType
                WHEN 'VettingBatchTypeCode'     THEN VettingBatchTypeCode
                WHEN 'CommanderFirstName'       THEN CommanderFirstName
                WHEN 'CommanderLastName'        THEN CommanderLastName
			END 
		END ASC,
		CASE WHEN @SortDirection = 'DESC' THEN
			CASE @SortColumn
				WHEN 'UnitID'                   THEN RIGHT('000000000000' + RTRIM(u.UnitID), 12)
				WHEN 'UnitName'                 THEN UnitName
				WHEN 'Acronym'                  THEN UnitAcronym
				WHEN 'UnitNameEnglish'          THEN UnitNameEnglish
                WHEN 'UnitName'                 THEN UnitName
                WHEN 'UnitParentName'           THEN UnitParentName
                WHEN 'UnitParentNameEnglish'    THEN UnitParentNameEnglish
                WHEN 'UnitParentNameEnglish'    THEN UnitParentNameEnglish
                WHEN 'GovtLevel'                THEN GovtLevel
                WHEN 'VettingActivityType'      THEN VettingActivityType
                WHEN 'VettingBatchTypeCode'     THEN VettingBatchTypeCode
                WHEN 'CommanderFirstName'       THEN CommanderFirstName
                WHEN 'CommanderLastName'        THEN CommanderLastName
			END
		END DESC
	END
END