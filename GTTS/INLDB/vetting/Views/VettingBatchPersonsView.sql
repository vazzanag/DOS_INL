CREATE VIEW [vetting].[VettingBatchPersonsView]
AS 

	SELECT 
		-- Vetting
		pv.PersonsVettingID,
		pv.VettingBatchID,
		pv.Name1 AS LeahyName1, 
		pv.Name2 AS LeahyName2,  
		pv.Name3 AS LeahyName3, 
		pv.Name4 AS LeahyName4, 
		pv.Name5 AS LeahyName5, 
		pv.VettingPersonStatusID,
		vps.Code AS VettingPersonStatus,
		pv.VettingStatusDate, 
		pv.VettingNotes,
		pv.ClearedDate,
		pv.AppUserIDCleared AS ClearedByAppUserID,
		clearedby.FullName ClearedByAppUserName,
		pv.DeniedDate,
		pv.AppUserIDDenied AS DeniedByAppUserID,
		deniedby.FullName DeniedByAppUserName,
			   
		-- Bio Data
		p.FirstMiddleNames,
		p.LastNames,
		p.Gender,
		p.IsUSCitizen,
		p.NationalID,
		p.DOB,
		p.POBCityID,
		ci.CityName AS POBCity,
		s.StateID AS POBStateID,
		s.StateName AS POBState,
		co.CountryID AS POBCountryID,
		co.CountryName AS POBCountry,

		-- Unit
		pv.PersonsUnitLibraryInfoID,
		puli.JobTitle,
		puli.RankID,
		r.RankName,
		u.UnitID, 
		u.UnitName, 
		u.UnitNameEnglish,
		u.UnitGenID,
		u.UnitMainAgencyID,
		a.UnitName AS UnitMainAgency,
		u.UnitBreakdownEnglish AS UnitBreakdown,
		u.UnitBreakdown AS UnitBreakdownLocalLang
		
	FROM vetting.PersonsVetting pv
	INNER JOIN persons.PersonsUnitLibraryInfo puli
		ON puli.PersonsUnitLibraryInfoID = pv.PersonsUnitLibraryInfoID
	LEFT JOIN persons.Ranks r
		ON r.RankID = puli.RankID
	INNER JOIN persons.Persons p
		ON p.PersonID = puli.PersonID
	INNER JOIN location.Cities ci
		ON ci.CityID = p.POBCityID
	INNER JOIN location.States s
		ON s.StateID = ci.StateID
	INNER JOIN location.Countries co
		ON co.CountryID = s.CountryID
	INNER JOIN unitlibrary.Units u
		ON u.UnitID = pv.PersonsUnitLibraryInfoID
	INNER JOIN unitlibrary.Units a
		ON a.UnitID = u.UnitMainAgencyID
	INNER JOIN vetting.VettingPersonStatuses vps
		ON vps.VettingPersonStatusID = pv.VettingPersonStatusID
	LEFT JOIN users.AppUsersView clearedby
		ON clearedby.AppUserID = pv.AppUserIDCleared
	LEFT JOIN users.AppUsersView deniedby
		ON deniedby.AppUserID = pv.AppUserIDDenied
