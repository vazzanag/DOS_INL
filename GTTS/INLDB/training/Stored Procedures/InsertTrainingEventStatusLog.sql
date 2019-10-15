CREATE PROCEDURE [training].[InsertTrainingEventStatusLog]
    @TrainingEventID BIGINT,
    @TrainingEventStatus NVARCHAR(100),
    @ReasonStatusChanged NVARCHAR(750) = NULL,
    @ModifiedByAppUserID INT
AS
BEGIN
    DECLARE @TrainingEventStatusID INT;

    -- Get Status ID
    IF NOT EXISTS(SELECT TrainingEventStatusID FROM training.TrainingEventStatuses WHERE [Name] = @TrainingEventStatus)
        THROW 50000,  'The specified status not exist.',  1
    ELSE
        SELECT @TrainingEventStatusID = TrainingEventStatusID FROM training.TrainingEventStatuses WHERE [Name] = @TrainingEventStatus

    -- Insert status log record
    INSERT INTO training.TrainingEventStatusLog
    (TrainingEventID, TrainingEventStatusID, ReasonStatusChanged, ModifiedByAppUserID)
    VALUES
    (@TrainingEventID, @TrainingEventStatusID, @ReasonStatusChanged, @ModifiedByAppUserID);

    SELECT SCOPE_IDENTITY();
END
