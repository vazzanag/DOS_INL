CREATE VIEW [search].[UnitsView]
AS 
    SELECT u.UnitID, u.UnitAcronym, u.UnitName, u.UnitNameEnglish, u.IsMainAgency, u.UnitParentID, u.UnitMainAgencyID,
           p.UnitName as UnitParentName, p.UnitNameEnglish AS UnitParentNameEnglish,
           (case when u.IsMainAgency = 1 then u.UnitName else a.UnitName end) AS AgencyName,
           (case when u.IsMainAgency = 1 then u.UnitNameEnglish else a.UnitNameEnglish end) AS AgencyNameEnglish,
           u.UnitGenID, u.UnitTypeID, t.[Name] AS UnitType, u.GovtLevelID, g.[Name] AS GovtLevel, 
           u.UnitLevelID, l.[Name] AS UnitLevel, u.VettingBatchTypeID,vc.Code AS VettingBatchTypeCode, u.VettingActivityTypeID, 
           va.[Name] AS VettingActivityType, u.ReportingTypeID, rt.[Name] AS ReportingType,
           c.FirstMiddleNames AS CommanderFirstName, c.LastNames AS CommanderLastName, cou.CountryID
      FROM unitlibrary.Units u
INNER JOIN vetting.VettingBatchTypes vc ON u.VettingBatchTypeID = vc.VettingBatchTypeID
INNER JOIN vetting.VettingActivityTypes va ON u.VettingActivityTypeID = va.VettingActivityTypeID
INNER JOIN unitlibrary.UnitTypes t ON u.UnitTypeID = t.UnitTypeID
INNER JOIN [location].Countries cou ON u.CountryID = cou.CountryID
 LEFT JOIN unitlibrary.Units p on u.UnitParentID = p.UnitID
 LEFT JOIN unitlibrary.Units a on u.UnitMainAgencyID = a.UnitID
 LEFT JOIN persons.Persons c on u.UnitHeadPersonID = c.PersonID
 LEFT JOIN unitlibrary.UnitLevels l ON u.UnitLevelID = l.UnitLevelID
 LEFT JOIN unitlibrary.GovtLevels g on u.GovtLevelID = g.GovtLevelID
 LEFT JOIN unitlibrary.ReportingTypes rt ON u.ReportingTypeID = rt.ReportingTypeID