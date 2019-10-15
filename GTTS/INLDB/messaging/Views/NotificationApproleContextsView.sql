CREATE VIEW [messaging].[NotificationAppRoleContextsView]
AS
	SELECT n.NotificationID, n.NotificationMessageID, c.[Name] AS NotificationContextType, n.NotificationContextTypeID, 
           a.Code AS AppRole, r.AppRoleID, t.Code
	  FROM messaging.Notifications n
INNER JOIN messaging.NotificationContextTypes c ON n.NotificationContextTypeID = c.NotificationContextTypeID
INNER JOIN messaging.NotificationAppRoleContexts r ON n.NotificationMessageID = r.NotificationMessageID
INNER JOIN messaging.NotificationAppRoleContextTypes t ON r.NotificationAppRoleContextTypeID = t.NotificationAppRoleContextTypeID
INNER JOIN users.AppRoles a ON r.AppRoleID = a.AppRoleID
