CREATE VIEW [search].[PersonsVettingJSONView]
	AS  SELECT pv.PersonsVettingID, pv.VettingBatchID, vb.CountryID,
			(SELECT pv1.Name1, pv1.Name2, pv1.Name3, pv1.Name4, pv1.Name5
			,P.FirstMiddleNames 
			,P.LastNames
			,p.DOB
			,p.Gender
			,p.NationalID
			,pobc.CityName AS POBCityName
			,pobc.StateID AS POBStateID
			,pobs.StateName AS POBStateName
			,pobs.CountryID AS POBCountryID
			,pobco.CountryName AS POBCountryName
			,uv.UnitName
			,uv.UnitAgencyName
			,uv.UnitAcronym
			,uv.UnitBreakdownLocalLang AS UnitParents
			,uv.UnitBreakdown AS UnitParentsEnglish
			,ui.RankName
			,pv.vettingNotes 
		FROM vetting.PersonsVetting pv1 
	INNER JOIN persons.PersonsUnitLibraryInfoView ui ON pv.PersonsUnitLibraryInfoID = ui.PersonsUnitLibraryInfoID
			
		INNER JOIN persons.Persons p ON ui.PersonID = p.PersonID
		INNER JOIN unitlibrary.UnitsView uv on ui.UnitID = uv.UnitID
		LEFT JOIN vetting.PersonsVettingVettingTypes ptt ON pv.PersonsVettingID = ptt.PersonsVettingID
		LEFT JOIN vetting.VettingHitResults vhr ON ptt.HitResultID = vhr.HitResultID
		LEFT JOIN [location].Cities as pobc on p.POBCityID = pobc.CityID
		LEFT JOIN [location].States as pobs on pobc.StateID= pobs.StateID
		LEFT JOIN [location].Countries as pobco on pobs.CountryID = pobco.CountryID
		WHERE pv.PersonsVettingID = pv1.PersonsVettingID FOR JSON PATH) PersonsVettingJSON,
	
	   -- Vetting Hits
		(SELECT vh.FirstMiddleNames, vh.LastNames, TrackingID, HitDetails
			FROM vetting.VettingHits vh
		WHERE pv.PersonsVettingID = vh.PersonsVettingID FOR JSON PATH) VettingHitsJSON,

		-- Leahy Hits
		(SELECT Summary, LeahyHitResult, LeahyHitResultCode
			FROM vetting.LeahyVettingHitsView vh
		WHERE pv.PersonsVettingID = vh.PersonsVettingID FOR JSON PATH) LeahyHitsJSON,

		--personsvettingtype
		(SELECT ptt.CourtesyVettingSkippedComments, ptt.HitResultID, vhr.[Code], vt.Code AS VettingType
			FROM vetting.PersonsVettingVettingTypes ptt
		INNER JOIN vetting.VettingTypes vt ON ptt.VettingTypeID = vt.VettingTypeID
			LEFT JOIN vetting.VettingHitResults vhr ON ptt.HitResultID = vhr.HitResultID			
		WHERE ptt.PersonsVettingID = pv.PersonsVettingID FOR JSON PATH) HitResultJSON

	FROM vetting.PersonsVetting pv
		INNER JOIN vetting.VettingBatches vb ON pv.VettingBatchID = vb.VettingBatchID
		

	
