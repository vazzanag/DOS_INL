
CREATE VIEW [training].[TrainingEventParticipantsDetailView]
AS 
    
	SELECT 
		participant.ParticipantType, participant.ParticipantID, 
		participant.TrainingEventID, participant.IsVIP, participant.IsParticipant, participant.IsTraveling, 
		p.PersonID, p.FirstMiddleNames, p.LastNames, p.Gender,

		puli.PersonsUnitLibraryInfoID, puli.PoliceMilSecID, puli.JobTitle, puli.RankID, r.RankName, 
		puli.YearsInPosition, puli.IsValidated, puli.IsUnitCommander,
		puli.IsVettingReq, puli.IsLeahyVettingReq, puli.HostNationPOCName, puli.HostNationPOCEmail,
		
		u.UnitID, u.UnitName, u.UnitNameEnglish, u.UnitMainAgencyID, u.UnitTypeID, 		
		pu.UnitName AS UnitParentName, pu.UnitNameEnglish AS UnitParentNameEnglish, ut.Name AS UnitType, 
		au.UnitName AS AgencyName, au.UnitNameEnglish AS AgencyNameEnglish, 

		p.IsUSCitizen, p.NationalID, 
		p.ResidenceLocationID, CONCAT_WS(' ', resl.AddressLine1, resl.AddressLine2, resl.AddressLine3) AS ResidenceStreetAddress, 
		resl.CityID AS ResidenceCityID, resl.StateID AS ResidenceStateID, resl.CountryID AS ResidenceCountryID, 
		p.POBCityID, pobc.CityName AS POBCityName, pobc.StateID AS POBStateID, pobc.StateName AS POBStateName, pobc.CountryID AS POBCountryID, pobc.CountryName AS POBCountryName, 
		p.ContactEmail, p.ContactPhone, p.DOB, p.FatherName, p.MotherName, p.HighestEducationID, p.FamilyIncome, p.EnglishLanguageProficiencyID,
		p.PassportNumber, p.PassportExpirationDate, p.PassportIssuingCountryID, p.MedicalClearanceStatus,
		p.MedicalClearanceDate, p.PsychologicalClearanceStatus, p.PsychologicalClearanceDate, 

		dc.CountryID AS DepartureCountryID, dc.StateID AS DepartureStateID, dc.CityID AS DepartureCityID, dc.CityName AS DepartureCity, participant.DepartureDate, dc.StateName AS DepartureState, participant.ReturnDate, 
		
		vt.VettingPersonStatusID, vs.Code  AS VettingPersonStatus,
		b.VettingBatchTypeID, b.TrainingEventID AS VettingTrainingEventID, b.VettingBatchName AS VettingTrainingEventName, 
		vbt.Code AS VettingBatchType, b.VettingBatchStatusID, vt.VettingStatusDate AS VettingPersonStatusDate, vt.PersonsVettingID, vbs.Code AS VettingBatchStatus, vt.IsReVetting,

		participant.VisaStatusID, v.Code AS VisaStatus, participant.HasLocalGovTrust, participant.PassedLocalGovTrust, participant.OnboardingComplete,
		participant.LocalGovTrustCertDate, participant.OtherVetting, participant.PassedOtherVetting, participant.OtherVettingDescription, 
		participant.OtherVettingDate, participant.PaperworkStatusID, participant.TravelDocumentStatusID, participant.RemovedFromEvent, participant.RemovalReasonID, rr.[Description] as RemovalReason, vt.RemovedFromVetting, 
		participant.RemovalCauseID, rc.[Description] as RemovalCause, rosd.Code AS TrainingEventRosterDistinction,
		participant.DateCanceled, participant.Comments, g.TrainingEventGroupID, g.GroupName, participant.ModifiedByAppUserID, participant.ModifiedDate, participant.CreatedDate,
		(SELECT COUNT(a.TrainingEventStudentAttachmentID) FROM training.TrainingEventStudentAttachments a WHERE a.PersonID = participant.PersonID AND a.TrainingEventID = participant.TrainingEventID) AS DocumentCount,
		   
        -- Person Languages
        (SELECT PersonID, pl.LanguageID, pl.LanguageProficiencyID, l.Code AS LanguageCode, l.[Description] AS LanguageDescription,
		         lp.Code AS LanguageProficiencyCode, lp.[Description] AS LanguageProficiencyDescription, pl.ModifiedByAppUserID		   
          FROM persons.PersonLanguages pl
		  INNER JOIN [location].Languages l ON pl.LanguageID = l.LanguageID
		  INNER JOIN [location].LanguageProficiencies lp ON pl.LanguageProficiencyID = lp.LanguageProficiencyID
          WHERE pl.PersonID = participant.PersonID FOR JSON PATH, INCLUDE_NULL_VALUES) PersonLanguagesJSON,

		---- CourtesyVettings
		(SELECT pvvtv.PersonsVettingID, VettingTypeCode, CourtesyVettingSkipped, HitResultCode
		 FROM vetting.PersonsVettingVettingTypesView pvvtv
		 WHERE vt.PersonsVettingID = pvvtv.PersonsVettingID FOR JSON PATH, INCLUDE_NULL_VALUES) CourtesyVettingsJSON

	FROM
	(
		SELECT tpt.[Name] AS ParticipantType, 
		       s.PersonID, s.TrainingEventParticipantID AS ParticipantID, s.TrainingEventID, s.IsVIP, s.IsParticipant, s.IsTraveling, s.DepartureCityID,
		       s.DepartureDate, s.ReturnDate, s.VisaStatusID, s.HasLocalGovTrust, s.PassedLocalGovTrust, s.OnboardingComplete,
			   s.LocalGovTrustCertDate, s.OtherVetting, s.PassedOtherVetting, s.OtherVettingDescription, 
			   s.OtherVettingDate, s.PaperworkStatusID,s.TravelDocumentStatusID,s.RemovedFromEvent,s.RemovalReasonID,
			   s.RemovalCauseID, s.DateCanceled,s.Comments, s.ModifiedByAppUserID, s.ModifiedDate, s.CreatedDate
		FROM [training].[TrainingEventParticipants] s WITH (NOLOCK)
		INNER JOIN [training].[TrainingEventParticipantTypes] tpt ON tpt.TrainingEventParticipantTypeID = s.TrainingEventParticipantTypeID
	 ) AS participant
	LEFT JOIN persons.Persons p WITH (NOLOCK)                              ON p.PersonID = participant.PersonID 
	LEFT JOIN persons.PersonsUnitLibraryInfo puli WITH (NOLOCK)            ON puli.IsActive = 1 AND p.PersonID = puli.PersonID

	LEFT JOIN vetting.PersonsVetting vt                                    ON vt.PersonsUnitLibraryInfoID = puli.PersonsUnitLibraryInfoID
	LEFT JOIN vetting.VettingPersonStatuses vs							   ON vs.VettingPersonStatusID = vt.VettingPersonStatusID
	LEFT JOIN vetting.VettingBatches b WITH (NOLOCK)				       ON b.VettingBatchID = vt.VettingBatchID
	LEFT JOIN vetting.VettingBatchTypes vbt							       ON vbt.VettingBatchTypeID = b.VettingBatchTypeID
	LEFT JOIN vetting.VettingBatchStatuses vbs						       ON vbs.VettingBatchStatusID = b.VettingBatchStatusID

	LEFT JOIN location.CitiesView pobc WITH (NOLOCK)                       ON p.POBCityID = pobc.CityID
	LEFT JOIN location.LocationsView resl WITH (NOLOCK)                    ON p.ResidenceLocationID = resl.LocationID
	LEFT JOIN location.CitiesView dc WITH (NOLOCK)                         ON participant.DepartureCityID = dc.CityID

	LEFT JOIN training.TrainingEventGroups g WITH (NOLOCK)                 ON g.TrainingEventID = participant.TrainingEventID
	LEFT JOIN training.TrainingEventGroupMembers gm WITH (NOLOCK)          ON gm.PersonID = participant.PersonID AND gm.TrainingEventGroupID = g.TrainingEventGroupID
	LEFT JOIN training.TrainingEventRosters ros WITH (NOLOCK)              ON ros.TrainingEventID = participant.TrainingEventID AND ros.PersonID = participant.PersonID
	LEFT JOIN training.TrainingEventRosterDistinctions rosd WITH (NOLOCK)  ON rosd.TrainingEventRosterDistinctionID = ros.TrainingEventRosterDistinctionID
	LEFT JOIN unitlibrary.Units u WITH (NOLOCK)                            ON u.UnitID = puli.UnitID
	LEFT JOIN unitlibrary.Units pu WITH (NOLOCK)                           ON pu.UnitID = u.UnitParentID
	LEFT JOIN unitlibrary.Units au WITH (NOLOCK)                           ON au.UnitID = u.UnitMainAgencyID
	LEFT JOIN unitlibrary.UnitTypes ut WITH (NOLOCK)                       ON u.UnitTypeID = ut.UnitTypeID
	LEFT JOIN training.VisaStatuses v WITH (NOLOCK)                        ON v.VisaStatusID = participant.VisaStatusID
																	   
	LEFT JOIN persons.Ranks r WITH (NOLOCK)                                ON r.RankID = puli.RankID
	LEFT JOIN training.RemovalReasons rr WITH (NOLOCK)			           ON rr.RemovalReasonID = participant.RemovalReasonID
	LEFT JOIN training.RemovalCauses rc WITH (NOLOCK)			           ON rc.RemovalCauseID = participant.RemovalCauseID;