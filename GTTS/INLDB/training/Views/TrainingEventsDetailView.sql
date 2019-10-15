CREATE VIEW [training].[TrainingEventsDetailView]
AS 
     SELECT e.TrainingEventID, e.[Name], e.NameInLocalLang, tet.TrainingEventTypeID, tet.[Name] AS TrainingEventTypeName, 
	        e.Justification, e.Objectives, e.ParticipantProfile, e.SpecialRequirements, e.ProgramID,
			e.TrainingUnitID, b.Acronym AS BusinessUnitAcronym, b.BusinessUnitName, 
			e.CountryID, e.PostID, e.ConsularDistrictID, e.OrganizerAppUserID,
			e.PlannedParticipantCnt, e.PlannedMissionDirectHireCnt, e.PlannedNonMissionDirectHireCnt, 
			e.PlannedMissionOutsourceCnt, e.PlannedOtherCnt, e.ActualBudget,
            e.EstimatedBudget, e.EstimatedStudents, e.FundingSourceID, e.AuthorizingLawID, e.Comments,
			e.ModifiedByAppUserID, e.SysStartTime AS ModifiedDate,
           
           -- Start and End dates (based on Training Event Locations)
           (SELECT MIN(CAST(el.EventStartDate AS DATE)) FROM training.TrainingEventLocations el WHERE TrainingEventID = e.TrainingEventID) EventStartDate,
           (SELECT MAX(CAST(el.EventEndDate AS DATE))   FROM training.TrainingEventLocations el WHERE TrainingEventID = e.TrainingEventID) EventEndDate,

           -- Travel Start and End dates (based on Training Event Locations)
           (SELECT MIN(CAST(el.TravelStartDate AS DATE)) FROM training.TrainingEventLocations el WHERE TrainingEventID = e.TrainingEventID) TravelStartDate,
           (SELECT MAX(CAST(el.TravelEndDate AS DATE))   FROM training.TrainingEventLocations el WHERE TrainingEventID = e.TrainingEventID) TravelEndDate,

           -- Student and Instructor counts
           (SELECT COUNT(par.PersonID)     FROM [training].[TrainingEventParticipants] par WHERE TrainingEventID = e.TrainingEventID AND par.TrainingEventParticipantTypeID != 2) StudentCount,
           (SELECT COUNT(par.PersonID)     FROM [training].[TrainingEventParticipants] par WHERE TrainingEventID = e.TrainingEventID AND par.TrainingEventParticipantTypeID = 2) InstructorCount,

           -- Student and Instructor counts
		   (SELECT TrainingEventGroupID,GroupName, MAX(Students) Students, MAX(Instructors) Instructors
		     FROM (
					   SELECT COUNT(@@ROWCOUNT) 'Students', null as Instructors, ISNULL(GroupName,'NONE') 'GroupName', TrainingEventGroupID
						 FROM (
								SELECT s.PersonID, s.TrainingEventID, grp.TrainingEventGroupID, grp.GroupName
								  FROM [training].[TrainingEventParticipants] s
								LEFT JOIN training.TrainingEventGroupMembersView grp on s.PersonID = grp.PersonID and grp.TrainingEventID = s.TrainingEventID
								WHERE s.TrainingEventID = e.TrainingEventID AND s.TrainingEventParticipantTypeID != 2
							  ) c
					 GROUP BY TrainingEventGroupID, GroupName
					 UNION
					   SELECT null as Students, COUNT(@@ROWCOUNT) 'Instructors', ISNULL(GroupName,'NONE') 'GroupName', TrainingEventGroupID
						 FROM (
								SELECT s.PersonID, s.TrainingEventID, grp.TrainingEventGroupID, grp.GroupName
								  FROM [training].[TrainingEventParticipants] s
								LEFT JOIN training.TrainingEventGroupMembersView grp on s.PersonID = grp.PersonID and grp.TrainingEventID = s.TrainingEventID
								WHERE s.TrainingEventID = e.TrainingEventID AND s.TrainingEventParticipantTypeID = 2
							  ) c
					 GROUP BY TrainingEventGroupID, GroupName 
				  ) b
			GROUP BY GroupName, TrainingEventGroupID FOR JSON PATH, INCLUDE_NULL_VALUES) ParticipantCountsJSON,

           -- Current Status
           (SELECT TOP 1 TrainingEventStatusID 
             FROM training.TrainingEventStatusLogView 
            WHERE TrainingEventID = e.TrainingEventID ORDER BY ModifiedDate DESC) TrainingEventStatusID,

            (SELECT TOP 1 TrainingEventStatus 
             FROM training.TrainingEventStatusLogView 
            WHERE TrainingEventID = e.TrainingEventID ORDER BY ModifiedDate DESC) TrainingEventStatus,

           -- Modified By User
           (SELECT AppUserID, ADOID, [First], [Middle], [Last], FullName, PositionTitle, EmailAddress, PhoneNumber, PicturePath 
              FROM users.AppUsersView 
             WHERE AppUserID = e.ModifiedByAppUserID FOR JSON PATH, INCLUDE_NULL_VALUES) ModifiedByUserJSON,
			             
            -- Project Codes
           (SELECT TrainingEventID, ProjectCodeID, Code, [Description], ModifiedByAppUserID, ModifiedDate
	          FROM training.TrainingEventProjectCodesView u
	         WHERE u.TrainingEventID = e.TrainingEventID FOR JSON PATH) ProjectCodesJSON,
            
            -- Locations
           (SELECT TrainingEventLocationID, TrainingEventID, LocationID, 
		           EventStartDate, EventEndDate, TravelStartDate, TravelEndDate, 
				   ModifiedByAppUserID, ModifiedDate,
				   LocationName, AddressLine1, AddressLine2, AddressLine3, 
				   CityID, CityName, 
			       StateID, StateName, StateCodeA2, StateAbbreviation, StateINKCode,
				   CountryID,CountryName, CountryINKCode,
			       GENCCodeA2, CountryAbbreviation
	          FROM training.TrainingEventLocationsView u
	         WHERE u.TrainingEventID = e.TrainingEventID FOR JSON PATH) LocationsJSON,			 

           -- US Partner Agencies 
           (SELECT TrainingEventID, AgencyID, a.[Name], Initials, a.ModifiedByAppUserID, a.ModifiedDate
              FROM training.TrainingEventUSPartnerAgenciesView a
             WHERE a.TrainingEventID = e.TrainingEventID FOR JSON PATH) USPartnerAgenciesJSON,

           -- IAAs
           (SELECT a.TrainingEventID, a.IAAID, a.IAAsAsJSON, ModifiedByUserAsJSON
              FROM training.TrainingEventAuthorizingDocumentsView a
             WHERE a.TrainingEventID = e.TrainingEventID FOR JSON PATH) IAAsJSON,

           -- Stakeholders 
           (SELECT b.TrainingEventID, b.AppUserID, b.[First], b.Middle, b.[Last], b.FullName, b.PositionTitle, b.EmailAddress, b.PhoneNumber
              FROM training.TrainingEventStakeholdersView b
             WHERE b.TrainingEventID = e.TrainingEventID FOR JSON PATH, INCLUDE_NULL_VALUES) StakeholdersJSON,

           -- Attachments 
           (SELECT a.TrainingEventID, a.TrainingEventAttachmentID, a.FileID, a.FileVersion, a.[FileName], a.TrainingEventAttachmentTypeID, a.TrainingEventAttachmentType,
				   a.ModifiedByAppUserID, a.ModifiedDate			  
			  FROM training.TrainingEventAttachmentsView a
             WHERE a.TrainingEventID = e.TrainingEventID FOR JSON PATH, INCLUDE_NULL_VALUES) AttachmentsJSON,
           
           -- Organizer
           (SELECT top 1 u.AppUserID, ADOID, [First], [Middle], [Last], FullName, PositionTitle, EmailAddress, PhoneNumber, PicturePath
              FROM users.AppUsersView u
             WHERE u.AppUserID = e.OrganizerAppUserID FOR JSON PATH, INCLUDE_NULL_VALUES) OrganizerJSON,

			-- Course Programs
			(SELECT cdp.CourseProgram 
				FROM [training].[TrainingEventCourseDefinitionsView] cdp WHERE cdp.TrainingEventID = e.TrainingEventID FOR JSON PATH) CourseProgramJSON,

            -- Key Activities
           (SELECT k.KeyActivityID, k.Code, k.[Description]
	          FROM training.TrainingEventKeyActivitiesView k
	         WHERE k.TrainingEventID = e.TrainingEventID FOR JSON PATH) KeyActivitiesJSON

           -- Who Implemented (Not yet implemented as of GTTS-366)
           --(SELECT top 1 u.AppUserID, ADOID, [First], [Middle], [Last], FullName, EmailAddress, PhoneNumber, PicturePath, PayGradeID, ModifiedByAppUserID, ModifiedDate
           --   FROM users.AppUsersView u
           --  WHERE u.AppUserID = e.{Who Implemented} FOR JSON PATH, INCLUDE_NULL_VALUES) WhoImplementedJSON

      FROM training.TrainingEvents e
INNER JOIN users.BusinessUnits b ON e.TrainingUnitID = b.BusinessUnitID
INNER JOIN training.TrainingEventTypes tet ON e.TrainingEventTypeID = tet.TrainingEventTypeID;