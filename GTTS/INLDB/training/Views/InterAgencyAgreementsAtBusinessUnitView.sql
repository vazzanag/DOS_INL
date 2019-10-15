CREATE VIEW [training].[InterAgencyAgreementsAtBusinessUnitView]
AS
    SELECT a.InterAgencyAgreementID, a.Code, a.[Description], ab.BusinessUnitID, b.Acronym, b.BusinessUnitName,
           b.IsActive AS BusinessUnitActive, ab.IsActive AS InterAgencyAgreementBusinessUnitActive
	  FROM training.InterAgencyAgreements a
INNER JOIN training.InterAgencyAgreementsAtBusinessUnit ab ON a.InterAgencyAgreementID = ab.InterAgencyAgreementID
INNER JOIN users.BusinessUnits b ON ab.BusinessUnitID = b.BusinessUnitID;