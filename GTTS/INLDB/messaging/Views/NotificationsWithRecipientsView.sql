CREATE VIEW [messaging].[NotificationsWithRecipientsView]
AS
    SELECT n.NotificationID, n.NotificationSubject, n.NotificationMessage, n.EmailMessage, m.IncludeContextLink,
           CASE WHEN r.ViewedDate IS NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS Unread,
           c.[Name] AS NotificationContextType, n.NotificationContextTypeID, n.ContextID, n.ModifiedDate,
           r.AppUserID, r.ViewedDate, r.EmailSentDate, r.ModifiedDate AS NotificationRecipientModifiedDate
      FROM messaging.NotificationRecipients AS r 
INNER JOIN messaging.Notifications n ON n.NotificationID = r.NotificationID
INNER JOIN messaging.NotificationContextTypes c ON n.NotificationContextTypeID = c.NotificationContextTypeID
INNER JOIN messaging.NotificationMessages m ON n.NotificationMessageID = m.NotificationMessageID;

