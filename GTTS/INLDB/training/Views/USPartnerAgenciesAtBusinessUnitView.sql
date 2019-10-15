CREATE VIEW [training].[USPartnerAgenciesAtBusinessUnitView]
AS
	SELECT pa.AgencyID, pa.[Name], ab.BusinessUnitID, b.Acronym, b.BusinessUnitName,
           b.IsActive AS BusinessUnitActive, ab.IsActive AS USPartnerAgenciesBusinessUnitActive
	  FROM unitlibrary.USPartnerAgencies pa
INNER JOIN training.USPartnerAgenciesAtBusinessUnit ab ON pa.AgencyID = ab.AgencyID
INNER JOIN users.BusinessUnits b ON ab.BusinessUnitID = b.BusinessUnitID;
