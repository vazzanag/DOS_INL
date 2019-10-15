CREATE PROCEDURE [vetting].[CancelVettingBatchesForTrainingEvent]
	@TrainingEventID BIGINT,
	@ModifiedByAppUserID BIGINT,
	@IsCancel BIT 
AS

BEGIN

	DECLARE @CancelVettingBatchStatus INT, @CancelVettingPersonStatus INT
	SELECT @CancelVettingBatchStatus = VettingBatchStatusID  FROM vetting.VettingBatchStatuses WHERE Code = 'CANCELED'
	SELECT @CancelVettingPersonStatus = VettingPersonStatusID  FROM vetting.VettingPersonStatuses WHERE Code = 'EVENT CANCELED'
	IF @CancelVettingBatchStatus IS NULL 
	BEGIN
		RAISERROR ('Canceled status is missing in vetting batch status table', 16,1)
		RETURN
	END
	IF @CancelVettingPersonStatus IS NULL 
	BEGIN
		RAISERROR ('Event Canceled status is missing in person vetting status', 16,1)
		RETURN
	END
	IF(@IsCancel = 1)
	BEGIN
			--Update all Vetting PersonStatus
			UPDATE pv SET pv.VettingPersonStatusID = @CancelVettingPersonStatus, ModifiedByAppUserID = @ModifiedByAppUserID FROM vetting.PersonsVetting pv
				INNER JOIN vetting.VettingBatches b ON pv.VettingBatchID = b.VettingBatchID
			WHERE b.TrainingEventID = @TrainingEventID 
				AND (VettingBatchStatusID = 1 OR (VettingBatchStatusID = 2 AND DateLeahyFileGenerated IS NULL)) AND pv.VettingPersonStatusID = 1

			-- Update all vetting batches in submiited or approved state
			UPDATE vetting.VettingBatches SET VettingBatchStatusID = @CancelVettingBatchStatus, ModifiedByAppUserID = @ModifiedByAppUserID
				WHERE TrainingEventID = @TrainingEventID 
					AND (VettingBatchStatusID = 1 OR (VettingBatchStatusID = 2 AND DateLeahyFileGenerated IS NULL))
			SELECT VettingBatchID FROM vetting.VettingBatchesView WHERE TrainingEventID = @TrainingEventID AND VettingBatchStatusID = @CancelVettingBatchStatus
	END
	ELSE
	BEGIN
			UPDATE pv SET pv.VettingPersonStatusID = 1, ModifiedByAppUserID = @ModifiedByAppUserID FROM vetting.PersonsVetting pv
				INNER JOIN vetting.VettingBatches b ON pv.VettingBatchID = b.VettingBatchID
			WHERE b.TrainingEventID = @TrainingEventID 
				AND VettingBatchStatusID = @CancelVettingBatchStatus AND pv.VettingPersonStatusID = @CancelVettingPersonStatus

			-- Update all vetting batches to submiited state
			UPDATE vetting.VettingBatches SET VettingBatchStatusID = 1, ModifiedByAppUserID = @ModifiedByAppUserID
				WHERE TrainingEventID = @TrainingEventID 
					AND VettingBatchStatusID = @CancelVettingBatchStatus

			SELECT VettingBatchID FROM vetting.VettingBatchesView WHERE TrainingEventID = @TrainingEventID AND VettingBatchStatusID = 1
	END
END
