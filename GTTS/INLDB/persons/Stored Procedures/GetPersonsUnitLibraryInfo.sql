CREATE PROCEDURE [persons].[GetPersonsUnitLibraryInfo]
    @PersonsUnitLibraryInfoID BIGINT = NULL,
    @PersonID BIGINT = NULL,
    @UnitID BIGINT = NULL
AS
BEGIN
    SELECT PersonsUnitLibraryInfoID, PersonID, UnitID, JobTitle, YearsInPosition, WorkEmailAddress, RankID, RankName, IsUnitCommander, 
            PoliceMilSecID, IsVettingReq, IsLeahyVettingReq, IsArmedForces, IsLawEnforcement, HostNationPOCName, HostNationPOCEmail,
            IsSecurityIntelligence, IsValidated, CountryID, ModifiedByAppUserID, ModifiedByAppUser
      FROM persons.PersonsUnitLibraryInfoView
     WHERE PersonsUnitLibraryInfoID = @PersonsUnitLibraryInfoID
        OR (PersonID = @PersonID AND UnitID = @UnitID)
END
