CREATE PROCEDURE [persons].[GetAllParticipants]
	@CountryID int = NULL,
	@ParticipantType varchar(15) = NULL
AS
BEGIN
	
	SELECT 
		p.PersonID, p.CountryID, p.FirstMiddleNames, p.LastNames, p.Gender, p.AgencyName, p.UnitName, p.RankName, p.JobTitle,
		p.LastVettingStatusCode, p.LastVettingTypeCode, p.LastVettingStatusDate, p.ParticipantType, p.Distinction, 
		CASE 
			WHEN s.Code='APPROVED' OR s.Code = 'REJECTED' THEN 
				CASE 
					WHEN b.VettingBatchTypeID = 1 THEN 
						DateAdd(year,1,pv.VettingStatusDate) 
					ELSE  
						lh.ExpiresDate 
				END 
			ELSE 
				NULL 
		END AS VettingValidEndDate,
		MAX(p.TrainingDate) AS TrainingDate,
		MAX(p.DOB) AS DOB, 
		MAX(p.UnitNameEnglish) AS UnitNameEnglish,
		MAX(p.UnitAcronym) AS UnitAcronym,
		MAX(p.AgencyNameEnglish) AS AgencyNameEnglish,
		MAX(p.NationalID) AS NationalID
	FROM [persons].[ParticipantsView] p
	LEFT JOIN persons.PersonsUnitLibraryInfo pu
		ON pu.PersonID = p.PersonID
	LEFT JOIN [vetting].[PersonsVetting] pv 
		ON pv.PersonsUnitLibraryInfoID = pu.PersonsUnitLibraryInfoID 
		AND pu.IsActive = 1
	LEFT JOIN vetting.VettingPersonStatuses s 
		ON pv.VettingPersonStatusID = s.VettingPersonStatusID
	LEFT JOIN vetting.VettingBatches b 
		ON pv.VettingBatchID = b.VettingBatchID
	LEFT JOIN vetting.LeahyVettingHits lh 
		ON pv.PersonsVettingID = lh.PersonsVettingID
	WHERE p.CountryID = ISNULL(@CountryID, p.CountryID) 
	AND p.ParticipantType = ISNULL(@ParticipantType, p.ParticipantType)
	GROUP BY 
		p.PersonID, p.CountryID, p.FirstMiddleNames, p.LastNames, p.Gender, p.AgencyName, p.UnitName, p.RankName, p.JobTitle,
			p.LastVettingStatusCode, p.LastVettingTypeCode, p.LastVettingStatusDate, p.ParticipantType, p.Distinction, 
			CASE 
				WHEN s.Code='APPROVED' OR s.Code = 'REJECTED' THEN 
					CASE 
						WHEN b.VettingBatchTypeID = 1 THEN 
							DateAdd(year,1,pv.VettingStatusDate) 
						ELSE  
							lh.ExpiresDate 
					END 
				ELSE 
					NULL 
			END
	ORDER BY p.LastNames

END