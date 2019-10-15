CREATE VIEW [training].[TrainingEventParticipantsXLSXView]
	AS 

	SELECT TrainingEventID, ModifiedByAppUserID,
	-- Participants
	(SELECT ParticipantXLSXID, TrainingEventID, p.PersonID AS PersonID, ParticipantStatus,FirstMiddleName, LastName, p.NationalID AS NationalID, 
		   p.Gender AS Gender, IsUSCitizen, p.DOB AS DOB, POBCity, POBState, POBCountry, ResidenceCity, ResidenceState, ResidenceCountry, ContactEmail,
		   ContactPhone, HighestEducation, EnglishLanguageProficiency, PassportNumber, PassportExpirationDate, p.JobTitle AS JobTitle, IsUnitCommander, 
		   YearsInPosition, POCName, POCEmailAddress, [Rank], PoliceMilSecID, VettingType, HasLocalGovTrust, LocalGovTrustCertDate, PassedExternalVetting, 
		   ExternalVettingDate, ExternalVettingDescription, DepartureCity, DepartureCityID, DepartureStateID, DepartureCountryID, p.UnitGenID, UnitBreakdown, UnitAlias, Comments, MarkForAction, LoadStatus, Validations, ImportVersion, 
		   LastVettingTypeID, LastVettingTypeCode, LastVettingStatusID, LastVettingStatusCode, LastVettingStatusDate, VettingValidEndDate, p.ModifiedByAppUserID AS ModifiedByAppUserID

           FROM [training].[ParticipantsXLSX] p
		   --LEFT JOIN (select TOP 1 LastVettingTypeID, LastVettingTypeCode, LastVettingStatusID, LastVettingStatusCode, LastVettingStatusDate, PersonID FROM [vetting].[PersonsVettingView]  GROUP BY PersonID ORDER BY LastVettingStatusDate DESC) v on P.PersonID = v.PersonID

		   OUTER APPLY
				(
					SELECT TOP 1 LastVettingTypeID, LastVettingTypeCode, LastVettingStatusID, LastVettingStatusCode, LastVettingStatusDate, VettingValidEndDate
					FROM [vetting].PersonsVettingView v
					WHERE v.PersonID = p.PersonID
					ORDER BY LastVettingStatusDate DESC
				) AS vs

           
		   WHERE p.TrainingEventID =  x.TrainingEventID
		     AND p.LoadStatus = 'Uploaded'
		   FOR JSON PATH, INCLUDE_NULL_VALUES) ParticipantJSON

	 FROM training.ParticipantsXLSX x

