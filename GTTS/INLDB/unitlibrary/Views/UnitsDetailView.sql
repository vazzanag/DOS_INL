CREATE VIEW [unitlibrary].[UnitsDetailView]
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
            FirstMiddleNames AS CommanderFirstName, c.LastNames AS CommanderLastName, c.ContactEmail as CommanderEmail,
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

			-- UnitParent 
			(SELECT UnitID, UnitName, UnitNameEnglish
			   FROM unitlibrary.Units iup
			  WHERE iup.UnitID = u.UnitParentID FOR JSON PATH) AS UnitParentJson,

            -- Unit Aliases
            (SELECT UnitAliasID, UnitID, UnitAlias, LanguageID, IsDefault, IsActive, ModifiedByAppUserID, ModifiedDate
			   FROM unitlibrary.UnitAliases iup
			  WHERE iup.UnitID = u.UnitID FOR JSON PATH) AS UnitAliasJson,

            -- Commander
            (SELECT PersonID, FirstMiddleNames, LastNames, Gender, ModifiedByAppUserID
			   FROM persons.PersonsView pv
			  WHERE pv.PersonID = u.UnitHeadPersonID FOR JSON PATH) AS CommanderJson,

	        -- Countries
	        (SELECT CountryID, CountryName, CountryFullName, GENCCodeA2, GENCCodeNumber, DOSBureauID, IsActive
	           FROM location.Countries ic
	          WHERE ic.CountryID = u.CountryID FOR JSON PATH) AS CountryJson,

	        -- Locations
	        (SELECT LocationID, LocationName, AddressLine1, AddressLine2, AddressLine3, il.CityID, c.StateID, il.IsActive, il.ModifiedByAppUserID
	           FROM location.Locations il
         INNER JOIN [location].Cities c on il.CityID = c.CityID
	          WHERE il.LocationID = u.UnitLocationID FOR JSON PATH) AS LocationJson,

	        -- Posts
	        (SELECT PostID, [Name], FullName, PostTypeID, CountryID, MissionID, GMTOffset, IsActive
	        FROM location.Posts ip
	        WHERE ip.PostID = u.ConsularDistrictID FOR JSON PATH) AS PostJson,

	        -- UnitMainAgencyID 
	        (SELECT UnitID, UnitName, UnitNameEnglish, IsMainAgency
	           FROM unitlibrary.Units iua
	          WHERE iua.UnitID = u.UnitMainAgencyID FOR JSON PATH) AS MainAgencyJson,

	        -- Locations (HQLocationID)
	        (SELECT LocationID, LocationName, AddressLine1, AddressLine2, AddressLine3, ilh.CityID, c.StateID, ilh.IsActive, ilh.ModifiedByAppUserID
	           FROM location.Locations ilh
         INNER JOIN [location].Cities c on ilh.CityID = c.CityID
	          WHERE ilh.LocationID = u.HQLocationID FOR JSON PATH) AS HQLocationJson

        FROM unitlibrary.Units u
   LEFT JOIN unitlibrary.Units p on u.UnitParentID = p.UnitID
   LEFT JOIN unitlibrary.Units a on u.UnitMainAgencyID = a.UnitID
   LEFT JOIN persons.PersonsView c on u.UnitHeadPersonID = c.PersonID
   LEFT JOIN persons.Ranks r ON u.UnitHeadRankID = r.RankID
  INNER JOIN [location].Countries cou ON u.CountryID = cou.CountryID
   LEFT JOIN vetting.VettingBatchTypes vc ON u.VettingBatchTypeID = vc.VettingBatchTypeID
   LEFT JOIN vetting.VettingActivityTypes va ON u.VettingActivityTypeID = va.VettingActivityTypeID
   LEFT JOIN unitlibrary.UnitTypes t ON u.UnitTypeID = t.UnitTypeID
   LEFT JOIN unitlibrary.UnitLevels l ON u.UnitLevelID = l.UnitLevelID
   LEFT JOIN unitlibrary.GovtLevels g on u.GovtLevelID = g.GovtLevelID
   LEFT JOIN unitlibrary.ReportingTypes rt ON u.ReportingTypeID = rt.ReportingTypeID
GO