CREATE VIEW [vetting].[PersonVettingHitsView]
AS 
	
	SELECT vt.PersonsVettingID, vt.VettingTypeID, vt.HitResultID, vt.HitResultDetails, 
		   (SELECT h.VettingHitID, h.PersonsVettingID, h.VettingTypeID, h.FirstMiddleNames, h.LastNames, h.DOBYear, h.DOBMonth, h.DOBDay, h.PlaceOfBirth, h.ReferenceSiteID, h.HitMonth,
				   h.HitDay, h.HitYear, h.HitUnit, h.HitLocation, h.ViolationTypeID, h.CredibilityLevelID, h.HitDetails, h.Notes,
				   h.TrackingID, h.VettingHitDate, h.[First], h.Middle, h.[Last], h.IsRemoved, VettingHitFileAttachmentJSON
				FROM vetting.VettingHitsView h
					WHERE h.PersonsVettingID = vt.PersonsVettingID AND h.VettingTypeID = vt.VettingTypeID FOR JSON PATH, INCLUDE_NULL_VALUES) VettingHitsJSON
	    FROM vetting.PersonsVettingVettingTypes vt

