CREATE PROCEDURE [training].[SaveTrainingEventParticipantValue]
    @ColumnName NVARCHAR(100),
    @Value NVARCHAR(MAX),
    @ParticipantType NVARCHAR(20),
    @PersonID BIGINT,
    @TrainingEventID BIGINT
AS
BEGIN

    BEGIN TRY
        IF (UPPER(@ColumnName) = 'ONBOARDINGCOMPLETE')
        BEGIN
            IF (UPPER(@ParticipantType) = 'STUDENT')
                UPDATE training.TrainingEventParticipants SET OnboardingComplete = CAST(@Value AS BIT) 
                 WHERE PersonID = @PersonID AND TrainingEventID = @TrainingEventID
				 AND TrainingEventParticipantTypeID != 2;
            ELSE IF(UPPER(@ParticipantType) = 'INSTRUCTOR')
                UPDATE training.TrainingEventParticipants SET OnboardingComplete = CAST(@Value AS BIT) 
                 WHERE PersonID = @PersonID AND TrainingEventID = @TrainingEventID
				 AND TrainingEventParticipantTypeID = 2;
        END
        ELSE IF (UPPER(@ColumnName) = 'DEPARTUREDATE')
        BEGIN
            IF (UPPER(@ParticipantType) = 'STUDENT')
                UPDATE training.TrainingEventParticipants SET DepartureDate = CAST(@Value AS DATETIME) 
                 WHERE PersonID = @PersonID AND TrainingEventID = @TrainingEventID
				 AND TrainingEventParticipantTypeID != 2;
            ELSE IF(UPPER(@ParticipantType) = 'INSTRUCTOR')
                UPDATE training.TrainingEventParticipants SET DepartureDate = CAST(@Value AS DATETIME) 
                 WHERE PersonID = @PersonID AND TrainingEventID = @TrainingEventID
				 AND TrainingEventParticipantTypeID = 2;
        END
        ELSE IF (UPPER(@ColumnName) = 'RETURNDATE')
        BEGIN
            IF (UPPER(@ParticipantType) = 'STUDENT')
                UPDATE training.TrainingEventParticipants SET ReturnDate = CAST(@Value AS DATETIME) 
                 WHERE PersonID = @PersonID AND TrainingEventID = @TrainingEventID
				 AND TrainingEventParticipantTypeID != 2;
            ELSE IF(UPPER(@ParticipantType) = 'INSTRUCTOR')
                UPDATE training.TrainingEventParticipants SET ReturnDate = CAST(@Value AS DATETIME) 
                 WHERE PersonID = @PersonID AND TrainingEventID = @TrainingEventID
				 AND TrainingEventParticipantTypeID = 2;
        END
        ELSE
            THROW 50000,  'The requested value has not been configured for updates',  1 

        SELECT @@ROWCOUNT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;