CREATE PROCEDURE [messaging].[SaveNotificationRecipient]
    @NotificationID BIGINT,
    @AppUserID INT,
    @EmailSentDate DATETIME = NULL,
    @ViewedDate DATETIME = NULL
AS
BEGIN
    DECLARE @Identity BIGINT;

    BEGIN TRY
        IF EXISTS(SELECT * FROM messaging.NotificationRecipients WHERE NotificationID = @NotificationID AND AppUserID = @AppUserID)
        BEGIN
            -- UPDATE
            UPDATE messaging.NotificationRecipients SET
                   EmailSentDate = @EmailSentDate,
                   ViewedDate = @ViewedDate,
                   ModifiedDate = GETUTCDATE()
             WHERE NotificationID = @NotificationID 
               AND AppUserID = @AppUserID;

            SET @Identity = @AppUserID;
        END
        ELSE
        BEGIN
            -- INSERT
            INSERT INTO messaging.NotificationRecipients
            (NotificationID, AppUserID, EmailSentDate, ViewedDate)
            VALUES
            (@NotificationID, @AppUserID, @EmailSentDate, @ViewedDate);

            SET @Identity = @AppUserID;
        END

        SELECT @Identity;

    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
