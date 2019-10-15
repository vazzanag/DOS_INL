CREATE VIEW [persons].[PersonsUnitLibraryInfoView]
AS 
	 SELECT PersonsUnitLibraryInfoID, PersonID, p.UnitID, ul.UnitName, ul.UnitNameEnglish, ul.UnitParentName, 
            ul.UnitParentNameEnglish, ul.UnitTypeID, ul.UnitType, ul.AgencyName, ul.AgencyNameEnglish, ul.UnitMainAgencyID, 
            JobTitle, YearsInPosition, WorkEmailAddress, HostNationPOCName, HostNationPOCEmail,
            p.RankID, r.RankName, IsUnitCommander, PoliceMilSecID, IsVettingReq, IsLeahyVettingReq, 
            IsArmedForces, IsLawEnforcement, IsSecurityIntelligence, IsValidated, ul.CountryID, p.IsActive,
            p.ModifiedByAppUserID, u.FullName AS ModifiedByAppUser, p.ModifiedDate,
			ul.UnitAliasJson, ul.CommanderFirstName, ul.CommanderLastName, ul.CommanderEmail, ul.UnitGenID
      FROM persons.PersonsUnitLibraryInfo p
 LEFT JOIN persons.Ranks r ON p.RankID = r.RankID
INNER JOIN unitlibrary.UnitsView ul ON p.UnitID = ul.UnitID
INNER JOIN [users].AppUsersView u on p.ModifiedByAppUserID = u.AppUserID;
