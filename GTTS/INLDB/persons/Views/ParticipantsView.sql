CREATE VIEW [persons].[ParticipantsView]
AS 
	SELECT p.PersonID, u.CountryID, p.[FirstMiddleNames], p.[LastNames], p.Gender, au.UnitName AS AgencyName, u.UnitName, r.RankName, puli.JobTitle,
		   vt.LastVettingTypeCode,  vt.LastVettingStatusCode, vt.LastVettingStatusDate, tpt.[Name] AS ParticipantType, rd.[Code] AS Distinction, 
		   (SELECT MAX(CAST(el.EventEndDate AS DATE))   FROM training.TrainingEventLocations el WHERE TrainingEventID = t.TrainingEventID) AS TrainingDate,
		   p.DOB, u.UnitNameEnglish, u.UnitAcronym, au.UnitNameEnglish AS AgencyNameEnglish, p.NationalID, vt.LastVettingStatusDate AS VettingValidEndDate
	FROM persons.Persons p

	-- Get latest training event student attended
	INNER JOIN [training].[TrainingEventParticipants] ts ON p.PersonID = ts.PersonID AND ts.ModifiedDate = (SELECT MAX(ModifiedDate) FROM [training].[TrainingEventParticipants] WHERE PersonID = p.PersonID)
	INNER JOIN [training].[TrainingEventParticipantTypes] tpt ON tpt.TrainingEventParticipantTypeID = ts.TrainingEventParticipantTypeID
	INNER JOIN persons.PersonsUnitLibraryInfo puli ON p.PersonID = puli.PersonID AND puli.IsActive = 1
	INNER JOIN unitlibrary.Units u ON puli.UnitID = u.UnitID
	INNER JOIN unitlibrary.Units au ON au.UnitID = u.UnitMainAgencyID
	LEFT JOIN training.TrainingEvents t on ts.TrainingEventID = t.TrainingEventID
	LEFT JOIN vetting.PersonsVettingClosedView vt ON puli.PersonsUnitLibraryInfoID = vt.PersonsUnitLibraryInfoID
	LEFT JOIN persons.Ranks r ON puli.RankID = r.RankID
	LEFT JOIN [training].[TrainingEventRosters] er on p.PersonID = er.PersonID
	LEFT JOIN [training].[TrainingEventRosterDistinctions] rd on er.TrainingEventRosterDistinctionID = rd.TrainingEventRosterDistinctionID
		