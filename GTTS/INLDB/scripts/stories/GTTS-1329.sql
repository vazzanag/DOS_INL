DECLARE @VettingBatchID BIGINT, @TrainingEventID BIGINT, @VettingBatchOrdinal INT
DECLARE BatchCursor CURSOR FOR
	SELECT VettingBatchID, TrainingEventID FROM vetting.VettingBatches WHERE VettingBatchOrdinal IS NULL Order by TrainingEventID Asc, VettingBatchID ASC
OPEN BatchCursor
FETCH NEXT FROM BatchCursor INTO @VettingBatchID, @TrainingEventID
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @TrainingEventID IS NOT NULL
		SELECT @VettingBatchOrdinal = MAX(ISNULL(VettingBatchOrdinal,0)+1) FROM vetting.VettingBatches where TrainingEventID = @TrainingEventID
	ELSE
		SELECT @VettingBatchOrdinal = MAX(ISNULL(VettingBatchOrdinal,0)+1) FROM vetting.VettingBatches where TrainingEventID IS NULL
	UPDATE Vetting.VettingBatches SET VettingBatchOrdinal = @VettingBatchOrdinal Where VettingBatchID = @VettingBatchID
	FETCH NEXT FROM BatchCursor INTO @VettingBatchID, @TrainingEventID
END

CLOSE BatchCursor
DEALLOCATE BatchCursor