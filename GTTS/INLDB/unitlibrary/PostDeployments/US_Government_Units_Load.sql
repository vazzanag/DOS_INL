PRINT 'BEGIN US_Government_Units_Load'

IF (NOT EXISTS(SELECT * FROM [unitlibrary].[Units] WHERE CountryID = 2254))
	BEGIN
	
		DECLARE @CountryID INT = 2254;
		DECLARE @UnitName NVARCHAR(300);
		DECLARE @UnitAcronym NVARCHAR(30);
		DECLARE @IsMainAgency BIT = 1;
		DECLARE @UnitMainAgencyID BIGINT = NULL;
		DECLARE @UnitParentID BIGINT = NULL;
		
		/* United States */
		SET @UnitMainAgencyID = NULL;
		SET @UnitParentID = NULL;
		SET @UnitName = 'United States';
		SET @UnitAcronym = 'USA';
		SET @IsMainAgency = 1;
		INSERT INTO unitlibrary.units
		([UnitName], [UnitNameEnglish], [UnitAcronym], 
		 [CountryID], [UnitParentID], [IsMainAgency], [UnitMainAgencyID], [UnitGenID], 
		 [UnitTypeID], [GovtLevelID], [VettingBatchTypeID], [VettingActivityTypeID], [VettingPrefix], [ModifiedByAppUserID])
		VALUES
		(@UnitName, @UnitName, @UnitAcronym, 
		 @CountryID, @UnitParentID, @IsMainAgency, @UnitMainAgencyID, unitlibrary.NewUnitGenID(@IsMainAgency, @UnitMainAgencyID, @UnitAcronym), 
		 2, 2, 3, 4, NULL, 1);
		
		SET @UnitMainAgencyID = SCOPE_IDENTITY();
		SET @UnitParentID = SCOPE_IDENTITY();
		
		UPDATE unitlibrary.units 
		SET UnitMainAgencyID = UnitID
		WHERE UnitID = SCOPE_IDENTITY() 
			   

		/* Department of State */		
		SELECT @UnitMainAgencyID = UnitID, @UnitParentID = UnitID
		FROM unitlibrary.Units
		WHERE UnitAcronym = 'USA'
		
		SET @UnitName = 'Department of State';
		SET @UnitAcronym = 'DOS';
		SET @IsMainAgency = 1;
		INSERT INTO unitlibrary.units
		([UnitName], [UnitNameEnglish], [UnitAcronym], 
		 [CountryID], [UnitParentID], [IsMainAgency], [UnitMainAgencyID], [UnitGenID], 
		 [UnitTypeID], [GovtLevelID], [VettingBatchTypeID], [VettingActivityTypeID], [VettingPrefix], [ModifiedByAppUserID])
		VALUES
		(@UnitName, @UnitName, @UnitAcronym,  
		 @CountryID, @UnitParentID, @IsMainAgency, @UnitMainAgencyID, unitlibrary.NewUnitGenID(@IsMainAgency, @UnitMainAgencyID, @UnitAcronym), 
		 2, 2, 3, 4, NULL, 1);
		 				

		/* Department of Defense */
		SELECT @UnitMainAgencyID = UnitID, @UnitParentID = UnitID
		FROM unitlibrary.Units
		WHERE UnitAcronym = 'USA'
		
		SET @UnitName = 'Department of Defense';
		SET @UnitAcronym = 'DOD';
		SET @IsMainAgency = 1;
		INSERT INTO unitlibrary.units
		([UnitName], [UnitNameEnglish], [UnitAcronym], 
		 [CountryID], [UnitParentID], [IsMainAgency], [UnitMainAgencyID], [UnitGenID], 
		 [UnitTypeID], [GovtLevelID], [VettingBatchTypeID], [VettingActivityTypeID], [VettingPrefix], [ModifiedByAppUserID])
		VALUES
		(@UnitName, @UnitName, @UnitAcronym,  
		 @CountryID, @UnitParentID, @IsMainAgency, @UnitMainAgencyID, unitlibrary.NewUnitGenID(@IsMainAgency, @UnitMainAgencyID, @UnitAcronym), 
		 2, 2, 3, 4, NULL, 1);


		/* Department of Justice */
		SELECT @UnitMainAgencyID = UnitID, @UnitParentID = UnitID
		FROM unitlibrary.Units
		WHERE UnitAcronym = 'USA'
		
		SET @UnitName = 'Department of Justice';
		SET @UnitAcronym = 'DOJ';
		SET @IsMainAgency = 1;
		INSERT INTO unitlibrary.units
		([UnitName], [UnitNameEnglish], [UnitAcronym], 
		 [CountryID], [UnitParentID], [IsMainAgency], [UnitMainAgencyID], [UnitGenID], 
		 [UnitTypeID], [GovtLevelID], [VettingBatchTypeID], [VettingActivityTypeID], [VettingPrefix], [ModifiedByAppUserID])
		VALUES
		(@UnitName, @UnitName, @UnitAcronym, 
		 @CountryID, @UnitParentID, @IsMainAgency, @UnitMainAgencyID, unitlibrary.NewUnitGenID(@IsMainAgency, @UnitMainAgencyID, @UnitAcronym), 
		 2, 2, 3, 4, NULL, 1);
		 		 

		/* INL */
		SELECT @UnitMainAgencyID = UnitID, @UnitParentID = UnitID
		FROM unitlibrary.Units
		WHERE UnitAcronym = 'DOS'
		
		SET @UnitName = 'Bureau of International Narcotics and Law Enforcement Affairs';
		SET @UnitAcronym = 'INL';
		SET @IsMainAgency = 0;
		INSERT INTO unitlibrary.units
		([UnitName], [UnitNameEnglish], [UnitAcronym], 
		 [CountryID], [UnitParentID], [IsMainAgency], [UnitMainAgencyID], [UnitGenID], 
		 [UnitTypeID], [GovtLevelID], [VettingBatchTypeID], [VettingActivityTypeID], [VettingPrefix], [ModifiedByAppUserID])
		VALUES
		(@UnitName, @UnitName, @UnitAcronym,  
		 @CountryID, @UnitParentID, @IsMainAgency, @UnitMainAgencyID, unitlibrary.NewUnitGenID(@IsMainAgency, @UnitMainAgencyID, @UnitAcronym), 
		 2, 2, 3, 4, NULL, 1);
		

		/* Consular Affairs */
		SELECT @UnitMainAgencyID = UnitID, @UnitParentID = UnitID
		FROM unitlibrary.Units
		WHERE UnitAcronym = 'DOS'
		
		SET @UnitName = 'Bureau of Consular Affairs';
		SET @UnitAcronym = 'CONS';
		SET @IsMainAgency = 0;
		INSERT INTO unitlibrary.units
		([UnitName], [UnitNameEnglish], [UnitAcronym], 
		 [CountryID], [UnitParentID], [IsMainAgency], [UnitMainAgencyID], [UnitGenID], 
		 [UnitTypeID], [GovtLevelID], [VettingBatchTypeID], [VettingActivityTypeID], [VettingPrefix], [ModifiedByAppUserID])
		VALUES
		(@UnitName, @UnitName, @UnitAcronym, 
		 @CountryID, @UnitParentID, @IsMainAgency, @UnitMainAgencyID, unitlibrary.NewUnitGenID(@IsMainAgency, @UnitMainAgencyID, @UnitAcronym), 
		 2, 2, 3, 4, NULL, 1);		 	 		 		 
		

		/* FBI */
		SELECT @UnitMainAgencyID = UnitID, @UnitParentID = UnitID
		FROM unitlibrary.Units
		WHERE UnitAcronym = 'DOJ'
		
		SET @UnitName = 'Federal Bureau of Investigation';
		SET @UnitAcronym = 'FBI';
		SET @IsMainAgency = 0;
		INSERT INTO unitlibrary.units
		([UnitName], [UnitNameEnglish], [UnitAcronym], 
		 [CountryID], [UnitParentID], [IsMainAgency], [UnitMainAgencyID], [UnitGenID], 
		 [UnitTypeID], [GovtLevelID], [VettingBatchTypeID], [VettingActivityTypeID], [VettingPrefix], [ModifiedByAppUserID])
		VALUES
		(@UnitName, @UnitName, @UnitAcronym, 
		 @CountryID, @UnitParentID, @IsMainAgency, @UnitMainAgencyID, unitlibrary.NewUnitGenID(@IsMainAgency, @UnitMainAgencyID, @UnitAcronym), 
		 2, 2, 3, 4, NULL, 1);
		 

		/* DEA */
		SELECT @UnitMainAgencyID = UnitID, @UnitParentID = UnitID
		FROM unitlibrary.Units
		WHERE UnitAcronym = 'DOJ'
		
		SET @UnitName = 'Drug Enforcement Administration';
		SET @UnitAcronym = 'DEA';
		SET @IsMainAgency = 0;
		INSERT INTO unitlibrary.units
		([UnitName], [UnitNameEnglish], [UnitAcronym], 
		 [CountryID], [UnitParentID], [IsMainAgency], [UnitMainAgencyID], [UnitGenID], 
		 [UnitTypeID], [GovtLevelID], [VettingBatchTypeID], [VettingActivityTypeID], [VettingPrefix], [ModifiedByAppUserID])
		VALUES
		(@UnitName, @UnitName, @UnitAcronym, 
		 @CountryID, @UnitParentID, @IsMainAgency, @UnitMainAgencyID, unitlibrary.NewUnitGenID(@IsMainAgency, @UnitMainAgencyID, @UnitAcronym), 
		 2, 2, 3, 4, NULL, 1);



	END
GO
