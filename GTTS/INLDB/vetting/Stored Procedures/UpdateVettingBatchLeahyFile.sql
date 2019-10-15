CREATE PROCEDURE [vetting].[UpdateVettingBatchLeahyFile]
	@VettingBatchID BIGINT, 
	@FileID BIGINT,
	@ModifiedByAppUserID INT
AS
BEGIN
	UPDATE vetting.VettingBatches SET FileID = @FileID, ModifiedByAppUserID = @ModifiedByAppUserID WHERE VettingBatchID = @VettingBatchID
END
