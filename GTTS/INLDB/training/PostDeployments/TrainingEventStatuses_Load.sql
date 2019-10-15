INSERT INTO [training].[TrainingEventStatuses]
           ([Name]
           ,[Description]
		   ,[IsActive]
		   ,[ModifiedByAppUserID])
     VALUES
           ('Created', 'Training Event has been created', 1, 1),
           ('Pending Approval', 'Training Event is waiting to be approved', 1, 1),
           ('Approved', 'Training Event has been approved and is active', 1, 1),
           ('Canceled', 'Training Event was canceled by originating training unit', 1, 1),
           ('Closed', 'Training Event was canceled by host nation government', 1, 1),
           ('Completed', 'Training Event has been implemented and is awaiting final data (costs, surveys, etc.).', 1, 1),
           ('Finalized', 'All relevant Training Event data (costs, surveys, etc.) has been captured and/or entered.  Training Event is now LOCKED', 1, 1)
GO