CREATE PROCEDURE [messaging].[GetNumUnreadNotificationsByAppUserID]
    @AppUserID INT
AS
BEGIN

    SELECT COUNT(@@ROWCOUNT)
      FROM messaging.NotificationRecipientsView
     WHERE AppUserID = @AppUserID
       AND ViewedDate IS NULL;

END;