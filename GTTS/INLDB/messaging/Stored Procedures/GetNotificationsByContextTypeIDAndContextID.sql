CREATE PROCEDURE [messaging].[GetNotificationsByContextTypeIDAndContextID]
    @NotificationContextTypeID INT,
    @ContextID BIGINT
AS
BEGIN

    SELECT NotificationID, NotificationSubject, NotificationMessage, NotificationContextType, 
		   NotificationContextTypeID, ContextID, ModifiedDate, IncludeContextLink
      FROM messaging.NotificationsView 
    WHERE NotificationContextTypeID = @NotificationContextTypeID
      AND ContextID = @ContextID;

END