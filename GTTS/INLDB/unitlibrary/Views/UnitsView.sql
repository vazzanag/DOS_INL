CREATE VIEW [unitlibrary].[UnitsView]

AS
    SELECT	u.UnitID,
			u.UnitParentID, p.UnitName as UnitParentName, p.UnitNameEnglish AS UnitParentNameEnglish,
            case when u.IsMainAgency = 1 then u.UnitName else a.UnitName end AS AgencyName,
            case when u.IsMainAgency = 1 then u.UnitNameEnglish else a.UnitNameEnglish end AS AgencyNameEnglish,
			LEFT(u.UnitBreakdown, CHARINDEX(' / ', u.UnitBreakdown)) AS UnitAgencyName,
			u.UnitBreakdownEnglish AS UnitParents,
            u.UnitBreakdownEnglish AS UnitBreakdown, u.UnitBreakdown AS UnitBreakdownLocalLang,
			u.CountryID, cou.CountryName, u.UnitLocationID, 
			u.ConsularDistrictID, u.UnitName, u.UnitNameEnglish, u.IsMainAgency, u.UnitMainAgencyID,
			u.UnitAcronym, u.UnitGenID, u.UnitTypeID, t.[Name] AS UnitType, u.GovtLevelID, g.[Name] AS GovtLevel, 
			u.UnitLevelID, l.[Name] AS UnitLevel, u.VettingBatchTypeID,vc.Code AS VettingBatchTypeCode, u.VettingActivityTypeID, 
            va.[Name] AS VettingActivityType, u.ReportingTypeID, rt.[Name] AS ReportingType, u.UnitHeadPersonID, 
            c.FirstMiddleNames AS CommanderFirstName, c.LastNames AS CommanderLastName, c.ContactEmail as CommanderEmail,
			u.UnitHeadJobTitle, u.UnitHeadRankID, r.RankName,
			u.[UnitHeadRank],
			u.[UnitHeadFirstMiddleNames],
			u.[UnitHeadLastNames],
			u.[UnitHeadIDNumber],
			u.[UnitHeadGender],
			u.[UnitHeadDOB],
			u.[UnitHeadPoliceMilSecID],
			u.[UnitHeadPOBCityID], 
			u.[UnitHeadResidenceCityID],
			u.[UnitHeadContactEmail],
			u.[UnitHeadContactPhone],
			u.[UnitHeadHighestEducationID],
			u.[UnitHeadEnglishLanguageProficiencyID],
			u.HQLocationID, u.POCName, u.POCEmailAddress, u.POCTelephone,
			u.VettingPrefix, u.HasDutyToInform, u.IsLocked, u.IsActive, U.ModifiedByAppUserID, u.ModifiedDate,
			
            -- Unit Aliases
            (SELECT UnitAliasID, UnitID, UnitAlias, LanguageID, IsDefault, IsActive, ModifiedByAppUserID, ModifiedDate
			    FROM unitlibrary.UnitAliases iup
			    WHERE iup.UnitID = u.UnitID FOR JSON PATH) AS UnitAliasJson
			  
      FROM unitlibrary.Units u
 LEFT JOIN unitlibrary.Units p on u.UnitParentID = p.UnitID
 LEFT JOIN unitlibrary.Units a on u.UnitMainAgencyID = a.UnitID
 LEFT JOIN persons.Persons c on u.UnitHeadPersonID = c.PersonID
 LEFT JOIN persons.Ranks r ON u.UnitHeadRankID = r.RankID
INNER JOIN [location].Countries cou ON u.CountryID = cou.CountryID
 LEFT JOIN vetting.VettingBatchTypes vc ON u.VettingBatchTypeID = vc.VettingBatchTypeID
 LEFT JOIN vetting.VettingActivityTypes va ON u.VettingActivityTypeID = va.VettingActivityTypeID
 LEFT JOIN unitlibrary.UnitTypes t ON u.UnitTypeID = t.UnitTypeID
 LEFT JOIN unitlibrary.UnitLevels l ON u.UnitLevelID = l.UnitLevelID
 LEFT JOIN unitlibrary.GovtLevels g on u.GovtLevelID = g.GovtLevelID
 LEFT JOIN unitlibrary.ReportingTypes rt ON u.ReportingTypeID = rt.ReportingTypeID

GO