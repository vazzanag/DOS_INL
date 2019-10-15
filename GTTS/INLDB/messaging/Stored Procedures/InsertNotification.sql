CREATE PROCEDURE [messaging].[InsertNotification]
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

        --1) INSERT RECRD INTO messaging.Notifications
        INSERT INTO messaging.Notifications
        (NotificationContextTypeID, ContextID, NotificationMessageID, NotificationMessage, NotificationSubject, EmailMessage, ModifiedByAppUserID)
        VALUES
        (@NotificationContextTypeID, @ContextID, @NotificationMessageID, @NotificationMessage, @NotificationSubject, @EmailMessage, @ModifiedByAppUserID);

        SET @Identity = SCOPE_IDENTITY();

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
