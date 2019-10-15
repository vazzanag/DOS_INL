CREATE VIEW [persons].[PersonsView]
AS 
	  SELECT PersonID, FirstMiddleNames, LastNames, Gender, IsUSCitizen, NationalID, 
             ResidenceLocationID, CONCAT_WS(' ', rl.AddressLine1, rl.AddressLine2, rl.AddressLine3) AS ResidenceStreetAddress,
             rl.CityID AS ResidenceCityID, rc.StateID AS ResidenceStateID, rs.CountryID AS ResidenceCountryID,            
             POBCityID AS POBCityID, pobc.CityName AS POBCityName, pobc.StateID AS POBStateID, pobs.StateName AS POBStateName, pobs.CountryID AS POBCountryID, pobco.CountryName AS POBCountryName,
	         ContactEmail, ContactPhone, DOB, FatherName, MotherName, HighestEducationID, FamilyIncome, EnglishLanguageProficiencyID, 
	         PassportNumber, PassportExpirationDate, PassportIssuingCountryID,
	         MedicalClearanceStatus, MedicalClearanceDate, PsychologicalClearanceStatus, PsychologicalClearanceDate, p.ModifiedByAppUserID,
             CONCAT_WS(', ',pobc.CityName, pobs.StateName, pobco.[CountryName]) as PlaceOfBirth,
	         CONCAT_WS(', ',rc.CityName, rs.StateName, rco.[CountryName]) as PlaceOfResidence, ed.Code as EducationLevel,

            -- Person Languages
           (SELECT PersonID, LanguageID, LanguageProficiencyID, LanguageCode, LanguageDescription,
		           LanguageProficiencyCode, LanguageProficiencyDescription, ModifiedByAppUserID
              FROM [persons].[PersonLanguagesView] l
             WHERE l.PersonID = p.PersonID FOR JSON PATH, INCLUDE_NULL_VALUES) PersonLanguagesJSON

		 FROM persons.Persons p
    LEFT JOIN [location].Cities as pobc on p.POBCityID = pobc.CityID
    LEFT JOIN [location].States as pobs on pobc.StateID= pobs.StateID
    LEFT JOIN [location].Countries as pobco on pobs.CountryID = pobco.CountryID
    LEFT JOIN [location].Locations as rl on p.ResidenceLocationID = rl.LocationID
    LEFT JOIN [location].Cities as rc on rl.CityID = rc.CityID
    LEFT JOIN [location].States as rs on rc.StateID= rs.StateID
    LEFT JOIN [location].Countries as rco on rs.CountryID = rco.CountryID
    LEFT JOIN [persons].[EducationLevels] ed on p.HighestEducationID = ed.EducationLevelID;