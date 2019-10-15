CREATE VIEW [training].[TrainingEventCourseDefinitionsView]
AS 
    SELECT d.TrainingEventCourseDefinitionID, d.TrainingEventID, d.CourseDefinitionID, d.CourseRosterKey, 
           d.TestsWeighting, d.PerformanceWeighting, d.ProductsWeighting, d.MinimumAttendance, d.MinimumFinalGrade,
           d.IsActive, c.[Description] CourseDefinition, p.Code CourseProgram, d.PerformanceRosterUploaded, 
           d.PerformanceRosterUploadedByAppUserID, u.[First] AS PerformanceRosterUploadedByFirstName, 
           u.[Last] AS PerformanceRosterUploadedByLastName, d.PerformanceRosterUploadedDate, d.ModifiedByAppUserID, d.ModifiedDate
      FROM training.TrainingEventCourseDefinitions d
 LEFT JOIN training.CourseDefinitions c ON d.CourseDefinitionID = c.CourseDefinitionID
 LEFT JOIN training.CourseDefinitionPrograms p ON c.CourseDefinitionProgramID = p.CourseDefinitionProgramID
 LEFT JOIN users.AppUsersView u ON d.PerformanceRosterUploadedByAppUserID = u.AppUserID;
