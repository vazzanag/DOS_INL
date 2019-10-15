CREATE VIEW [search].[StudentsView]
AS 
     SELECT I.PersonID, p.FirstMiddleNames, p.LastNames, p.DOB, p.Gender, uli.JobTitle, uli.RankID AS JobRank,
            c.CountryID, c.CountryName, c.CountryFullName, u.UnitName, u.UnitNameEnglish, u.UnitMainAgencyID,
            v.Code AS VettingStatus, v.VettingStatusDate, v.VettyingTypeCode AS VettingType, '!!TODO!!' AS Distinction
       FROM [training].[TrainingEventParticipants] i
	   INNER JOIN [training].[TrainingEventParticipantTypes] tpt ON tpt.TrainingEventParticipantTypeID = i.TrainingEventParticipantTypeID
 INNER JOIN persons.Persons                  p ON i.PersonID = p.PersonID 
 INNER JOIN persons.PersonsUnitLibraryInfo uli ON p.PersonID = uli.PersonID
 INNER JOIN unitlibrary.Units                u ON uli.UnitID = u.UnitID
 INNER JOIN [location].Countries             c ON u.CountryID = c.CountryID
OUTER APPLY  
            (
				SELECT TOP 1 v.VettingPersonStatusID, s.Code, v.VettingStatusDate, b.VettingBatchTypeID, t.Code AS VettyingTypeCode
				  FROM [vetting].[PersonsVetting] v
			 LEFT JOIN [vetting].VettingPersonStatuses  s ON v.VettingPersonStatusID = s.VettingPersonStatusID
			 LEFT JOIN [vetting].VettingBatches         b ON v.VettingBatchID = b.VettingBatchID
			 LEFT JOIN [vetting].[VettingBatchTypes]    t ON b.VettingBatchTypeID = t.VettingBatchTypeID
			INNER JOIN [persons].PersonsUnitLibraryInfo u ON v.PersonsUnitLibraryInfoID = u.PersonsUnitLibraryInfoID
				 WHERE b.VettingBatchStatusID = 8 
                   AND u.PersonID = p.PersonID
			  ORDER BY VettingStatusDate DESC
			) AS v
			WHERE I.TrainingEventParticipantTypeID != 2 -- all students
GO