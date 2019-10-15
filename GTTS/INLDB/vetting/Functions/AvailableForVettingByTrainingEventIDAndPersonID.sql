CREATE FUNCTION [vetting].[AvailableForVettingByTrainingEventIDAndPersonID]
(
    @TrainingEventID BIGINT,
    @PersonID BIGINT,
	@PostID BIGINT,
	@CreatedDate DATETIME
)
RETURNS @Vettings TABLE (CanBeVetted BIT, IsReVetting BIT)
AS
BEGIN
    DECLARE @VettingStatus NVARCHAR(25), @EventStartDate DATE, @CanBeVetted BIT, @StatusesFound INT, @IsReVetting BIT

    -- GET TRAINING EVENT START DATE
    SELECT @EventStartDate = MIN(EventStartDate) FROM training.TrainingEventLocations WHERE TrainingEventID = @TrainingEventID;

    -- CHECK IF THERE IS AN EXISTING VETTING STATUS FOR THIS TRAINING EVENT
    IF EXISTS(SELECT PersonID 
			    FROM vetting.PersonsVetting v
		  INNER JOIN vetting.VettingBatches b ON v.VettingBatchID = b.VettingBatchID
		  INNER JOIN persons.PersonsUnitLibraryInfo p ON v.PersonsUnitLibraryInfoID = p.PersonsUnitLibraryInfoID AND p.IsActive = 1
		       WHERE b.TrainingEventID = @TrainingEventID AND p.PersonID = @PersonID 
					AND b.VettingBatchStatusID <> 3 
					AND ISNULL(v.RemovedFromVetting,0) = 0)
	    BEGIN
		    SET @CanBeVetted = 0;
	    END
	-- CHECK IF PERSON HAS BEEN REJECTED 
    ELSE IF EXISTS(SELECT PersonID 
			    FROM vetting.PersonsVetting v
		  INNER JOIN vetting.VettingBatches b ON v.VettingBatchID = b.VettingBatchID
		  INNER JOIN persons.PersonsUnitLibraryInfo p ON v.PersonsUnitLibraryInfoID = p.PersonsUnitLibraryInfoID
		       WHERE b.TrainingEventID <> @TrainingEventID and p.PersonID = @PersonID AND v.VettingPersonStatusID IN (3,4))
	    BEGIN
		    SET @CanBeVetted = 0;
	    END
	-- CHECK IF PERSON HAS BEEN REMOVED 
    ELSE IF EXISTS(SELECT PersonID 
			    FROM vetting.PersonsVetting v
		  INNER JOIN vetting.VettingBatches b ON v.VettingBatchID = b.VettingBatchID
		  INNER JOIN persons.PersonsUnitLibraryInfo p ON v.PersonsUnitLibraryInfoID = p.PersonsUnitLibraryInfoID
		       WHERE b.TrainingEventID = @TrainingEventID and p.PersonID = @PersonID AND v.VettingPersonStatusID = 1 AND ISNULL(v.RemovedFromVetting,0) = 0)
	    BEGIN
		    SET @CanBeVetted = 0;
	    END
	-- CHECK STATUS OF VETTINGS FROM OTHER TRAINING EVVENTS
	ELSE
	    BEGIN
			-- CHECK FOR APPROVED STATUS WITH VALID EXPIRATION DATE
		    SELECT @StatusesFound = COUNT(@@ROWCOUNT)
		      FROM (
				    SELECT p.PersonID, b.TrainingEventID, b.VettingBatchStatusID, bs.Code AS BatchStatus, v.VettingPersonStatusID, ps.Code AS PersonsVettingStatus, v.VettingStatusDate AS VettingStatusDate, b.VettingBatchTypeID AS VettingBatchTypeID, IsReVetting,
						    (CASE WHEN b.VettingBatchStatusID = 1 THEN DateSubmitted
								  WHEN b.VettingBatchStatusID = 2 THEN DateAccepted
								  WHEN b.VettingBatchStatusID = 3 THEN b.ModifiedDate
								  WHEN b.VettingBatchStatusID = 4 THEN DateSentToCourtesy
								  WHEN b.VettingBatchStatusID = 5 THEN DateCourtesyCompleted
								  WHEN b.VettingBatchStatusID = 6 THEN DateSentToLeahy
								  WHEN b.VettingBatchStatusID = 7 THEN DateVettingResultsNotified 
								  ELSE b.ModifiedDate END) AS VettingBatchStatusDate,
						    (CASE WHEN b.VettingBatchTypeID = 1 THEN v.VettingStatusDate + 365
								  WHEN b.VettingBatchTypeID = 2 THEN lh.ExpiresDate
								  ELSE null END) AS ExpirationDate
					    FROM vetting.PersonsVetting v 
				  INNER JOIN vetting.VettingBatches b ON v.VettingBatchID = b.VettingBatchID
				  INNER JOIN vetting.VettingBatchStatuses bs ON b.VettingBatchStatusID = bs.VettingBatchStatusID
				  INNER JOIN vetting.VettingPersonStatuses ps ON v.VettingPersonStatusID = ps.VettingPersonStatusID 
				  INNER JOIN persons.PersonsUnitLibraryInfo p ON v.PersonsUnitLibraryInfoID = p.PersonsUnitLibraryInfoID
				   LEFT JOIN vetting.LeahyVettingHits lh ON v.PersonsVettingID = lh.PersonsVettingID
				       WHERE ISNULL(b.TrainingEventID, 0) <> @TrainingEventID 
                         AND p.PersonID = @PersonID  
				         AND v.VettingPersonStatusID = 2	-- APPROVED (vetting.VettingPersonStatuses)
				    ) x
					CROSS JOIN (SELECT CourtesyBatchExpirationIntervalMonths, LeahyBatchExpirationIntervalMonths FROM vetting.PostVettingConfiguration WHERE PostID = @PostID ) y
			 WHERE (CAST(ExpirationDate AS DATE) >= CAST(@EventStartDate AS DATE)	  -- ENSURE VETTING EXPIRATION DATE HAS PASSED
					AND @CreatedDate < 
						CASE WHEN ISNULL(y.CourtesyBatchExpirationIntervalMonths,0) > 0 AND VettingBatchTypeID = 1 THEN DATEADD(month, y.CourtesyBatchExpirationIntervalMonths, VettingStatusDate)
							ELSE CASE WHEN ISNULL(y.LeahyBatchExpirationIntervalMonths,0) > 0 AND VettingBatchTypeID = 2 THEN DATEADD(month, y.LeahyBatchExpirationIntervalMonths, VettingStatusDate)
								ELSE DATEADD(day, 1, @CreatedDate) END END AND ISNULL(IsReVetting,0) = 0)
				
            
			-- FOUND A VALID APPROVED STATUS, NO NEED TO SUBMIT TO VETTING
            IF (@StatusesFound > 0)
				SET @CanBeVetted = 0;
			ELSE
			BEGIN
				SET @CanBeVetted = 1;
				SELECT @IsReVetting = CASE WHEN @CreatedDate >
						CASE WHEN ISNULL(y.CourtesyBatchExpirationIntervalMonths,0) > 0 AND VettingBatchTypeID = 1 THEN DATEADD(month, y.CourtesyBatchExpirationIntervalMonths, VettingStatusDate)
							ELSE CASE WHEN ISNULL(y.LeahyBatchExpirationIntervalMonths,0) > 0 AND VettingBatchTypeID = 2 THEN DATEADD(month, y.LeahyBatchExpirationIntervalMonths, VettingStatusDate)
								ELSE DATEADD(day, 1, @CreatedDate) END END THEN 1 ELSE 0 END 
				FROM vetting.PersonsVetting v 
				  INNER JOIN vetting.VettingBatches b ON v.VettingBatchID = b.VettingBatchID 
					INNER JOIN persons.PersonsUnitLibraryInfo p ON v.PersonsUnitLibraryInfoID = p.PersonsUnitLibraryInfoID
					CROSS JOIN (SELECT CourtesyBatchExpirationIntervalMonths, LeahyBatchExpirationIntervalMonths FROM vetting.PostVettingConfiguration WHERE PostID = @PostID ) y
				WHERE ISNULL(v.IsReVetting,0) = 0 AND p.PersonID = @personID
			END
		END;
	INSERT INTO @Vettings SELECT @CanBeVetted, @IsReVetting
    RETURN 
END
