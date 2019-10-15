/*  Load Script Identifier for Build/Publish  */
PRINT 'BEGIN training.RemovalReasons_Load'

/*
    The [SortControl] column is used to identify a sequence value to assist in 
    controlling the display order of the table records in a list.  The list 
    should be ORDERED BY [SortControl], [Description].  This allows the specific
    grouping of records to be ordered in a specific manner.  Within each group,
    records would be listed alphabetically.  
    
    This technique will enable a reference list to be listed alphabetically
    ([SortControl] = 1) with a specific value (for example: "Other") forced
    to the bottom of the list ([SortControl] = 2).  This technique will also 
    support multiple groupings of records within a list as well 
    ([SortControl] = 1, 2, 3, 4, ...).
*/

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [training].[RemovalReasons] ON
GO

/*  Verify that reference table exists and populate with data.  */
IF NOT EXISTS(SELECT * FROM [training].[RemovalReasons]) 
	BEGIN
		/*  INSERT VALUES into the table  */
		INSERT INTO [training].[RemovalReasons]
				([RemovalReasonID]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
                ,[SortControl]
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Administrative', 1, 1, 1),               
				(2, 'Cancellation', 1, 2, 1), 
                (3, 'Docs Incomplete', 1, 1, 1), 
				(4, 'No-show', 1, 2, 1),
                (5, 'Prerequisites unmet', 1, 1, 1), 
				(6, 'Other', 1, 1, 1)
				
				
	END

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [training].[RemovalReasons] OFF
GO

/*  Set new INDENTIY Starting VALUE to maximum column value */
DBCC CHECKIDENT ('[training].[RemovalReasons]', RESEED)
GO