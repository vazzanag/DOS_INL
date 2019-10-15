CREATE PROCEDURE [vetting].[GetPersonVettingStatusesByPersonID]
    @PersonID BIGINT
AS
BEGIN

    SELECT PersonID, TrainingEventID, VettingBatchStatusID, BatchStatus, PersonsVettingStatus, 
           VettingBatchStatusDate, ExpirationDate, DateLeahyFileGenerated, RemovedFromVetting, VettingStatusDate, VettingBatchTypeID
      FROM vetting.PersonsVettingStatusesView 
     WHERE PersonID = @PersonID;  
END;
