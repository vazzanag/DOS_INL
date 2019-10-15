CREATE PROCEDURE [persons].[GetPersonsUnit]
	@PersonID BIGINT
AS
BEGIN
	SELECT PersonsUnitLibraryInfoID, PersonID, UnitID, JobTitle, RankID, RankName, 
           YearsInPosition, IsUnitCommander, BadgeNumber,
           HostNationPOCEmail, HostNationPOCName, WorkEmailAddress, IsVettingReq, IsLeahyVettingReq,
           IsArmedForces, IsLawEnforcement, IsSecurityIntelligence, IsValidated, IsActive, ModifiedDate,
           AgencyName, AgencyNameEnglish, UnitGenID, UnitTypeID, UnitType, 
           CommanderFirstName, CommanderLastName, CommanderEmail,
           UnitBreakdownEnglish, UnitBreakDownLocalLang
	  FROM [persons].[PersonsUnitView]
	WHERE PersonID = @PersonID
	AND ModifiedDate = (SELECT MAX(ModifiedDate) FROM [persons].[PersonsUnitLibraryInfo] WHERE PersonID = @PersonID);
END
