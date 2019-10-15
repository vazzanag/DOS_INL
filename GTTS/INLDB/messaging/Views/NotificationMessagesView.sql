CREATE VIEW [messaging].[NotificationMessagesView]
AS
    SELECT NotificationMessageID, Code, MessageTemplateName, MessageTemplate, IncludeContextLink,
           m.ModifiedDate, m.ModifiedByAppUserID, u.FullName AS AppUser
      FROM messaging.NotificationMessages m
INNER JOIN users.AppUsersView u ON m.ModifiedByAppUserID = u.AppUserID;