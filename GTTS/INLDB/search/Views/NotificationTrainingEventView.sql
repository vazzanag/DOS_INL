CREATE VIEW [search].[NotificationTrainingEventView]
WITH SCHEMABINDING
AS
    SELECT n.NotificationID, n.NotificationSubject, n.NotificationMessage, n.EmailMessage, n.NotificationContextTypeID, 
           c.[Name] AS NotificationContextType, n.ContextID, n.ModifiedDate, n.NotificationMessageID, n.ModifiedByAppUserID, 
            m.MessageTemplateName, e.[Name], NameInLocalLang
      FROM messaging.Notifications AS n
INNER JOIN messaging.NotificationMessages m ON n.NotificationMessageID = m.NotificationMessageID
INNER JOIN messaging.NotificationContextTypes c ON n.NotificationContextTypeID = c.NotificationContextTypeID
INNER JOIN training.TrainingEvents e ON n.ContextID = e.TrainingEventID AND n.NotificationContextTypeID = 1;
GO

CREATE UNIQUE CLUSTERED INDEX IDX_NotificationTrainingEventView_NotificationID
    ON search.NotificationTrainingEventView (NotificationID);  
GO 

CREATE FULLTEXT INDEX ON [search].[NotificationTrainingEventView]
    (NotificationContextType, NotificationSubject, NotificationMessage, 
	 [Name], NameInLocalLang) 
    KEY INDEX [IDX_NotificationTrainingEventView_NotificationID] ON FullTextCatalog 
    WITH CHANGE_TRACKING AUTO; 
GO