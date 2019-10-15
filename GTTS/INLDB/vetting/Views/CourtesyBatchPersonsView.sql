CREATE VIEW [vetting].[CourtesyBatchPersonsView]
AS 
	SELECT
		-- Vetting
		pv.PersonsVettingID,
		pv.VettingBatchID,
		cb.CourtesyBatchID,
		pvvt.VettingTypeID,
		vt.Code AS VettingType,
		pvvt.CourtesyVettingSkipped,
		pvvt.CourtesyVettingSkippedComments,
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
	INNER JOIN vetting.PersonsVettingVettingTypes pvvt
		ON pvvt.PersonsVettingID = pv.PersonsVettingID
	INNER JOIN vetting.VettingTypes vt
		ON vt.VettingTypeID = pvvt.VettingTypeID
	INNER JOIN vetting.CourtesyBatches cb
		ON cb.VettingBatchID = pv.VettingBatchID
		AND cb.VettingTypeID = pvvt.VettingTypeID
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
