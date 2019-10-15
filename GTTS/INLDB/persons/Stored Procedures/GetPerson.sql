CREATE PROCEDURE [persons].[GetPerson]
	@PersonID BIGINT
AS
BEGIN
	SELECT PersonID, FirstMiddleNames, LastNames, Gender, IsUSCitizen, NationalID, ResidenceLocationID, 
	ContactEmail, ContactPhone, DOB, POBCityID, FatherName, MotherName, HighestEducationID, FamilyIncome, EnglishLanguageProficiencyID, 
	PassportNumber, PassportExpirationDate, PassportIssuingCountryID, MedicalClearanceStatus, PlaceOfBirth, PlaceOfResidence,
	MedicalClearanceDate, PsychologicalClearanceStatus, PsychologicalClearanceDate, ModifiedByAppUserID, PersonLanguagesJSON, EducationLevel
		FROM persons.PersonsView p
	 WHERE PersonID = @PersonID
END
