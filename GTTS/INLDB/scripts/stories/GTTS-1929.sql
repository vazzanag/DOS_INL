IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'TrainingEventStudents')
BEGIN
	PRINT 'EXISTS TrainingEventStudents'

	UPDATE t 
	SET t.CreatedDate = ISNULL(th.MinDate, t.ModifiedDate)
	FROM training.TrainingEventStudents t
	LEFT JOIN ( 
			SELECT TrainingEventStudentID, MIN(SysStartTime) MinDate
			FROM training.TrainingEventStudents_History 
			GROUP BY TrainingEventStudentID) th 
		ON t.TrainingEventStudentID = th.TrainingEventStudentID
	WHERE t.CreatedDate IS NULL

END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'TrainingEventInstructors')
BEGIN
	PRINT 'EXISTS TrainingEventInstructors'
	UPDATE t 
	SET t.CreatedDate = ISNULL(th.MinDate, t.ModifiedDate)
	FROM training.TrainingEventInstructors t
	LEFT JOIN ( 
			SELECT TrainingEventInstructorID, MIN(SysStartTime) MinDate
			FROM training.TrainingEventInstructors_History 
			GROUP BY TrainingEventInstructorID) th 
		ON t.TrainingEventInstructorID = th.TrainingEventInstructorID
	WHERE t.CreatedDate IS NULL

END