CREATE PROCEDURE [vetting].[RejectVettingBatch]
	@VettingBatchID BIGINT, 
	@BatchRejectionReason NVARCHAR(250),
	@ModifiedByAppUserID INT
AS
BEGIN
	BEGIN TRY
        BEGIN TRANSACTION
			BEGIN
				UPDATE vetting.VettingBatches SET
						VettingBatchStatusID = 3, 
						BatchRejectionReason = @BatchRejectionReason,
						ModifiedByAppUserID = @ModifiedByAppUserID
				WHERE VettingBatchID = @VettingBatchID

				-- RETURN the Identity
				SELECT @VettingBatchID;
			 END

			 -- UPDATE All Participants vetting status to Canceled

			 DECLARE @VettingPersonStatusID INT
			 SELECT @VettingPersonStatusID = VettingPersonStatusID from vetting.VettingPersonStatuses WHERE Code = 'CANCELED'

			 UPDATE pv SET pv.VettingPersonStatusID = @VettingPersonStatusID,
						   pv.ModifiedByAppUserID = @ModifiedByAppUserID
				FROM vetting.PersonsVetting pv 
			INNER JOIN vetting.VettingBatches v on pv.VettingBatchID = v.VettingBatchID
				WHERE v.VettingBatchID = @VettingBatchID


			-- Removed RejectedFromVetting Flag from training event students/instructors table if removed from event = 0
			UPDATE pv SET pv.RemovedFromVetting = 0 FROM training.TrainingEventParticipants ts
					  INNER JOIN vetting.VettingBatches b ON ts.TrainingEventID = b.TrainingEventID
					  INNER JOIN vetting.PersonsVetting pv ON b.VettingBatchID = pv.VettingBatchID
					  INNER JOIN persons.PersonsUnitLibraryInfo pu ON ts.PersonID = pu.PersonID AND pu.PersonsUnitLibraryInfoID = pv.PersonsUnitLibraryInfoID
				WHERE b.VettingBatchID = @VettingBatchID AND pv.RemovedFromVetting = 1 and ts.RemovedFromEvent = 0

-- NO ERRORS,  COMMIT
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END