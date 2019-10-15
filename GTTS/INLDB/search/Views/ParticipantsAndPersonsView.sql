CREATE VIEW [search].[ParticipantsAndPersonsView]
AS 
		SELECT ParticipantType, p.PersonID, FirstMiddleNames, LastNames, DOB, Gender, JobTitle, JobRank,
			   CountryID, CountryName, CountryFullName, UnitName, UnitNameEnglish, UnitMainAgencyID, ChildUnits,
               AgencyName, AgencyNameEnglish, VettingStatus, VettingStatusDate, VettingType, Distinction, Max(p.EventStartDate) EventStartDate
		  FROM (
				SELECT tpt.[Name] AS ParticipantType, s.PersonID, p.FirstMiddleNames, p.LastNames, p.DOB, p.Gender, uli.JobTitle, uli.RankName AS JobRank,
						c.CountryID, c.CountryName, c.CountryFullName, uli.UnitID, u.UnitName, u.UnitNameEnglish, u.UnitMainAgencyID, u.ChildUnits,
                        CASE WHEN u.IsMainAgency = 1 THEN u.UnitName ELSE a.UnitName END AS AgencyName,
                        CASE WHEN u.IsMainAgency = 1 THEN u.UnitNameEnglish ELSE a.UnitNameEnglish END AS AgencyNameEnglish,
						v.Code AS VettingStatus, v.VettingStatusDate, v.VettyingTypeCode AS VettingType, d.Code AS Distinction, t.EventStartDate
				  FROM [training].[TrainingEventParticipants] s
			INNER JOIN [training].[TrainingEventParticipantTypes] tpt ON tpt.TrainingEventParticipantTypeID = s.TrainingEventParticipantTypeID
			INNER JOIN training.TrainingEventsView t ON s.TrainingEventID = t.TrainingEventID
			INNER JOIN persons.Persons p ON s.PersonID = p.PersonID 
			INNER JOIN persons.PersonsUnitLibraryInfoView uli ON p.PersonID = uli.PersonID and uli.IsActive = 1
			INNER JOIN unitlibrary.Units u ON uli.UnitID = u.UnitID
            INNER JOIN [location].Countries c ON u.CountryID = c.CountryID
			 LEFT JOIN training.TrainingEventRosters r ON s.PersonID = r.PersonID
			 LEFT JOIN training.TrainingEventRosterDistinctions d ON r.TrainingEventRosterDistinctionID = d.TrainingEventRosterDistinctionID
             LEFT JOIN unitlibrary.Units a ON u.UnitMainAgencyID = a.UnitID
			OUTER APPLY  
						(
							SELECT TOP 1 v.VettingPersonStatusID, s.Code, v.VettingStatusDate, b.VettingBatchTypeID, t.Code AS VettyingTypeCode
							  FROM [vetting].[PersonsVetting] v
						 LEFT JOIN [vetting].VettingPersonStatuses  s ON v.VettingPersonStatusID = s.VettingPersonStatusID
						 LEFT JOIN [vetting].VettingBatches         b ON v.VettingBatchID = b.VettingBatchID
						 LEFT JOIN [vetting].[VettingBatchTypes]    t ON b.VettingBatchTypeID = t.VettingBatchTypeID
						INNER JOIN [persons].PersonsUnitLibraryInfo u ON v.PersonsUnitLibraryInfoID = u.PersonsUnitLibraryInfoID
							 WHERE u.PersonID = p.PersonID
						  ORDER BY VettingStatusDate DESC
						) AS v
			) p
	INNER JOIN (
				SELECT personid, max(eventstartdate) eventstartdate
				  FROM (
						SELECT PersonID, t.EventStartDate
						  FROM [training].[TrainingEventParticipants] s
					INNER JOIN training.TrainingEventsView t ON s.TrainingEventID = t.TrainingEventID				
					   ) x GROUP BY PersonID
			   ) w ON p.PersonID = w.PersonID and (p.EventStartDate = w.EventStartDate)
	  GROUP BY p.PersonID, ParticipantType, FirstMiddleNames, LastNames, DOB, Gender, JobTitle, JobRank,
					CountryID, CountryName, CountryFullName, UnitID, UnitName, UnitNameEnglish, UnitMainAgencyID, ChildUnits,
					AgencyName, AgencyNameEnglish, VettingStatus, VettingStatusDate, VettingType, Distinction
UNION
		SELECT 'Other' as ParticipantType, p.PersonID, p.FirstMiddleNames, p.LastNames, p.DOB, p.Gender, uli.JobTitle, r.RankName AS JobRank,
			   c.CountryID, c.CountryName, c.CountryFullName, u.UnitName, u.UnitNameEnglish, u.UnitMainAgencyID, null AS ChildUnits,
               CASE WHEN u.IsMainAgency = 1 THEN u.UnitName ELSE a.UnitName END AS AgencyName,
               CASE WHEN u.IsMainAgency = 1 THEN u.UnitNameEnglish ELSE a.UnitNameEnglish END AS AgencyNameEnglish,
			   v.Code AS VettingStatus, v.VettingStatusDate, v.VettyingTypeCode AS VettingType, '' AS Distinction, null as  TrainingDate
		  FROM persons.Persons p 
	 LEFT JOIN persons.PersonsUnitLibraryInfo uli ON p.PersonID = uli.PersonID AND uli.IsActive = 1
	 left JOIN persons.Ranks r on uli.RankID = r.RankID
	 LEFT JOIN unitlibrary.Units u ON uli.UnitID = u.UnitID
     LEFT JOIN unitlibrary.Units a ON u.UnitMainAgencyID = a.UnitID
	 LEFT JOIN [location].Countries c ON u.CountryID = c.CountryID
   OUTER APPLY  
				(
					SELECT TOP 1 v.VettingPersonStatusID, s.Code, v.VettingStatusDate, b.VettingBatchTypeID, t.Code AS VettyingTypeCode
						FROM [vetting].[PersonsVetting] v
					LEFT JOIN [vetting].VettingPersonStatuses  s ON v.VettingPersonStatusID = s.VettingPersonStatusID
					LEFT JOIN [vetting].VettingBatches         b ON v.VettingBatchID = b.VettingBatchID
					LEFT JOIN [vetting].[VettingBatchTypes]    t ON b.VettingBatchTypeID = t.VettingBatchTypeID
				INNER JOIN [persons].PersonsUnitLibraryInfo u ON v.PersonsUnitLibraryInfoID = u.PersonsUnitLibraryInfoID
						WHERE u.PersonID = p.PersonID
					ORDER BY VettingStatusDate DESC
				) AS v
	 LEFT JOIN (
				SELECT PersonID FROM [training].[TrainingEventParticipants]			
				) j ON p.PersonID = j.PersonID
		 WHERE j.PersonID IS NULL;