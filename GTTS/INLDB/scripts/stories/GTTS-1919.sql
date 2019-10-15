DECLARE @KAId INT

--Inserting existing values from [training].[KeyActivitiesAtPost]

INSERT INTO training.KeyActivitiesAtBusinessUnit
(BusinessUnitID, KeyActivityID, ModifiedByAppUserID)
	SELECT BusinessUnitID, p.KeyActivityID, 1
      FROM training.KeyActivitiesAtPost p
INNER JOIN users.BusinessUnits b ON p.PostID = b.PostID
INNER JOIN training.KeyActivities a ON p.KeyActivityID = a.KeyActivityID
EXCEPT
	SELECT BusinessUnitID, KeyActivityID, 1
      FROM training.KeyActivitiesAtBusinessUnit;

-- CAPTURE EXISTING BusinessUnitIDs FROM [training].[KeyActivitiesAtPost]
DECLARE @ExcludedKABusinessUnits table (BusinessUnitID INT);
INSERT INTO @ExcludedKABusinessUnits
	SELECT BusinessUnitID FROM training.KeyActivitiesAtBusinessUnit GROUP BY BusinessUnitID;

DECLARE TYPES_CURSOR CURSOR
FOR SELECT KeyActivityID FROM training.KeyActivities;

OPEN TYPES_CURSOR;
FETCH NEXT FROM TYPES_CURSOR INTO @KAId;

BEGIN TRANSACTION
BEGIN TRY
	WHILE @@FETCH_STATUS = 0  
	BEGIN
	
		MERGE INTO training.KeyActivitiesAtBusinessUnit target
		USING ( 
				SELECT BusinessUnitID, @KAId AS KeyActivityID, 1 AS ModifiedByAppUserID 
				  FROM users.BusinessUnits
				 WHERE BusinessUnitID NOT IN (SELECT BusinessUnitID 
												FROM @ExcludedKABusinessUnits)
			  ) AS source
		ON (target.[BusinessUnitID] = source.[BusinessUnitID] AND target.[KeyActivityID] = source.[KeyActivityID])
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (BusinessUnitID, KeyActivityID, ModifiedByAppUserID)
			VALUES (BusinessUnitID, @KAId, ModifiedByAppUserID);
	
		FETCH NEXT FROM TYPES_CURSOR INTO @KAId;
	END
	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
     THROW;
END CATCH;

CLOSE TYPES_CURSOR;
DEALLOCATE TYPES_CURSOR;