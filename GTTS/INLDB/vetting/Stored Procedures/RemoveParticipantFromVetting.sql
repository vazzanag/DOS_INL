CREATE PROCEDURE [vetting].[RemoveParticipantFromVetting]
	@TrainingEventID BIGINT,
    @PersonsJSON NVARCHAR(MAX),
	@ModifiedByAppUserID BIGINT
AS
	BEGIN

		-- change the remove from vetting flag if the student is in accepted batches
		UPDATE pv SET pv.RemovedFromVetting = 1, pv.ModifiedByAppUserID = @ModifiedByAppUserID
			FROM [training].TrainingEventParticipants ts
		INNER JOIN vetting.VettingBatches vb ON vb.TrainingEventID = vb.TrainingEventID
		INNER JOIN persons.PersonsUnitLibraryInfo pui on ts.PersonID = pui.PersonID 
		INNER JOIN vetting.PersonsVetting pv ON vb.VettingBatchID = pv.VettingBatchID AND pv.PersonsUnitLibraryInfoID = pui.PersonsUnitLibraryInfoID
		INNER JOIN OPENJSON(@PersonsJSON) WITH (PersonID INT) j ON ts.PersonID = j.PersonID
		WHERE  vb.TrainingEventID = @TrainingEventID
			AND (vb.VettingBatchStatusID =1 OR (vb.VettingBatchStatusID =2 AND vb.DateLeahyFileGenerated IS NULL)) AND ts.RemovedFromEvent = 1
	

	SELECT PersonID
	FROM vetting.PersonsVettingView
	WHERE PersonID IN (SELECT j.PersonID FROM OPENJSON(@PersonsJSON) WITH (PersonID INT) j) AND RemovedFromVetting = 1
	
END