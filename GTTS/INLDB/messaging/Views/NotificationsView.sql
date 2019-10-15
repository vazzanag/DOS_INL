CREATE VIEW [messaging].[NotificationsView]
AS
    SELECT n.NotificationID, n.NotificationSubject, n.NotificationMessage, n.EmailMessage, m.IncludeContextLink,
           c.[Name] AS NotificationContextType, n.NotificationContextTypeID, n.ContextID, n.ModifiedDate
      FROM messaging.Notifications AS n
INNER JOIN messaging.NotificationContextTypes c ON n.NotificationContextTypeID = c.NotificationContextTypeID
INNER JOIN messaging.NotificationMessages m ON n.NotificationMessageID = m.NotificationMessageID;;