CREATE VIEW [search].[PersonsView]
AS
        SELECT p.PersonID, CONCAT(FirstMiddleNames, ' ', LastNames) AS FullName, FirstMiddleNames, LastNames, DOB, Gender, JobTitle, RankName, NationalID, r.RankName AS JobRank,
		        u.CountryID, CountryName, CountryFullName, u.UnitID, UnitName, UnitNameEnglish, UnitAcronym, u.UnitMainAgencyID,
		        CASE WHEN u.IsMainAgency = 1 THEN u.UnitName ELSE (select UnitName from unitlibrary.Units WHERE UnitID = u.UnitMainAgencyID) END AS AgencyName,
		        CASE WHEN u.IsMainAgency = 1 THEN u.UnitNameEnglish ELSE (select UnitNameEnglish from unitlibrary.Units WHERE UnitID = u.UnitMainAgencyID) END AS AgencyNameEnglish
		        ,v.Code AS VettingStatus, v.VettingStatusDate, v.VettyingTypeCode AS VettingType
		        ,t.ParticipantType, t.Distinction, t.EventStartDate
          FROM persons.Persons p
    INNER JOIN persons.PersonsUnitLibraryInfo           i ON p.PersonID = i.PersonID and i.IsActive = 1
    INNER JOIN unitlibrary.Units                        u ON i.UnitID = u.UnitID
    INNER JOIN [location].Countries                     c ON u.CountryID = c.CountryID
     LEFT JOIN persons.Ranks                            r ON i.RankID = r.RankID
     LEFT JOIN training.TrainingEventRosters           er ON i.PersonID = er.PersonID
     LEFT JOIN training.TrainingEventRosterDistinctions d ON er.TrainingEventRosterDistinctionID = d.TrainingEventRosterDistinctionID
   OUTER APPLY
   (
	     SELECT TOP 1 ParticipantType, PersonID, EventStartDate,
		 (SELECT top 1 d.Code
		               FROM [training].[TrainingEventParticipants] s
		         INNER JOIN training.TrainingEventLocations         l ON s.TrainingEventID = l.TrainingEventID
		          LEFT JOIN training.TrainingEventRosters            r ON s.PersonID = r.PersonID
		          LEFT JOIN training.TrainingEventRosterDistinctions d ON r.TrainingEventRosterDistinctionID = d.TrainingEventRosterDistinctionID
		              WHERE s.PersonID = x.PersonID 
                        AND l.EventStartDate = x.EventStartDate)
	            AS Distinction
	       FROM 
	       (
		            SELECT MAX(tpt.[Name]) AS ParticipantType, s.PersonID, max(l.EventStartDate) as EventStartDate
		              FROM [training].[TrainingEventParticipants]  s
					  INNER JOIN [training].[TrainingEventParticipantTypes] tpt ON tpt.TrainingEventParticipantTypeID = s.TrainingEventParticipantTypeID
		        INNER JOIN training.TrainingEventLocations l ON s.TrainingEventID = l.TrainingEventID
		             WHERE PersonID = p.PersonID
		          GROUP BY s.PersonID
	       ) x
	   ORDER BY EventStartDate DESC
   ) AS t
   OUTER APPLY  
   (
		    SELECT TOP 1 s.Code, v.VettingStatusDate, t.Code AS VettyingTypeCode
			  FROM [vetting].[PersonsVetting]       v WITH(INDEX(IDX_PersonsVetting_PersonsUnitLibraryInfoID))
		INNER JOIN [persons].PersonsUnitLibraryInfo u WITH(INDEX(IDX_PersonID)) ON v.PersonsUnitLibraryInfoID = u.PersonsUnitLibraryInfoID
		INNER JOIN [vetting].VettingPersonStatuses  s ON v.VettingPersonStatusID = s.VettingPersonStatusID
		INNER JOIN [vetting].VettingBatches         b ON v.VettingBatchID = b.VettingBatchID
		INNER JOIN [vetting].[VettingBatchTypes]    t ON b.VettingBatchTypeID = t.VettingBatchTypeID
			 WHERE u.PersonID = p.PersonID
		  ORDER BY VettingStatusDate DESC
   ) AS v
GO