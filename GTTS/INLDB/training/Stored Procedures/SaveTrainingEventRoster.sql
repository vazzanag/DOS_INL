CREATE PROCEDURE [training].[SaveTrainingEventRoster]
    @TrainingEventRosterID BIGINT NULL, 
    @TrainingEventID BIGINT,
    @PersonID BIGINT,
    @PreTestScore TINYINT NULL,     
    @PostTestScore TINYINT NULL,      
    @PerformanceScore TINYINT NULL,  
    @ProductsScore TINYINT NULL,      
    @AttendanceScore TINYINT NULL,  
    @FinalGradeScore TINYINT NULL, 
    @Certificate BIT NULL,
    @MinimumAttendanceMet BIT NULL,
    @TrainingEventRosterDistinctionID INT NULL,    
    @TrainingEventRosterDistinction NVARCHAR(50) = NULL,
    @NonAttendanceReasonID TINYINT NULL, 
    @NonAttendanceReason NVARCHAR(50) = NULL, 
    @NonAttendanceCauseID TINYINT NULL,     
    @NonAttendanceCause NVARCHAR(50) = NULL,     
    @Comments NVARCHAR(2000) = NULL,     
	@ModifiedByAppUserID INT
AS
BEGIN
    DECLARE @Identity BIGINT;

    -- GET NON-ATTENDANCE REASON, IF APPLICABLE
    IF ((@NonAttendanceReasonID IS NULL AND @NonAttendanceReason IS NOT NULL) OR NOT EXISTS(SELECT * FROM training.NonAttendanceReasons WHERE NonAttendanceReasonID = @NonAttendanceReasonID))
    BEGIN
        SELECT @NonAttendanceReasonID = NonAttendanceReasonID 
          FROM training.NonAttendanceReasons
         WHERE TRIM(UPPER([Description])) = TRIM(UPPER(@NonAttendanceReason))
    END

    -- GET NON-ATTENDANCE CAUSE, IF APPLICABLE
    IF ((@NonAttendanceCauseID IS NULL AND @NonAttendanceCause IS NOT NULL) 
        OR NOT EXISTS(SELECT * FROM training.NonAttendanceCauses WHERE NonAttendanceCauseID = @NonAttendanceCauseID))
    BEGIN
        SELECT @NonAttendanceCauseID = NonAttendanceCauseID 
          FROM training.NonAttendanceCauses
         WHERE TRIM(UPPER([Description])) = TRIM(UPPER(@NonAttendanceCause))
    END

    -- GET ROSTER DISTINCTION, IF APPLICABLE
    IF ((@TrainingEventRosterDistinctionID IS NULL AND @TrainingEventRosterDistinction IS NOT NULL) 
        OR NOT EXISTS(SELECT * FROM training.TrainingEventRosterDistinctions WHERE TrainingEventRosterDistinctionID = @TrainingEventRosterDistinctionID))
    BEGIN
        SELECT @TrainingEventRosterDistinctionID = TrainingEventRosterDistinctionID 
          FROM training.TrainingEventRosterDistinctions
         WHERE TRIM(UPPER([Code])) = TRIM(UPPER(@TrainingEventRosterDistinction))
    END


    -- INSERT/UPDATE TrainingEventRoster record
    IF ((@TrainingEventRosterID IS NULL OR @TrainingEventRosterID = -1) 
        AND NOT EXISTS(SELECT TrainingEventRosterID FROM training.TrainingEventRosters WHERE PersonID = @PersonID AND TrainingEventID = @TrainingEventID))
        BEGIN
            -- INSERT
            INSERT INTO training.TrainingEventRosters
            (
                TrainingEventID, PersonID, PreTestScore, PostTestScore, PerformanceScore, ProductsScore, AttendanceScore,
                TrainingEventRosterDistinctionID, NonAttendanceCauseID, NonAttendanceReasonID, FinalGradeScore, [Certificate], 
                MinimumAttendanceMet, Comments, ModifiedByAppUserID
            )
            VALUES
            (
                @TrainingEventID, @PersonID, @PreTestScore, @PostTestScore, @PerformanceScore, @ProductsScore, @AttendanceScore,
                @TrainingEventRosterDistinctionID, @NonAttendanceCauseID, @NonAttendanceReasonID, @FinalGradeScore, @Certificate, 
                @MinimumAttendanceMet, @Comments, @ModifiedByAppUserID
            );

            -- GET IDENTIY
            SET @Identity = SCOPE_IDENTITY();
        END
    ELSE
        BEGIN
            -- ENSURE THE CORRECT TrainingEventRosterID
            IF NOT EXISTS(SELECT TrainingEventRosterID FROM training.TrainingEventRosters WHERE TrainingEventRosterID = @TrainingEventRosterID)
            BEGIN
                SELECT @Identity = TrainingEventRosterID 
                  FROM training.TrainingEventRosters 
                 WHERE PersonID =        @PersonID 
                   AND TrainingEventID = @TrainingEventID
            END
            ELSE
                SET @Identity = @TrainingEventRosterID;

            -- UPDATE
            UPDATE training.TrainingEventRosters SET
                   PreTestScore = @PreTestScore,
                   PostTestScore = @PostTestScore,
                   PerformanceScore = @PerformanceScore,
                   AttendanceScore = @AttendanceScore,
                   FinalGradeScore = @FinalGradeScore,
                   [Certificate] = @Certificate,
                   MinimumAttendanceMet = @MinimumAttendanceMet,
                   Comments = @Comments,
                   NonAttendanceCauseID = @NonAttendanceCauseID,
                   NonAttendanceReasonID = @NonAttendanceReasonID,
                   TrainingEventRosterDistinctionID = @TrainingEventRosterDistinctionID,
                   ModifiedByAppUserID = @ModifiedByAppUserID,
                   ModifiedDate = GETUTCDATE()
            WHERE TrainingEventRosterID = @Identity;

        END;

    -- RETURN IDENTITY
    SELECT @Identity;
END;