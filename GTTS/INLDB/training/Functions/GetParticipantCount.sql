CREATE FUNCTION [training].[GetParticipantCount]
(
    @ParticipantType NVARCHAR(15),
    @TrainingEventID BIGINT,
    @TrainingEventStatusID INT = 0
)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT

    IF (@TrainingEventStatusID < 6)
    BEGIN
        IF (@ParticipantType = 'Students')
        BEGIN
            SELECT @Count = COUNT(@@ROWCOUNT) 
              FROM training.TrainingEventParticipants 
             WHERE TrainingEventID = @TrainingEventID
			 AND TrainingEventParticipantTypeID != 2
             AND ISNULL(RemovedFromEvent ,0) = 0;
        END
        ELSE IF (@ParticipantType = 'Instructors')
        BEGIN
            SELECT @Count = COUNT(@@ROWCOUNT) FROM training.TrainingEventParticipants WHERE TrainingEventID = @TrainingEventID AND TrainingEventParticipantTypeID = 2;
        END
        ELSE IF (@ParticipantType = 'Both')
        BEGIN 
            SELECT @Count = SUM(Total) 
            FROM (
                    SELECT COUNT(@@ROWCOUNT) AS Total
                      FROM training.TrainingEventParticipants 
                     WHERE TrainingEventID = @TrainingEventID
					 AND TrainingEventParticipantTypeID != 2
                       AND ISNULL(RemovedFromEvent ,0) = 0
                    UNION
                    SELECT COUNT(@@ROWCOUNT) AS Total FROM training.TrainingEventParticipants WHERE TrainingEventID = @TrainingEventID AND TrainingEventParticipantTypeID = 2
                ) a
        END
        ELSE
            SET @Count = -1;
    END
    ELSE
    BEGIN
        IF (@ParticipantType = 'Students')
        BEGIN
            SELECT @Count = COUNT(@@ROWCOUNT) 
              FROM training.TrainingEventParticipants 
             WHERE TrainingEventID = @TrainingEventID
			  AND TrainingEventParticipantTypeID != 2
               AND ISNULL(RemovedFromEvent ,0) = 0
               AND IsParticipant = 1;
        END
        ELSE IF (@ParticipantType = 'Instructors')
        BEGIN
            SELECT @Count = COUNT(@@ROWCOUNT) FROM training.TrainingEventParticipants WHERE TrainingEventID = @TrainingEventID AND TrainingEventParticipantTypeID = 2;
        END
        ELSE IF (@ParticipantType = 'Both')
        BEGIN 
            SELECT @Count = SUM(Total) 
            FROM (
                    SELECT COUNT(@@ROWCOUNT) AS Total 
                      FROM training.TrainingEventParticipants 
                     WHERE TrainingEventID = @TrainingEventID
					 AND TrainingEventParticipantTypeID != 2
                       AND ISNULL(RemovedFromEvent ,0) = 0
                       AND IsParticipant = 1
                    UNION
                    SELECT COUNT(@@ROWCOUNT) AS Total FROM training.TrainingEventParticipants WHERE TrainingEventID = @TrainingEventID AND TrainingEventParticipantTypeID = 2
                ) a
        END
        ELSE
            SET @Count = -1;
    END

    RETURN @Count;
END