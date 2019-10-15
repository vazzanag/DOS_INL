CREATE VIEW [messaging].[NotificationRecipientsView]
AS 
    SELECT r.NotificationID, r.AppUserID, r.ViewedDate, r.EmailSentDate, r.ModifiedDate,
           CASE WHEN r.ViewedDate IS NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS Unread, u.FullName AS AppUser
      FROM messaging.NotificationRecipients r
INNER JOIN users.AppUsersView u ON r.AppUserID = u.AppUserID;