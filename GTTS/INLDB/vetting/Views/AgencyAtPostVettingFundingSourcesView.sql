CREATE VIEW [vetting].[AgencyAtPostVettingFundingSourcesView]
AS
     SELECT PostID, UnitID, a.VettingFundingSourceID, Code, [Description], f.ModifiedByAppUserID, 
            f.IsActive, a.IsActive AS PostIsActive, 
		    a.ModifiedByAppUserID AS PostModifiedByAppUser, a.ModifiedDate AS PostModifiedDate
	   FROM vetting.AgencyAtPostVettingFundingSources a
 INNER JOIN vetting.VettingFundingSources f ON a.VettingFundingSourceID = f.VettingFundingSourceID;
