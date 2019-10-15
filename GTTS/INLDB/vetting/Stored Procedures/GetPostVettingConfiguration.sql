CREATE PROCEDURE [vetting].[GetPostVettingConfiguration]
    @PostID INT
AS
BEGIN

    SELECT PostID, MaxBatchSize, LeahyBatchLeadTime, CourtesyBatchLeadTime, LeahyBatchExpirationIntervalMonths, CourtesyBatchExpirationIntervalMonths 
      FROM vetting.PostVettingConfigurationView
     WHERE PostID = @PostID

END