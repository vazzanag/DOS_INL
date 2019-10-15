CREATE PROCEDURE [unitlibrary].[GetUnit]
    @UnitID BIGINT
AS
BEGIN
	SELECT UnitID, ISNULL(UnitParentID, 0) AS UnitParentID, UnitParentName, UnitParentNameEnglish, 
			CountryID, CountryName, UnitLocationID, ConsularDistrictID, UnitName, UnitNameEnglish, 
			IsMainAgency, UnitMainAgencyID, UnitAcronym, UnitGenID, UnitTypeID, UnitType, GovtLevelID, 
			GovtLevel, UnitLevelID, UnitLevel, VettingBatchTypeID, VettingBatchTypeCode, VettingActivityTypeID,
			VettingActivityType, ReportingTypeID, ReportingType, UnitHeadPersonID, CommanderFirstName, 
			CommanderLastName, UnitHeadJobTitle, UnitHeadRankID, RankName,
			[UnitHeadRank],
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
			POCTelephone, VettingPrefix, HasDutyToInform, IsLocked, IsActive, ModifiedByAppUserID, ModifiedDate, 
			UnitParentJson, UnitAliasJson, CommanderJson, CountryJson, LocationJson, PostJson, MainAgencyJson, HQLocationJson
      FROM unitlibrary.UnitsDetailView
     WHERE UnitID = @UnitID
END