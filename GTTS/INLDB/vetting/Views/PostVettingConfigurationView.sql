CREATE VIEW [vetting].[PostVettingConfigurationView]
AS
    SELECT PostID, MaxBatchSize, LeahyBatchLeadTime, CourtesyBatchLeadTime, LeahyBatchExpirationIntervalMonths, CourtesyBatchExpirationIntervalMonths
      FROM vetting.PostVettingConfiguration;