CREATE PROCEDURE [persons].[GetPersonsFromJSON]
    @PersonsJSON NVARCHAR(MAX)
AS
BEGIN

    SELECT PersonID, PersonsUnitLibraryInfoID, FirstMiddleNames, LastNames, Gender, IsUSCitizen, NationalID, 
            ResidenceLocationID, ResidenceStreetAddress, ResidenceCityID, ResidenceStateID, ResidenceCountryID,            
            POBCityID, POBStateID, POBCountryID, ContactEmail, ContactPhone, DOB, FatherName, MotherName, HighestEducationID, 
            FamilyIncome, EnglishLanguageProficiencyID, PassportNumber, PassportExpirationDate, PassportIssuingCountryID,
			MedicalClearanceStatus, MedicalClearanceDate, PsychologicalClearanceStatus, PsychologicalClearanceDate, 
			UnitID, UnitName, UnitNameEnglish, UnitParentName, UnitParentNameEnglish, AgencyName, AgencyNameEnglish, 
            JobTitle, YearsInPosition, WorkEmailAddress, RankID, RankName, IsUnitCommander, PoliceMilSecID,
            CountryID, IsVettingReq, IsLeahyVettingReq, IsArmedForces, IsLawEnforcement,
            IsSecurityIntelligence, IsValidated, IsInVettingProcess, ModifiedByAppUserID, PersonLanguagesJSON
      FROM persons.PersonsWithUnitLibraryInfoView
     WHERE PersonID IN (SELECT j.PersonID FROM OPENJSON(@personsJSON) WITH (PersonID INT) j);

END