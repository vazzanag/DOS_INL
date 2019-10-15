CREATE VIEW [search].[NotificationVettingView]
WITH SCHEMABINDING
AS
    SELECT n.NotificationID, n.NotificationSubject, n.NotificationMessage, n.EmailMessage, n.NotificationContextTypeID, 
           c.[Name] AS NotificationContextType, n.ContextID, n.ModifiedDate, n.NotificationMessageID, n.ModifiedByAppUserID, 
            m.MessageTemplateName, v.VettingBatchName, GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber
      FROM messaging.Notifications AS n
INNER JOIN messaging.NotificationMessages m ON n.NotificationMessageID = m.NotificationMessageID
INNER JOIN messaging.NotificationContextTypes c ON n.NotificationContextTypeID = c.NotificationContextTypeID
INNER JOIN vetting.VettingBatches v ON n.ContextID = v.VettingBatchID AND n.NotificationContextTypeID = 2;
GO

CREATE UNIQUE CLUSTERED INDEX IDX_NotificationVettingView_NotificationID
    ON search.NotificationVettingView (NotificationID);  
GO 

CREATE FULLTEXT INDEX ON [search].[NotificationVettingView]
    (NotificationContextType, NotificationSubject, NotificationMessage, VettingBatchName, 
	 GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber) 
    KEY INDEX [IDX_NotificationVettingView_NotificationID] ON FullTextCatalog 
    WITH CHANGE_TRACKING AUTO; 
GO