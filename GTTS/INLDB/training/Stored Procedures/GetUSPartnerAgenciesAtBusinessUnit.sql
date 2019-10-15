CREATE PROCEDURE [training].[GetUSPartnerAgenciesAtBusinessUnit]
	@BusinessUnitID INT
AS
SELECT AgencyID, [Name], BusinessUnitID, Acronym, BusinessUnitName,
       BusinessUnitActive, USPartnerAgenciesBusinessUnitActive
  FROM [training].USPartnerAgenciesAtBusinessUnitView
 WHERE BusinessUnitID = @BusinessUnitID;