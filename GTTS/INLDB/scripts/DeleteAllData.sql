/*
	Dropping and recreating the database during publish breaks the application because 
	the database loses the MSI users.  Instead of dropping the database and recreating,
	delete all the data within the database.
*/

BEGIN 
	DECLARE @SQL NVARCHAR(4000);
	DECLARE @ConstraintName NVARCHAR(200);
	DECLARE @TableName NVARCHAR(200);
	DECLARE @ViewName NVARCHAR(200);
	DECLARE @ViewSource NVARCHAR(4000);
	DECLARE @IdentityColumn NVARCHAR(200);
	DECLARE @HistoryTableName NVARCHAR(200);

	DECLARE @ForeignKeys TABLE
	(
		[Name] NVARCHAR(200),
		[TableName] NVARCHAR(200),
		[Disabled] BIT
	);

	DECLARE @Tables TABLE
	(
		[Name] NVARCHAR(200),
		[IdentityColumn] NVARCHAR(200),
		[HistoryTableName] NVARCHAR(200)
	);

	DECLARE @ViewsWithSchemaBinding TABLE
	(
		[Name] NVARCHAR(200),
		[Source] NVARCHAR(4000),
		[Dropped] BIT
	);

	
	-- Get all enabled foreign keys
	INSERT INTO @ForeignKeys
	SELECT '[' + f.[Name] + ']', '[' + s.[Name] + '].[' + t.[Name] + ']', 0
	FROM sys.foreign_keys f
	INNER JOIN sys.tables t
		ON t.object_id = f.parent_object_id
	INNER JOIN sys.schemas s
		ON s.schema_id = t.schema_id
	WHERE is_disabled = 0
	ORDER BY 2;
	
	-- Get all tables
	INSERT INTO @Tables
	SELECT '[' + s.[Name] + '].[' + t.[Name] + ']', '[' + s.[Name] + '].[' + c.[Name] + ']', '[' + s.[Name] + '].[' + h.[Name] + ']'
	FROM sys.tables t
	LEFT JOIN sys.columns c
		ON c.object_id = t.object_id
			AND c.is_identity = 1
	LEFT JOIN sys.tables h
		ON h.object_id = t.history_table_id
	INNER JOIN sys.schemas s
		ON s.schema_id = t.schema_id
	WHERE t.temporal_type_desc != 'HISTORY_TABLE'
	ORDER BY 1;
	
	-- Get all views with schema binding
	INSERT INTO @ViewsWithSchemaBinding
	SELECT '[' + s.[Name] + '].[' + v.[Name] + ']', OBJECT_DEFINITION(OBJECT_ID(s.[Name] + '.' + v.[Name])), 0
	FROM sys.views v
	INNER JOIN sys.schemas s
		ON s.schema_id = v.schema_id
	WHERE OBJECT_DEFINITION(OBJECT_ID(s.[Name] + '.' + v.[Name])) LIKE '%WITH SCHEMABINDING%'
	ORDER BY 1;


	-- Disable foreign keys
	WHILE (
		EXISTS(
			SELECT 1 
			FROM @ForeignKeys
			WHERE [Disabled] = 0
		)
	)
	BEGIN

		SELECT TOP 1 
			@ConstraintName = [Name], 
			@TableName = [TableName]
		FROM @ForeignKeys
		WHERE [Disabled] = 0;

		SET @SQL = 'ALTER TABLE ' + @TableName + ' NOCHECK CONSTRAINT' + @ConstraintName;
		PRINT @SQL;
		EXECUTE (@SQL);

		UPDATE @ForeignKeys
		SET [Disabled] = 1
		WHERE [Name] = @ConstraintName;

	END


	-- Drop schema binding views
	WHILE (
		EXISTS(
			SELECT 1 
			FROM @ViewsWithSchemaBinding
			WHERE [Dropped] = 0
		)
	)
	BEGIN

		SELECT TOP 1 
			@ViewName = [Name]
		FROM @ViewsWithSchemaBinding
		WHERE [Dropped] = 0;

		SET @SQL = 'DROP VIEW ' + @ViewName;
		PRINT @SQL;
		EXECUTE (@SQL);

		UPDATE @ViewsWithSchemaBinding
		SET [Dropped] = 1
		WHERE [Name] = @ViewName;

	END


	-- TRUNCATE tables
	WHILE (
		EXISTS(
			SELECT 1 
			FROM @Tables
		)
	)
	BEGIN

		SELECT TOP 1 
			@TableName = [Name], 
			@IdentityColumn = [IdentityColumn],
			@HistoryTableName = [HistoryTableName]
		FROM @Tables;
		
		SET @SQL = 'DELETE ' + @TableName;
		PRINT @SQL;
		EXECUTE (@SQL);

		IF (@HistoryTableName IS NOT NULL) 
		BEGIN
			SET @SQL = 
				'		
					ALTER TABLE ' + @TableName + ' SET (SYSTEM_VERSIONING = OFF);
					TRUNCATE TABLE ' + @HistoryTableName + ';
					ALTER TABLE ' + @TableName + ' SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = ' + @HistoryTableName + '));
				';
			PRINT @SQL;
			EXEC (@SQL);
		END
		
		IF (@IdentityColumn IS NOT NULL)
		BEGIN
			SET @SQL = 'DBCC CHECKIDENT (''' + @TableName + ''', RESEED, 0)';
			PRINT @SQL;
			EXECUTE (@SQL);
		END

		DELETE @Tables
		WHERE [Name] = @TableName;

	END
	

	-- Enable foreign keys
	WHILE (
		EXISTS(
			SELECT 1 
			FROM @ForeignKeys
		)
	)
	BEGIN

		SELECT TOP 1 
			@ConstraintName = [Name], 
			@TableName = [TableName]
		FROM @ForeignKeys;

		SET @SQL = 'ALTER TABLE ' + @TableName + ' CHECK CONSTRAINT' + @ConstraintName;
		PRINT @SQL;
		EXECUTE (@SQL);

		DELETE @ForeignKeys
		WHERE [Name] = @ConstraintName;

	END


	-- Rebuild schema binding in views
	WHILE (
		EXISTS(
			SELECT 1 
			FROM @ViewsWithSchemaBinding
		)
	)
	BEGIN

		SELECT TOP 1 
			@ViewName = [Name], 
			@ViewSource = [Source]
		FROM @ViewsWithSchemaBinding;
		
		SET @SQL = @ViewSource;
		PRINT @SQL;
		EXECUTE (@SQL);

		DELETE @ViewsWithSchemaBinding
		WHERE [Name] = @ViewName;

	END



END