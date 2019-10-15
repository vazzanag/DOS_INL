CREATE PROCEDURE [messaging].[GetNotificationAppRoleContext]
    @NotificationID BIGINT,
    @AppRole NVARCHAR(50)
AS
BEGIN

    SELECT NotificationID, NotificationMessageID, NotificationContextType, NotificationContextTypeID, 
           AppRole, AppRoleID, Code
      FROM messaging.NotificationAppRoleContextsView
     WHERE NotificationID = @NotificationID
       AND AppRole = @AppRole;
END;
