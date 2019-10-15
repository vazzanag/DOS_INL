
IF NOT EXISTS(SELECT * FROM [training].[ApprovalEventTypes]) 
BEGIN
    INSERT INTO [training].[ApprovalEventTypes]
	    ([Name], [ModifiedByAppUserID]) 
    VALUES 
	    ('Awaiting Approval', 1)

    INSERT INTO [training].[ApprovalEventTypes]
	    ([Name], [ModifiedByAppUserID]) 
    VALUES 
	    ('Approved', 1)


    INSERT INTO [training].[ApprovalEventTypes]
	    ([Name], [ModifiedByAppUserID]) 
    VALUES 
	    ('Rejected', 1)
END
GO