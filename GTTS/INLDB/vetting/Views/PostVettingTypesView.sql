CREATE VIEW [vetting].[PostVettingTypesView]
AS
    SELECT PostID, p.VettingTypeID, t.Code, t.[Description], t.IsActive
      FROM vetting.PostVettingTypes p
INNER JOIN vetting.VettingTypes t ON p.VettingTypeID = t.VettingTypeID;
