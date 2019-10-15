CREATE PROCEDURE [messaging].[GetNotificationMessageByCode]
    @Code NVARCHAR(100)
AS
BEGIN
    SELECT NotificationMessageID, Code, MessageTemplateName, MessageTemplate, 
           ModifiedDate, ModifiedByAppUserID, AppUser, IncludeContextLink 
      FROM messaging.NotificationMessagesView
     WHERE Code = @Code;
END;
