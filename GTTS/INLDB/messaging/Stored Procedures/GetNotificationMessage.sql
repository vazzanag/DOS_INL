CREATE PROCEDURE [messaging].[GetNotificationMessage]
    @NotificationMessageID INT
AS
BEGIN
    SELECT NotificationMessageID, Code MessageTemplateName, MessageTemplate, 
           ModifiedDate, ModifiedByAppUserID, AppUser, IncludeContextLink 
      FROM messaging.NotificationMessagesView
     WHERE NotificationMessageID = @NotificationMessageID;
END;
