DECLARE @agencyID INT

DECLARE AGENCY_CURSOR CURSOR
FOR SELECT AgencyID FROM unitlibrary.USPartnerAgencies;

OPEN AGENCY_CURSOR;
FETCH NEXT FROM AGENCY_CURSOR INTO @agencyID;

BEGIN TRANSACTION
BEGIN TRY
	WHILE @@FETCH_STATUS = 0  
	BEGIN
	
		MERGE INTO training.USPartnerAgenciesAtBusinessUnit target
		USING ( 
				SELECT BusinessUnitID, @agencyID AS AgencyID, 1 AS ModifiedByAppUserID 
				  FROM users.BusinessUnits
			  ) AS source
		ON (target.[BusinessUnitID] = source.[BusinessUnitID] AND target.[AgencyID] = source.[AgencyID])
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (BusinessUnitID, AgencyID, ModifiedByAppUserID)
			VALUES (BusinessUnitID, @agencyID, ModifiedByAppUserID);
	
		FETCH NEXT FROM AGENCY_CURSOR INTO @agencyID;
	END
	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
     THROW;
END CATCH;

CLOSE AGENCY_CURSOR;
DEALLOCATE AGENCY_CURSOR;