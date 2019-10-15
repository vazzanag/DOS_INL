CREATE VIEW [vetting].[VettingBatchesView]
AS
	SELECT vb.VettingBatchID, vb.VettingBatchStatusID, vb.TrainingEventID, pv.VettingPersonStatusID, pv.PersonsUnitLibraryInfoID, pv.PersonsVettingID
		FROM vetting.VettingBatches vb
	INNER JOIN vetting.PersonsVetting pv ON vb.VettingBatchID = pv.VettingBatchID