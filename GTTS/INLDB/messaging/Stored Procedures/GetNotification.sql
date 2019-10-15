CREATE PROCEDURE [messaging].[GetNotification]
    @NotificationID BIGINT
AS
BEGIN
    
    SELECT NotificationID, NotificationSubject, NotificationMessage, EmailMessage, NotificationContextTypeID, 
           NotificationContextType, ContextID, ModifiedDate, NotificationMessageID, ModifiedByAppUserID, 
           ModifiedByAppUser, MessageTemplateName, NotificationRecipientsJSON
      FROM messaging.NotificationsDetailView
    WHERE NotificationID = @NotificationID;

END;