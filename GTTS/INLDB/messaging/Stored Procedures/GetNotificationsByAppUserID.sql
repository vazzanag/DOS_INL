CREATE PROCEDURE [messaging].[GetNotificationsByAppUserID]
    @AppUserID INT
AS
BEGIN

    SELECT n.NotificationID, NotificationSubject, NotificationMessage, NotificationContextType, 
		   NotificationContextTypeID, ContextID, ModifiedDate, n.Unread, n.IncludeContextLink,
           AppUserID, ViewedDate, NotificationRecipientModifiedDate
      FROM messaging.NotificationsWithRecipientsView n
     WHERE AppUserID = @AppUserID
  ORDER BY Unread DESC, ModifiedDate DESC;

END;