CREATE VIEW [vetting].[AgencyAtPostAuthorizingLawsView]
AS
	 SELECT PostID, UnitID, p.AuthorizingLawID, Code, [Description], a.ModifiedByAppUserID, 
            a.IsActive, p.IsActive AS PostIsActive,
		    p.ModifiedByAppUserID AS PostModifiedByAppUser, p.ModifiedDate AS PostModifiedDate
	   FROM vetting.AgencyAtPostAuthorizingLaws p
 INNER JOIN vetting.AuthorizingLaws a ON p.AuthorizingLawID = a.AuthorizingLawID;
