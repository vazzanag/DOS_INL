CREATE PROCEDURE [unitlibrary].[FindUnitByNameAndCountryID]
	@Name NVARCHAR(256),
	@CountryID BIGINT
AS
BEGIN
	DECLARE @Query NVARCHAR(256) = UPPER(REPLACE(REPLACE(@Name, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI;
	SELECT UnitID, ISNULL(UnitParentID, 0) AS UnitParentID, UnitParentName, UnitParentNameEnglish, 
			   CountryID, CountryName, UnitLocationID, ConsularDistrictID, UnitName, UnitNameEnglish, 
			   IsMainAgency, UnitMainAgencyID, UnitAcronym, UnitGenID, UnitTypeID, UnitType, GovtLevelID, 
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
			   UnitParentJson, UnitAliasJson, CountryJson, LocationJson, PostJson, MainAgencyJson, HQLocationJson
	FROM unitlibrary.UnitsDetailView uv
	WHERE
	CountryID = @CountryID
	AND
	(
		@Query = UPPER(REPLACE(REPLACE(UnitName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI
		OR
		EXISTS (SELECT UnitID FROM unitlibrary.UnitAliases WHERE @Query = UPPER(REPLACE(REPLACE(UnitAlias, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI AND UnitID = uv.UnitID)
	)
END
