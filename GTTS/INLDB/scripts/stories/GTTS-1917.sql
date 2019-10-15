DECLARE @typeId INT

DECLARE TYPES_CURSOR CURSOR
FOR SELECT trainingeventtypeid FROM training.TrainingEventTypes;

OPEN TYPES_CURSOR;
FETCH NEXT FROM TYPES_CURSOR INTO @typeId;

BEGIN TRY
    BEGIN TRANSACTION
	WHILE @@FETCH_STATUS = 0  
	BEGIN
	    
		MERGE INTO training.TrainingEventTypesAtBusinessUnit target
		USING ( 
				SELECT BusinessUnitID, @typeId AS TrainingEventTypeID, 1 AS ModifiedByAppUserID 
				  FROM users.BusinessUnits
			  ) AS source
		ON (target.[BusinessUnitID] = source.[BusinessUnitID] AND target.[TrainingEventTypeID] = source.[TrainingEventTypeID])
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (BusinessUnitID, TrainingEventTypeID, ModifiedByAppUserID)
			VALUES (BusinessUnitID, @typeId, ModifiedByAppUserID);
	
		FETCH NEXT FROM TYPES_CURSOR INTO @typeId;
	END
	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
     THROW;
END CATCH;

CLOSE TYPES_CURSOR;
DEALLOCATE TYPES_CURSOR;