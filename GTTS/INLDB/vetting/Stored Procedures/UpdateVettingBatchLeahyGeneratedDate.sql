CREATE PROCEDURE [vetting].[UpdateVettingBatchLeahyGeneratedDate]
	@VettingBatchID BIGINT, 
	@ModifiedByAppUserID INT
AS
BEGIN
	UPDATE vetting.VettingBatches SET DateLeahyFileGenerated = GETDATE(), ModifiedByAppUserID = @ModifiedByAppUserID WHERE VettingBatchID = @VettingBatchID
END