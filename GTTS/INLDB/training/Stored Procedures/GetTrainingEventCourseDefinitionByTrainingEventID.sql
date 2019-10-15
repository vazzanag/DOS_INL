CREATE PROCEDURE [training].[GetTrainingEventCourseDefinitionByTrainingEventID]
    @TrainingEventID BIGINT
AS
BEGIN

    SELECT TrainingEventCourseDefinitionID, TrainingEventID, CourseDefinitionID, CourseRosterKey, 
           TestsWeighting, PerformanceWeighting, ProductsWeighting, MinimumAttendance, MinimumFinalGrade,
           IsActive, CourseDefinition, CourseProgram, PerformanceRosterUploaded, PerformanceRosterUploadedByAppUserID,
           PerformanceRosterUploadedByFirstName, PerformanceRosterUploadedByLastName, PerformanceRosterUploadedDate, 
           ModifiedByAppUserID, ModifiedDate
      FROM training.TrainingEventCourseDefinitionsView
     WHERE TrainingEventID = @TrainingEventID;

END;