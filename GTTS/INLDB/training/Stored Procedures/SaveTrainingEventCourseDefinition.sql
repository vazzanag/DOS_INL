CREATE PROCEDURE training.SaveTrainingEventCourseDefinition
    @TrainingEventID BIGINT,
    @CourseDefinitionID INT = NULL , 
    @CourseRosterKey NVARCHAR(30), 
    @TestsWeighting TINYINT,     
    @PerformanceWeighting TINYINT,    
    @ProductsWeighting TINYINT,
    @MinimumAttendance TINYINT,
    @MinimumFinalGrade TINYINT,
    @IsActive BIT,    
	@ModifiedByAppUserID INT
AS
BEGIN
    DECLARE @Identity BIGINT;

    -- SET VALUES OF CourseDefinitionID IS PASSED AND IS VALID
    IF @CourseDefinitionID IS NOT NULL AND EXISTS(SELECT CourseDefinitionID FROM training.CourseDefinitions WHERE CourseDefinitionID = @CourseDefinitionID)
    BEGIN
        SELECT @TestsWeighting = TestsWeighting, @PerformanceWeighting = PerformanceWeighting, @ProductsWeighting = ProductsWeighting,
               @MinimumAttendance = MinimumAttendance, @MinimumFinalGrade = MinimumFinalGrade
          FROM training.CourseDefinitions
         WHERE CourseDefinitionID = @CourseDefinitionID;
    END;

    IF (NOT EXISTS(SELECT TrainingEventCourseDefinitionID FROM training.TrainingEventCourseDefinitions WHERE TrainingEventID = @TrainingEventID))
        BEGIN
             -- INSERT
            INSERT INTO training.TrainingEventCourseDefinitions
            (
                TrainingEventID, CourseDefinitionID, CourseRosterKey, TestsWeighting, PerformanceWeighting, ProductsWeighting,
                MinimumAttendance, MinimumFinalGrade, IsActive, ModifiedByAppUserID, ModifiedDate
            )
            VALUES
            (
                @TrainingEventID, @CourseDefinitionID, @CourseRosterKey, @TestsWeighting, @PerformanceWeighting, @ProductsWeighting,
                @MinimumAttendance, @MinimumFinalGrade, @IsActive, @ModifiedByAppUserID, GETUTCDATE()
            );
            
        END
    ELSE
        BEGIN
           -- UPDATE
            UPDATE training.TrainingEventCourseDefinitions SET
                   CourseDefinitionID =     @CourseDefinitionID,
                   CourseRosterKey =        @CourseRosterKey,
                   TestsWeighting =         @TestsWeighting,
                   PerformanceWeighting =   @PerformanceWeighting,
                   ProductsWeighting =      @ProductsWeighting,
                   MinimumAttendance =      @MinimumAttendance,
                   MinimumFinalGrade =      @MinimumFinalGrade,
                   IsActive =               @IsActive,
                   ModifiedByAppUserID =    @ModifiedByAppUserID,
                   ModifiedDate =           GETUTCDATE()
             WHERE TrainingEventID = @TrainingEventID;
        END;

    -- RETURN the TrainingEventID
    SELECT @TrainingEventID;

END;