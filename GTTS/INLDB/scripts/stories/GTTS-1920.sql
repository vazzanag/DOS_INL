DECLARE @codeId INT;

DECLARE CODES_CURSOR CURSOR
FOR SELECT ProjectCodeID FROM training.ProjectCodes;

OPEN CODES_CURSOR;
FETCH NEXT FROM CODES_CURSOR INTO @codeId;

BEGIN TRY
    BEGIN TRANSACTION
	WHILE @@FETCH_STATUS = 0  
	BEGIN
	    
		MERGE INTO training.ProjectCodesAtBusinessUnit target
		USING ( 
				SELECT BusinessUnitID, @codeId AS ProjectCodeID, 1 AS ModifiedByAppUserID 
				  FROM users.BusinessUnits
			  ) AS source
		ON (target.[BusinessUnitID] = source.[BusinessUnitID] AND target.[ProjectCodeID] = source.[ProjectCodeID])
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (BusinessUnitID, ProjectCodeID, ModifiedByAppUserID)
			VALUES (BusinessUnitID, @codeId, ModifiedByAppUserID);
	
		FETCH NEXT FROM CODES_CURSOR INTO @codeId;
	END
	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
     THROW;
END CATCH;

CLOSE CODES_CURSOR;
DEALLOCATE CODES_CURSOR;