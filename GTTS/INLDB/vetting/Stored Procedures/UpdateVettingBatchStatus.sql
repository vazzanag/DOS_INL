CREATE PROCEDURE [vetting].[UpdateVettingBatchStatus]
	@VettingBatchID BIGINT, 
	@VettingBatchStatus NVARCHAR(25),
	@ModifiedByAppUserID INT
AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
        	BEGIN
				DECLARE @VettingStatusID INT;
				SELECT TOP 1 @VettingStatusID = VettingBatchStatusID FROM vetting.VettingBatchStatuses 
					WHERE Code = CASE WHEN @VettingBatchStatus = 'Accept' THEN 'Accepted'
									ELSE CASE WHEN @VettingBatchStatus = 'Submit to Courtesy' THEN 'SUBMITTED TO COURTESY'
										ELSE CASE WHEN @VettingBatchStatus = 'Submit to Leahy' THEN 'SUBMITTED TO LEAHY' 
											ELSE CASE WHEN @VettingBatchStatus = 'Notify Results' THEN 'CLOSED' 
												ELSE CASE WHEN @VettingBatchStatus = 'Upload Leahy Results' THEN 'LEAHY RESULTS RETURNED' 
													ELSE @VettingBatchStatus END
												END
											END
										END
									END
				UPDATE vetting.VettingBatches SET
					   VettingBatchStatusID = @VettingStatusID, 
					   ModifiedByAppUserID = @ModifiedByAppUserID
			     WHERE VettingBatchID = @VettingBatchID

				 -- Update correct AppUserID column and Date column
				 IF @VettingBatchStatus = 'Accept'
					UPDATE vetting.VettingBatches SET AppUserIDAccepted = @ModifiedByAppUserID, DateAccepted = GETDATE() WHERE VettingBatchID = @VettingBatchID
				 ELSE IF @VettingBatchStatus = 'Submit to Courtesy'
					UPDATE vetting.VettingBatches SET AppUserIDSentToCourtesy = @ModifiedByAppUserID, DateSentToCourtesy = GETDATE() WHERE VettingBatchID = @VettingBatchID
				 ELSE IF @VettingBatchStatus = 'COURTESY COMPLETED'
					UPDATE vetting.VettingBatches SET AppUserIDCourtesyCompleted = @ModifiedByAppUserID, DateCourtesyCompleted = GETDATE() WHERE VettingBatchID = @VettingBatchID
				 ELSE IF @VettingBatchStatus = 'Submit to Leahy'
					UPDATE vetting.VettingBatches SET AppUserIDSentToLeahy = @ModifiedByAppUserID, DateSentToLeahy = GETDATE() WHERE VettingBatchID = @VettingBatchID
				ELSE IF @VettingBatchStatus = 'Notify Results'
				BEGIN
					UPDATE vetting.VettingBatches SET DateVettingResultsNotified = GETDATE() WHERE VettingBatchID = @VettingBatchID
					UPDATE vetting.PersonsVetting SET VettingPersonStatusID = 2 WHERE VettingBatchID = @VettingBatchID AND VettingPersonStatusID = 1
				END
				ELSE IF @VettingBatchStatus = 'Upload Leahy Results'
					UPDATE vetting.VettingBatches SET DateLeahyResultsReceived = GETDATE() WHERE VettingBatchID = @VettingBatchID

				IF @VettingBatchStatus = 'Submit to Courtesy'
				BEGIN
					/* move batch to courtesy complete if all participants are skipped */
					DECLARE @NonSkippedCount INT
					SELECT @NonSkippedCount = COUNT(pvt.PersonsVettingID) FROM vetting.PersonsVettingVettingTypes pvt
										INNER JOIN vetting.PersonsVetting pv on pvt.PersonsVettingID = pv.PersonsVettingID
										INNER JOIN vetting.VettingTypes vt on pvt.VettingTypeID = vt.VettingTypeID
											WHERE vt.Code NOT IN ('POL', 'LEAHY') 
												AND ISNULL(pvt.CourtesyVettingSkipped,0) = 0 
												AND pv.VettingBatchID = @VettingBatchID
					IF @NonSkippedCount = 0
					BEGIN
						SELECT TOP 1 @VettingStatusID = VettingBatchStatusID FROM vetting.VettingBatchStatuses WHERE Code = 'COURTESY COMPLETED'
						UPDATE vetting.VettingBatches 
							SET VettingBatchStatusID = @VettingStatusID, 
								ModifiedByAppUserID = @ModifiedByAppUserID
								WHERE VettingBatchID = @VettingBatchID
						UPDATE vetting.VettingBatches SET AppUserIDCourtesyCompleted = @ModifiedByAppUserID, DateCourtesyCompleted = GETDATE() WHERE VettingBatchID = @VettingBatchID
					END
				END

				/* move batch to leahy completed if all paticpants are in Rejected/Canceled/Matched state */
				IF @VettingBatchStatus = 'Submit to Leahy' OR @VettingBatchStatus = 'COURTESY COMPLETED'
				BEGIN
					DECLARE @ActiveCount INT
					SELECT @ActiveCount = COUNT(pvt.PersonsVettingID) FROM vetting.PersonsVettingVettingTypes pvt
										INNER JOIN vetting.PersonsVetting pv on pvt.PersonsVettingID = pv.PersonsVettingID
										INNER JOIN vetting.VettingTypes vt on pvt.VettingTypeID = vt.VettingTypeID
											WHERE vt.Code IN ('LEAHY') 
												AND ISNULL(pvt.CourtesyVettingSkipped,0) = 0 
												AND pv.VettingBatchID = @VettingBatchID


					IF @ActiveCount = 0

					BEGIN
						SELECT TOP 1 @VettingStatusID = VettingBatchStatusID FROM vetting.VettingBatchStatuses WHERE Code = 'LEAHY RESULTS RETURNED'
						UPDATE vetting.VettingBatches 
							SET VettingBatchStatusID = @VettingStatusID, 
								ModifiedByAppUserID = @ModifiedByAppUserID
								WHERE VettingBatchID = @VettingBatchID
						UPDATE vetting.VettingBatches SET DateLeahyResultsReceived = GETDATE() WHERE VettingBatchID = @VettingBatchID
					END
				END

				DECLARE @VettingType VARCHAR(15), @ApprovedStatusID INT, @RejectedStatusID INT, @SuspendedStatusID INT
				SELECT @VettingType = VettingBatchType FROM vetting.VettingBatchesDetailView WHERE VettingBatchID = @VettingBatchID
				SELECT @ApprovedStatusID = VettingPersonStatusID FROM vetting.VettingPersonStatuses WHERE Code = 'APPROVED'
				SELECT @RejectedStatusID = VettingPersonStatusID FROM vetting.VettingPersonStatuses WHERE Code = 'REJECTED'
				SELECT @SuspendedStatusID = VettingPersonStatusID FROM vetting.VettingPersonStatuses WHERE Code = 'SUSPENDED'
				IF @VettingBatchStatus = 'Notify Results' AND  @VettingType = 'Courtesy'
				-- update status to approved for no hit or cleared hits rejected if there are hits and is denied
				BEGIN
					UPDATE vetting.PersonsVetting SET VettingPersonStatusID = @ApprovedStatusID, VettingStatusDate = GETDATE() 
						WHERE VettingPersonStatusID IS NULL AND (ClearedDate IS NOT NULL OR (ClearedDate IS NULL AND DeniedDate IS NULL)) AND VettingBatchID = @VettingBatchID
					UPDATE vetting.PersonsVetting SET VettingPersonStatusID = @RejectedStatusID, VettingStatusDate = GETDATE() 
						WHERE VettingPersonStatusID IS NULL AND DeniedDate IS NOT NULL AND VettingBatchID = @VettingBatchID
				END

				IF @VettingBatchStatus = 'Notify Results' AND  @VettingType = 'Leahy'
				-- update status to approved/rejected/suspended based on leahy result
				BEGIN
					UPDATE pv SET pv.VettingPersonStatusID = @ApprovedStatusID, pv.VettingStatusDate = GETDATE()  
						FROM vetting.PersonsVetting pv
					INNER JOIN vetting.LeahyVettingHits lh ON pv.PersonsVettingID = lh.PersonsVettingID 
					INNER JOIN vetting.VettingLeahyHitResults lhr on lh.LeahyHitResultID = lhr.LeahyHitResultID 
						WHERE pv.VettingBatchID = @VettingBatchID AND lhr.Code = 'Approved'

					UPDATE pv SET pv.VettingPersonStatusID = @RejectedStatusID, pv.VettingStatusDate = GETDATE()  
						FROM vetting.PersonsVetting pv
					INNER JOIN vetting.LeahyVettingHits lh ON pv.PersonsVettingID = lh.PersonsVettingID 
					INNER JOIN vetting.VettingLeahyHitResults lhr on lh.LeahyHitResultID = lhr.LeahyHitResultID 
						WHERE pv.VettingBatchID = @VettingBatchID AND lhr.Code = 'Rejected'

					UPDATE pv SET pv.VettingPersonStatusID = @SuspendedStatusID, pv.VettingStatusDate = GETDATE()  
						FROM vetting.PersonsVetting pv
					INNER JOIN vetting.LeahyVettingHits lh ON pv.PersonsVettingID = lh.PersonsVettingID 
					INNER JOIN vetting.VettingLeahyHitResults lhr on lh.LeahyHitResultID = lhr.LeahyHitResultID 
						WHERE pv.VettingBatchID = @VettingBatchID AND lhr.Code = 'Suspended'
				END

			END
		SELECT @VettingBatchID
-- NO ERRORS,  COMMIT
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END