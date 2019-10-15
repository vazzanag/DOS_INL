CREATE PROCEDURE [training].[SaveTrainingEventStakeholders]
    @TrainingEventID BIGINT,
    @ModifiedByAppUserID INT, 
    @Stakeholders NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        SET NOCOUNT ON;

        -- CHECK IF ASSOCIATED TrainingEvent EXISTS
        IF NOT EXISTS(SELECT * FROM training.TrainingEvents WHERE TrainingEventID = @TrainingEventID)
            THROW 50000,  'The associated training event does not exist.',  1

        -- 1. DELETE CURRENT STAKEHOLDERS
        DELETE FROM training.TrainingEventStakeholders
         WHERE TrainingEventID = @TrainingEventID
           AND AppUserID NOT IN (SELECT json.AppUserID from OPENJSON(@Stakeholders) WITH (AppUserID INT) json);

        -- 2. ADD USERS TO STAKEHOLDERS
        INSERT INTO training.TrainingEventStakeholders
        (TrainingEventID, AppUserID, ModifiedByAppUserID)
        SELECT @TrainingEventID, json.AppUserID, @ModifiedByAppUserID
          FROM OPENJSON(@Stakeholders) 
          WITH (AppUserID INT) json
         WHERE NOT EXISTS(SELECT AppUserID FROM training.TrainingEventStakeholders WHERE AppUserID = json.AppUserID AND TrainingEventID = @TrainingEventID);

        -- 3. COMMIT TRANSACTION
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END