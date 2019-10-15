CREATE VIEW [persons].[PersonsWithUnitLibraryInfoView]
AS
 	 SELECT p.PersonID, u.PersonsUnitLibraryInfoID, FirstMiddleNames, LastNames, Gender, IsUSCitizen, NationalID, 
            ResidenceLocationID, CONCAT_WS(' ', rl.AddressLine1, rl.AddressLine2, rl.AddressLine3) AS ResidenceStreetAddress,
            rl.CityID AS ResidenceCityID, rc.StateID AS ResidenceStateID, rs.CountryID AS ResidenceCountryID,            
            POBCityID AS POBCityID, pobc.StateID AS POBStateID, pobs.CountryID AS POBCountryID,
		    ContactEmail, ContactPhone, DOB, FatherName, MotherName, HighestEducationID, FamilyIncome, EnglishLanguageProficiencyID, 
		    PassportNumber, PassportExpirationDate, PassportIssuingCountryID, HostNationPOCName, HostNationPOCEmail,
			MedicalClearanceStatus, MedicalClearanceDate, PsychologicalClearanceStatus, PsychologicalClearanceDate, 
			UnitID, UnitName, UnitNameEnglish, UnitParentName, UnitParentNameEnglish, AgencyName, AgencyNameEnglish, 
            JobTitle, YearsInPosition, WorkEmailAddress, RankID, RankName, IsUnitCommander, PoliceMilSecID,
            u.CountryID, IsVettingReq, IsLeahyVettingReq, IsArmedForces, IsLawEnforcement,
            IsSecurityIntelligence, IsValidated, 
			
			(SELECT CASE WHEN EXISTS(
									  SELECT 1 
										FROM vetting.PersonsVetting v 
								  INNER JOIN persons.PersonsUnitLibraryInfo l ON v.PersonsUnitLibraryInfoID = l.PersonsUnitLibraryInfoID
									   WHERE l.PersonID = p.PersonID AND v.VettingPersonStatusID = 1)
			   THEN CAST(1 AS BIT)
			   ELSE CAST(0 AS BIT) END) AS IsInVettingProcess,
			   
			   p.ModifiedByAppUserID,
            
            -- Person Languages
           (SELECT PersonID, LanguageID, LanguageProficiencyID, LanguageCode, LanguageDescription,
		           LanguageProficiencyCode, LanguageProficiencyDescription, ModifiedByAppUserID
              FROM [persons].[PersonLanguagesView] l
             WHERE l.PersonID = p.PersonID FOR JSON PATH, INCLUDE_NULL_VALUES) PersonLanguagesJSON

	   FROM persons.Persons p
  LEFT JOIN [location].Cities AS pobc               ON p.POBCityID = pobc.CityID
  LEFT JOIN [location].States AS pobs               ON pobc.StateID= pobs.StateID
  LEFT JOIN [location].Locations AS rl              ON p.ResidenceLocationID = rl.LocationID
  LEFT JOIN [location].Cities AS rc                 ON rl.CityID = rc.CityID
  LEFT JOIN [location].States AS rs                 ON rc.StateID= rs.StateID
  LEFT JOIN persons.PersonsUnitLibraryInfoView AS u ON p.PersonID = u.PersonID
                                                   AND u.ModifiedDate = (SELECT MAX(ModifiedDate) 
                                                                           FROM persons.PersonsUnitLibraryInfoView 
                                                                          WHERE PersonID = p.PersonID)
