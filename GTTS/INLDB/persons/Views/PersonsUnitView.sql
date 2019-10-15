CREATE VIEW [persons].[PersonsUnitView]
AS 
    SELECT pui.PersonsUnitLibraryInfoID, pui.PersonID, pui.UnitID, pui.JobTitle, pui.RankID, r.RankName, 
           pui.YearsInPosition, pui.IsUnitCommander, pui.PoliceMilSecID as BadgeNumber,
           pui.HostNationPOCEmail, pui.HostNationPOCName, pui.WorkEmailAddress, pui.IsVettingReq, pui.IsLeahyVettingReq,
           pui.IsArmedForces, pui.IsLawEnforcement, pui.IsSecurityIntelligence, pui.IsValidated, pui.IsActive, pui.ModifiedDate,
           case when u.IsMainAgency = 1 then u.UnitName else a.UnitName end AS AgencyName,
           case when u.IsMainAgency = 1 then u.UnitNameEnglish else a.UnitNameEnglish end AS AgencyNameEnglish,
           u.UnitGenID, u.UnitTypeID, t.[Name] AS UnitType, 
           c.FirstMiddleNames AS CommanderFirstName, c.LastNames AS CommanderLastName, c.ContactEmail AS CommanderEmail,
           u.UnitBreakdownEnglish,
           u.UnitBreakdown as UnitBreakDownLocalLang
      FROM persons.PersonsUnitLibraryInfo pui
INNER JOIN unitlibrary.Units u ON pui.UnitID = u.UnitID
INNER JOIN unitlibrary.UnitTypes t ON u.UnitTypeID = t.UnitTypeID
 LEFT JOIN persons.Persons c on u.UnitHeadPersonID = c.PersonID
 LEFT JOIN unitlibrary.Units p on u.UnitParentID = p.UnitID
 LEFT JOIN unitlibrary.Units a on u.UnitMainAgencyID = a.UnitID
 LEFT JOIN persons.Ranks r ON pui.RankID = r.RankID;
	