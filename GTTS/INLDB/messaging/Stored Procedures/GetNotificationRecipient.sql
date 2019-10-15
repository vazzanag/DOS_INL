CREATE PROCEDURE [messaging].[GetNotificationRecipient]
    @NotificationID BIGINT,
    @AppUserID INT
AS
BEGIN

    SELECT NotificationID, AppUserID, ViewedDate, EmailSentDate, ModifiedDate, AppUser
      FROM messaging.NotificationRecipientsView
     WHERE NotificationID = @NotificationID
       AND AppUserID = @AppUserID;
END;
