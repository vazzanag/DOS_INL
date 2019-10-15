CREATE PROCEDURE [vetting].[AssignVettingBatch]
	@VettingBatchID BIGINT,
	@AssignedToAppUserID BIGINT = NULL,
	@ModifiedByAppUserID BIGINT
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
			BEGIN
				UPDATE vetting.VettingBatches SET
					   AssignedToAppUserID = @AssignedToAppUserID,
					   ModifiedByAppUserID = @ModifiedByAppUserID
			    WHERE VettingBatchID = @VettingBatchID

				-- RETURN the Identity
				SELECT @VettingBatchID;
			END
		-- NO ERRORS,  COMMIT
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
