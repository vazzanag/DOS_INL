CREATE PROCEDURE [persons].[GetPersonsWithUnitLibraryInfoByCountryID]
    @CountryID INT
AS
BEGIN
    SELECT PersonsUnitLibraryInfoID, PersonID, FirstMiddleNames, LastNames, HostNationPOCName, HostNationPOCEmail,
           UnitID, JobTitle, YearsInPosition, WorkEmailAddress, RankID, RankName, IsUnitCommander, 
           PoliceMilSecID, IsVettingReq, IsLeahyVettingReq, IsArmedForces, IsLawEnforcement, 
           IsSecurityIntelligence, IsValidated, CountryID, ModifiedByAppUserID
      FROM persons.PersonsWithUnitLibraryInfoView
     WHERE CountryID = @CountryID
END

