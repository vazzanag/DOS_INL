CREATE PROCEDURE [messaging].[GetNotificationRecipients]
    @NotificationID BIGINT
AS
BEGIN

    SELECT NotificationID, AppUserID, ViewedDate, EmailSentDate, ModifiedDate, AppUser
      FROM messaging.NotificationRecipientsView
     WHERE NotificationID = @NotificationID;

END;
