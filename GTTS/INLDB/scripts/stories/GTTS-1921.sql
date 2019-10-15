DECLARE @agreementID INT;

-- INSERT EXISTING VALUES FROM training.AuthorizingDocumentsAtPost
INSERT INTO training.InterAgencyAgreementsAtBusinessUnit
(BusinessUnitID, InterAgencyAgreementID, ModifiedByAppUserID)
	SELECT BusinessUnitID, p.InterAgencyAgreementID, 1
      FROM training.AuthorizingDocumentsAtPost p
INNER JOIN users.BusinessUnits b ON p.PostID = b.PostID
INNER JOIN training.InterAgencyAgreements a ON p.InterAgencyAgreementID = a.InterAgencyAgreementID
EXCEPT
	SELECT BusinessUnitID, InterAgencyAgreementID, 1
      FROM training.InterAgencyAgreementsAtBusinessUnit;

-- CAPTURE EXISTING BusinessUnitIDs FROM training.InterAgencyAgreementsAtBusinessUnits
DECLARE @ExcludedIAABusinessUnits table (BusinessUnitID INT);
INSERT INTO @ExcludedIAABusinessUnits
	SELECT BusinessUnitID FROM training.InterAgencyAgreementsAtBusinessUnit GROUP BY BusinessUnitID;

-- SETUP CURSOR FOR LOOPING OVER training.InterAgencyAgreements
DECLARE AGREEMENTS_CURSOR CURSOR
FOR SELECT InterAgencyAgreementID FROM training.InterAgencyAgreements;

OPEN AGREEMENTS_CURSOR;
FETCH NEXT FROM AGREEMENTS_CURSOR INTO @agreementID;

BEGIN TRY
    BEGIN TRANSACTION
	WHILE @@FETCH_STATUS = 0  
	BEGIN
	    
		MERGE INTO training.InterAgencyAgreementsAtBusinessUnit target
		USING ( 
				SELECT BusinessUnitID, @agreementID AS InterAgencyAgreementID, 1 AS ModifiedByAppUserID 
				  FROM users.BusinessUnits
				 WHERE BusinessUnitID NOT IN (SELECT BusinessUnitID 
												FROM @ExcludedIAABusinessUnits)
			  ) AS source
		ON (target.[BusinessUnitID] = source.[BusinessUnitID] AND target.[InterAgencyAgreementID] = source.[InterAgencyAgreementID])
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (BusinessUnitID, InterAgencyAgreementID, ModifiedByAppUserID)
			VALUES (BusinessUnitID, @agreementID, ModifiedByAppUserID);
	
		FETCH NEXT FROM AGREEMENTS_CURSOR INTO @agreementID;
	END

	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
     THROW;
END CATCH;

CLOSE AGREEMENTS_CURSOR;
DEALLOCATE AGREEMENTS_CURSOR;