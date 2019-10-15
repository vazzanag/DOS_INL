CREATE PROCEDURE [training].[GetInterAgencyAgreementsAtBusinessUnit]
    @BusinessUnitID INT
AS
SELECT InterAgencyAgreementID, Code, BusinessUnitID, Acronym, BusinessUnitName,
       BusinessUnitActive, InterAgencyAgreementBusinessUnitActive
  FROM [training].[InterAgencyAgreementsAtBusinessUnitView]
 WHERE BusinessUnitID = @BusinessUnitID;
