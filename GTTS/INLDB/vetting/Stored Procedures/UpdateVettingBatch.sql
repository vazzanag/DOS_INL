CREATE PROCEDURE [vetting].[UpdateVettingBatch]
	@VettingBatchID BIGINT, 
	@ModifiedByAppUserID INT,
	@INKTrackingNumber NVARCHAR(50),
	@LeahyTrackingNumber NVARCHAR(100),
	@VettingBatchNotes NVARCHAR(500)
AS
BEGIN
	UPDATE vetting.VettingBatches 
	SET INKTrackingNumber = @INKTrackingNumber,
		LeahyTrackingNumber = @LeahyTrackingNumber,
		VettingBatchNotes = @VettingBatchNotes,
		ModifiedByAppUserID = @ModifiedByAppUserID 
	WHERE VettingBatchID = @VettingBatchID

	SELECT @VettingBatchID
END