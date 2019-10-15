CREATE VIEW [messaging].[NotificationsDetailView]
AS
    SELECT n.NotificationID, n.NotificationSubject, n.NotificationMessage, n.EmailMessage, n.NotificationContextTypeID, 
           c.[Name] AS NotificationContextType, n.ContextID, n.ModifiedDate, n.NotificationMessageID, n.ModifiedByAppUserID, 
           u.FullName AS ModifiedByAppUser, m.MessageTemplateName, m.IncludeContextLink,

           -- Recipients
           (SELECT r.NotificationID, r.AppUserID, AppUser, ViewedDate, EmailSentDate, ModifiedDate
	          FROM messaging.NotificationRecipientsView r
	         WHERE r.NotificationID = n.NotificationID FOR JSON PATH) NotificationRecipientsJSON

      FROM messaging.Notifications AS n
INNER JOIN messaging.NotificationMessages m ON n.NotificationMessageID = m.NotificationMessageID
INNER JOIN messaging.NotificationContextTypes c ON n.NotificationContextTypeID = c.NotificationContextTypeID
INNER JOIN users.AppUsersView u ON n.ModifiedByAppUserID = u.AppUserID;
