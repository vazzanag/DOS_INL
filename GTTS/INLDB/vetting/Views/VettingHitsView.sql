CREATE VIEW [vetting].[VettingHitsView]
	AS SELECT h.VettingHitID, h.PersonsVettingID, h.VettingTypeID, h.FirstMiddleNames, h.LastNames, h.DOBYear, h.DOBMonth, h.DOBDay, 
				h.PlaceOfBirth, h.ReferenceSiteID, h.HitMonth, h.HitDay, h.HitYear, h.HitUnit, h.HitLocation, h.ViolationTypeID, h.CredibilityLevelID, 
				h.HitDetails, h.Notes, h.TrackingID, h.VettingHitDate, u.[First], u.[Middle], u.[Last], h.IsRemoved,
				(SELECT f.VettingHitFileAttachmentID, h.VettingHitID, f.FileID, f.FileVersion, f.IsDeleted, fi.[FileName]
					FROM [vetting].[VettingHitFileAttachments] f
				INNER JOIN files.Files fi on f.FileID = fi.FileID
				  WHERE f.VettingHitID = h.VettingHitID FOR JSON PATH, INCLUDE_NULL_VALUES
				) VettingHitFileAttachmentJSON
			FROM vetting.VettingHits h
		LEFT JOIN users.AppUsers u on h.VettingHitAppUserID = u.AppUserID
		

