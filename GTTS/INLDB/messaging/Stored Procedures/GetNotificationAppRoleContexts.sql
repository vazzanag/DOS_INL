CREATE PROCEDURE [messaging].[GetNotificationAppRoleContexts]
    @NotificationID BIGINT
AS
BEGIN

    SELECT NotificationID, NotificationMessageID, NotificationContextType, NotificationContextTypeID, 
           AppRole, AppRoleID, Code
      FROM messaging.NotificationAppRoleContextsView
     WHERE NotificationID = @NotificationID;

END;
