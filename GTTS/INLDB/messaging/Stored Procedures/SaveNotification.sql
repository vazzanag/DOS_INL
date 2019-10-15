CREATE PROCEDURE [messaging].[SaveNotification]
    @NotificationID BIGINT = NULL, 
    @NotificationContextTypeID INT,
    @ContextID BIGINT,
    @NotificationMessageID INT,
    @ModifiedByAppUserID INT,
    @NotificationMessage NVARCHAR(MAX),
    @NotificationSubject NVARCHAR(250),
    @EmailMessage NVARCHAR(MAX)
AS
BEGIN

    BEGIN TRANSACTION;

    BEGIN TRY
        
        DECLARE @Identity BIGINT;

        IF @NotificationID IS NULL
        BEGIN
            INSERT INTO messaging.Notifications
            (NotificationContextTypeID, ContextID, NotificationMessageID, NotificationMessage, NotificationSubject, EmailMessage, ModifiedByAppUserID)
            VALUES
            (@NotificationContextTypeID, @ContextID, @NotificationMessageID, @NotificationMessage, @NotificationSubject, @EmailMessage, @ModifiedByAppUserID);

            SET @Identity = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            IF NOT EXISTS(SELECT NotificationID FROM messaging.Notifications WHERE NotificationID = @NotificationID)
                THROW 50000,  'The requested notification to be updated does not exist.',  1;

            UPDATE messaging.Notifications SET
                   NotificationContextTypeID = @NotificationContextTypeID,
                   ContextID = @ContextID,
                   NotificationMessageID = @NotificationMessageID,
                   NotificationMessage = @NotificationMessage,
                   NotificationSubject = @NotificationSubject,
                   EmailMessage = @EmailMessage,
                   ModifiedByAppUserID = @ModifiedByAppUserID,
                   ModifiedDate = GETUTCDATE()
             WHERE NotificationID = @NotificationID;

             SET @Identity = @NotificationID;
        END;

        -- COMMIT TRANSACTION
        COMMIT;

        -- RETURN IDENTITY
        SELECT @Identity;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
