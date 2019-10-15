CREATE PROCEDURE training.SaveTrainingEventCourseDefinitionUploadStatus
    @TrainingEventID BIGINT,
    @PerformanceRosterUploaded BIT,
    @PerformanceRosterUploadedByAppUserID INT
AS
BEGIN
    
    UPDATE training.TrainingEventCourseDefinitions SET
           PerformanceRosterUploaded = @PerformanceRosterUploaded,
           PerformanceRosterUploadedByAppUserID = @PerformanceRosterUploadedByAppUserID,
           PerformanceRosterUploadedDate = GETUTCDATE()
     WHERE TrainingEventID = @TrainingEventID;

     SELECT TrainingEventCourseDefinitionID FROM training.TrainingEventCourseDefinitions WHERE TrainingEventID = @TrainingEventID;

END;