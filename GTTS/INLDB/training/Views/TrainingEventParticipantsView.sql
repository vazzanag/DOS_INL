CREATE VIEW [training].[TrainingEventParticipantsView]
AS 
		SELECT tpt.[Name] AS ParticipantType, s.TrainingEventID, TrainingEventParticipantID, s.IsParticipant, s.RemovedFromEvent,
			   d.CityName AS DepartureCity, s.DepartureDate, s.ReturnDate, s.PersonID, s.PersonsVettingID, s.IsTraveling, s.OnboardingComplete, vc.VisaStatusID, v.Code AS VisaStatus, 
			   p.FirstMiddleNames, p.LastNames, p.Gender, p.ContactEmail, p.DOB, p.IsUSCitizen, g.TrainingEventGroupID, g.GroupName, 
			   vt.VettingPersonStatusID, vt.VettingPersonStatus, vt.VettingPersonStatusDate, vt.VettingBatchTypeID, vt.VettingBatchType, 
			   vt.VettingBatchStatusID, vt.VettingBatchStatus, vt.VettingBatchStatusDate, ve.Name AS VettingTrainingEventName,
			   i.JobTitle, i.RankName, i.AgencyName, i.AgencyNameEnglish, i.UnitName, i.UnitNameEnglish, i.UnitParentName, i.UnitParentNameEnglish,
			   i.IsLeahyVettingReq, i.IsVettingReq, i.IsValidated, i.UnitID, vt.RemovedFromVetting, i.PersonsUnitLibraryInfoID, s.CreatedDate, p.NationalID,

			   -- Document Count
			   (SELECT COUNT(@@ROWCOUNT) 
				 FROM training.TrainingEventParticipantAttachmentsView a 
				WHERE a.PersonID = s.PersonID AND a.TrainingEventID = s.TrainingEventID AND (a.IsDeleted IS NULL OR a.IsDeleted = 0)) AS DocumentCount,
		   
			   -- CourtesyVettings
			   (SELECT PersonsVettingID, VettingTypeCode, CourtesyVettingSkipped, HitResultCode
				  FROM vetting.PersonsVettingVettingTypesView pvvtv
				 WHERE pvvtv.PersonsVettingID = vt.PersonsVettingID FOR JSON PATH, INCLUDE_NULL_VALUES) CourtesyVettingsJSON

		  FROM [training].[TrainingEventParticipants] s
		  INNER JOIN [training].[TrainingEventParticipantTypes] tpt ON tpt.TrainingEventParticipantTypeID = s.TrainingEventParticipantTypeID
	 LEFT JOIN training.TrainingEventGroupMembersView g      ON s.PersonID = g.PersonID  AND g.TrainingEventID = s.TrainingEventID
	 LEFT JOIN training.TrainingEventRosterView ro      ON s.TrainingEventID = ro.TrainingEventID AND s.PersonID = ro.PersonID
	 LEFT JOIN persons.Persons p                     ON s.PersonID = p.PersonID
	 LEFT JOIN persons.PersonsUnitLibraryInfoView i     ON p.PersonID = i.PersonID AND i.IsActive = 1
     LEFT JOIN training.TrainingEventVisaCheckLists vc on p.PersonID = vc.PersonID and s.TrainingEventID = vc.TrainingEventID
	 LEFT JOIN training.VisaStatuses v                  ON vc.VisaStatusID = v.VisaStatusID
	 LEFT JOIN [location].CitiesView d                  ON s.DepartureCityID = d.CityID
	 LEFT JOIN persons.Ranks r                           ON i.RankID = r.RankID
   OUTER APPLY (SELECT TOP 1 b.TrainingEventID, v.PersonsVettingID, v.VettingPersonStatusID, 
                       ps.Code AS VettingPersonStatus, v.VettingStatusDate AS VettingPersonStatusDate,  
					   b.VettingBatchTypeID, t.Code AS VettingBatchType,
					   b.VettingBatchStatusID, bs.Code AS VettingBatchStatus, v.RemovedFromVetting AS RemovedFromVetting,
						(CASE WHEN b.VettingBatchStatusID = 1 THEN DateSubmitted
							  WHEN b.VettingBatchStatusID = 2 THEN DateAccepted
							  WHEN b.VettingBatchStatusID = 3 THEN b.ModifiedDate
							  WHEN b.VettingBatchStatusID = 4 THEN DateSentToCourtesy
							  WHEN b.VettingBatchStatusID = 5 THEN DateCourtesyCompleted
							  WHEN b.VettingBatchStatusID = 6 THEN DateSentToLeahy
							  WHEN b.VettingBatchStatusID = 7 THEN DateVettingResultsNotified 
							  ELSE b.ModifiedDate END) AS VettingBatchStatusDate
							  FROM [vetting].[PersonsVetting] v
		     LEFT JOIN [vetting].VettingPersonStatuses  ps ON v.VettingPersonStatusID = ps.VettingPersonStatusID
		     LEFT JOIN [vetting].VettingBatches         b ON v.VettingBatchID = b.VettingBatchID AND s.TrainingEventID = b.TrainingEventID
		     LEFT JOIN [vetting].[VettingBatchTypes]    t ON b.VettingBatchTypeID = t.VettingBatchTypeID
		     LEFT JOIN vetting.VettingBatchStatuses bs on b.VettingBatchStatusID = bs.VettingBatchStatusID
		    INNER JOIN [persons].PersonsUnitLibraryInfo u ON v.PersonsUnitLibraryInfoID = u.PersonsUnitLibraryInfoID
			 	 WHERE u.PersonID = s.PersonID AND ISNULL(v.IsReVetting,0) = 0
			  ORDER BY VettingStatusDate DESC) vt
     LEFT JOIN training.TrainingEvents ve				 ON vt.TrainingEventID = ve.TrainingEventID
