CREATE VIEW [search].[ParticipantsView]
AS 
        SELECT s.ParticipantType, s.PersonID, p.FirstMiddleNames, p.LastNames, p.DOB, p.Gender, i.JobTitle, r.RankName AS JobRank, 
               u.CountryID, c.CountryName, C.CountryFullName, u.UnitID, u.UnitName, u.UnitNameEnglish, u.UnitMainAgencyID, 
               au.UnitName AS AgencyName, au.UnitNameEnglish AS AgencyNameEnglish, 
               VettingPersonStatus AS VettingStatus, VettingPersonStatusDate AS VettingStatusDate, VettingBatchType AS VettingType, s.Distinction,
               (SELECT MIN(EventStartDate) FROM training.TrainingEventLocations WHERE TrainingEventID = s.TrainingEventID) AS EventStartDate,

               s.TrainingEventID, s.ParticipantID AS TrainingEventParticipantID, s.IsParticipant, s.RemovedFromEvent,
			   d.CityName AS DepartureCity, s.DepartureDate, s.ReturnDate, vt.PersonsVettingID, s.IsTraveling, s.OnboardingComplete, vc.VisaStatusID, 
               v.Code AS VisaStatus, p.ContactEmail, p.IsUSCitizen, g.TrainingEventGroupID, g.GroupName, 
			   vt.VettingPersonStatusID, vt.VettingPersonStatus, vt.VettingPersonStatusDate, vt.VettingBatchTypeID, vt.VettingBatchType, 
			   vt.VettingBatchStatusID, vt.VettingBatchStatus, vt.VettingBatchStatusDate, vt.RemovedFromVetting, 
			   t.[Name] AS VettingTrainingEventName, i.IsLeahyVettingReq, i.IsVettingReq, i.IsValidated, i.PersonsUnitLibraryInfoID,
               p.NationalID, u.UnitTypeID, u.UnitAcronym, 
		       pu.UnitName AS UnitParentName, pu.UnitNameEnglish AS UnitParentNameEnglish, ut.Name AS UnitType, 
				
			   -- Document Count
			   (SELECT COUNT(@@ROWCOUNT) 
				  FROM training.TrainingEventParticipantAttachmentsView a 
			     WHERE a.PersonID = s.PersonID AND a.TrainingEventID = s.TrainingEventID AND (a.IsDeleted IS NULL OR a.IsDeleted = 0)) AS DocumentCount,
		   
			   -- CourtesyVettings
			   (SELECT PersonsVettingID, VettingTypeCode, CourtesyVettingSkipped, HitResultCode
				  FROM vetting.PersonsVettingVettingTypesView pvvtv
				 WHERE pvvtv.PersonsVettingID = vt.PersonsVettingID FOR JSON PATH, INCLUDE_NULL_VALUES) CourtesyVettingsJSON

	      FROM
	         (
		        SELECT tpt.[Name] AS ParticipantType, 
		               s.PersonID, s.TrainingEventParticipantID AS ParticipantID, s.TrainingEventID, s.IsVIP, s.IsParticipant, s.IsTraveling, s.DepartureCityID,
		               s.DepartureDate, s.ReturnDate, s.VisaStatusID, s.HasLocalGovTrust, s.PassedLocalGovTrust, s.OnboardingComplete,
			           s.LocalGovTrustCertDate, s.OtherVetting, s.PassedOtherVetting, s.OtherVettingDescription, 
			           s.OtherVettingDate, s.PaperworkStatusID,s.TravelDocumentStatusID,s.RemovedFromEvent,s.RemovalReasonID,
			           s.RemovalCauseID, s.DateCanceled,s.Comments, s.ModifiedByAppUserID, s.ModifiedDate, d.Code AS Distinction
		          FROM [training].[TrainingEventParticipants] s WITH (NOLOCK)
				  INNER JOIN [training].[TrainingEventParticipantTypes] tpt ON tpt.TrainingEventParticipantTypeID = s.TrainingEventParticipantTypeID
			INNER JOIN training.TrainingEventLocations         l ON s.TrainingEventID = l.TrainingEventID
			 LEFT JOIN training.TrainingEventRosters            r ON s.PersonID = r.PersonID
			 LEFT JOIN training.TrainingEventRosterDistinctions d ON r.TrainingEventRosterDistinctionID = d.TrainingEventRosterDistinctionID
	         ) AS s
     LEFT JOIN training.TrainingEventGroupMembersView g WITH (NOLOCK)   ON s.PersonID = g.PersonID  AND g.TrainingEventID = s.TrainingEventID
     LEFT JOIN training.TrainingEventRosterView ro WITH (NOLOCK)        ON s.TrainingEventID = ro.TrainingEventID AND s.PersonID = ro.PersonID
     LEFT JOIN persons.Persons p WITH (NOLOCK)                          ON s.PersonID = p.PersonID
     LEFT JOIN persons.PersonsUnitLibraryInfo i WITH (NOLOCK)           ON p.PersonID = i.PersonID AND i.IsActive = 1
     LEFT JOIN training.TrainingEventVisaCheckLists vc WITH (NOLOCK)    on p.PersonID = vc.PersonID and s.TrainingEventID = vc.TrainingEventID
     LEFT JOIN training.VisaStatuses v WITH (NOLOCK)                    ON vc.VisaStatusID = v.VisaStatusID
     LEFT JOIN [location].CitiesView d WITH (NOLOCK)                    ON s.DepartureCityID = d.CityID
     LEFT JOIN persons.Ranks r WITH (NOLOCK)                            ON i.RankID = r.RankID
	 LEFT JOIN training.TrainingEvents t WITH (NOLOCK)				    ON s.TrainingEventID = t.TrainingEventID
     LEFT JOIN unitlibrary.Units u WITH (NOLOCK)                        ON u.UnitID = i.UnitID
     LEFT JOIN unitlibrary.Units pu WITH (NOLOCK)                       ON pu.UnitID = u.UnitParentID
     LEFT JOIN unitlibrary.Units au WITH (NOLOCK)                       ON au.UnitID = u.UnitMainAgencyID
     LEFT JOIN unitlibrary.UnitTypes ut WITH (NOLOCK)                   ON u.UnitTypeID = ut.UnitTypeID
	 LEFT JOIN [location].Countries c WITH (NOLOCK)						ON u.CountryID = c.CountryID
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
			 	 WHERE u.PersonID = s.PersonID
			  ORDER BY VettingStatusDate DESC) vt;