CREATE PROCEDURE unitlibrary.SaveUnit
    @UnitID BIGINT = NULL,
    @UnitParentID BIGINT = NULL,       
    @CountryID INT, 
    @UnitLocationID BIGINT,     
    @ConsularDistrictID INT= NULL,      
    @UnitName NVARCHAR(300),    
    @UnitNameEnglish NVARCHAR(300),    
    @IsMainAgency BIT,    
    @UnitMainAgencyID BIGINT= NULL,      
    @UnitAcronym NVARCHAR(50)= NULL, 
    @UnitGenID NVARCHAR(50),    
    @UnitTypeID SMALLINT,       
    @GovtLevelID SMALLINT= NULL,             
    @UnitLevelID SMALLINT= NULL,              
    @VettingBatchTypeID TINYINT,      
    @VettingActivityTypeID SMALLINT,  
    @ReportingTypeID SMALLINT,       
    @UnitHeadPersonID BIGINT= NULL,        
    @UnitHeadJobTitle NVARCHAR(100)= NULL,              
    @UnitHeadRankID INT= NULL,   
	@UnitHeadRank NVARCHAR(100) = NULL,
	@UnitHeadFirstMiddleNames NVARCHAR(150) = NULL,
	@UnitHeadLastNames NVARCHAR(150) = NULL,
	@UnitHeadIDNumber VARCHAR(50) = NULL,
	@UnitHeadGender CHAR(1) = NULL,
	@UnitHeadDOB DATETIME = NULL,
	@UnitHeadPoliceMilSecID NVARCHAR(50) = NULL,
	@UnitHeadPOBCityID INT = NULL, 
	@UnitHeadResidenceCityID INT = NULL,
	@UnitHeadContactEmail NVARCHAR(256) = NULL,
	@UnitHeadContactPhone NVARCHAR(50) = NULL,
	@UnitHeadHighestEducationID SMALLINT = NULL,
	@UnitHeadEnglishLanguageProficiencyID SMALLINT = NULL,
    @HQLocationID BIGINT,             
    @POCName NVARCHAR(200)= NULL,
    @POCEmailAddress NVARCHAR(256)= NULL,
    @POCTelephone NVARCHAR(50)= NULL,	
    @VettingPrefix NVARCHAR(25)= NULL,      
    @HasDutyToInform BIT = 0,            
    @IsLocked BIT = 0,     
    @IsActive BIT = 1,
    @UnitAliases NVARCHAR(MAX) = NULL,
    @ModifiedByAppUserID INT,
    @ModifiedDate DATETIME
AS
BEGIN
    DECLARE @Identity BIGINT;

    BEGIN TRY
        BEGIN TRANSACTION

        -- DETERMINE IF INSERT OR UPDATE BASED ON PASSED @UniID VALUE
        IF (@UnitID IS NULL OR @UNITID = -1) 
            BEGIN
                -- ISNERT NEW RECORD
                INSERT INTO unitlibrary.Units
                (
                    UnitParentID, CountryID, UnitLocationID, ConsularDistrictID, UnitName, UnitNameEnglish, IsMainAgency, UnitMainAgencyID,
                    UnitAcronym, UnitGenID, UnitTypeID, GovtLevelID, UnitLevelID, VettingBatchTypeID, VettingActivityTypeID,
                    ReportingTypeID, UnitHeadPersonID, UnitHeadJobTitle, UnitHeadRankID,
					[UnitHeadRank],
					[UnitHeadFirstMiddleNames],
					[UnitHeadLastNames],
					[UnitHeadIDNumber],
					[UnitHeadGender],
					[UnitHeadDOB],
					[UnitHeadPoliceMilSecID],
					[UnitHeadPOBCityID], 
					[UnitHeadResidenceCityID],
					[UnitHeadContactEmail],
					[UnitHeadContactPhone],
					[UnitHeadHighestEducationID],
					[UnitHeadEnglishLanguageProficiencyID],
					HQLocationID, POCName, POCEmailAddress, POCTelephone,
                    VettingPrefix, HasDutyToInform, IsLocked, IsActive, ModifiedByAppUserID
                )
                VALUES
                (
                    @UnitParentID, @CountryID, @UnitLocationID, @ConsularDistrictID, @UnitName, @UnitNameEnglish, @IsMainAgency, ISNULL(@UnitMainAgencyID, @UnitParentID),
                    @UnitAcronym, @UnitGenID, @UnitTypeID, @GovtLevelID, @UnitLevelID, @VettingBatchTypeID, @VettingActivityTypeID,
                    @ReportingTypeID, @UnitHeadPersonID, @UnitHeadJobTitle, @UnitHeadRankID,
					@UnitHeadRank,
					@UnitHeadFirstMiddleNames,
					@UnitHeadLastNames,
					@UnitHeadIDNumber,
					@UnitHeadGender,
					@UnitHeadDOB,
					@UnitHeadPoliceMilSecID,
					@UnitHeadPOBCityID, 
					@UnitHeadResidenceCityID,
					@UnitHeadContactEmail,
					@UnitHeadContactPhone,
					@UnitHeadHighestEducationID,
					@UnitHeadEnglishLanguageProficiencyID,
					@HQLocationID, @POCName, @POCEmailAddress, @POCTelephone,
                    @VettingPrefix, @HasDutyToInform, @IsLocked, @IsActive, @ModifiedByAppUserID
                );

                SET @Identity = SCOPE_IDENTITY();
				IF(@UnitMainAgencyID IS NULL OR @UnitMainAgencyID = 0)
				BEGIN
					UPDATE unitlibrary.Units SET UnitMainAgencyID = @Identity WHERE UnitID = @Identity
				END

                UPDATE unitlibrary.Units SET
		               UnitBreakdown = unitlibrary.UnitBreakdownLocalLang(UnitID, 0, 50, 0, -1),
		               UnitBreakdownEnglish = unitlibrary.UnitBreakdown(UnitID, 0, 50, 0, -1),
		               ChildUnits = unitlibrary.ChildUnits(UnitID, 0, 50, 0),
		               ChildUnitsEnglish = unitlibrary.ChildUnits(UnitID, 0, 50, 1)
                 WHERE UnitID = @Identity;
            END
        ELSE
            BEGIN
                -- THROW ERROR IF REQUESTED UNIT DOES NOT EXIST
                IF NOT EXISTS(SELECT UnitID FROM unitlibrary.Units WHERE UnitID = @UnitID)
                    THROW 50000,  'The requested unit to be updated does not exist.',  1

                DECLARE @NameDif BIT;
                IF EXISTS(SELECT UnitID FROM unitlibrary.Units WHERE UnitID = @UnitID AND UnitName = @UnitName AND UnitNameEnglish = @UnitNameEnglish)
                    SET @NameDif = 0;
                ELSE
                    SET @NameDif = 1;

                -- UPDATE EXISTING RECORD
                UPDATE unitlibrary.Units SET
                        UnitParentID = @UnitParentID, 
                        CountryID = @CountryID, 
                        UnitLocationID = @UnitLocationID, 
                        ConsularDistrictID = @ConsularDistrictID, 
                        UnitName = @UnitName, 
                        UnitNameEnglish = @UnitNameEnglish, 
                        IsMainAgency = @IsMainAgency, 
                        UnitMainAgencyID = @UnitMainAgencyID,
                        UnitAcronym = @UnitAcronym, 
                        UnitGenID = @UnitGenID, 
                        UnitTypeID = @UnitTypeID, 
                        GovtLevelID = @GovtLevelID, 
                        UnitLevelID = @UnitLevelID, 
                        VettingBatchTypeID = @VettingBatchTypeID, 
                        VettingActivityTypeID = @VettingActivityTypeID,
                        ReportingTypeID = @ReportingTypeID, 
                        UnitHeadPersonID = @UnitHeadPersonID, 
                        UnitHeadJobTitle = @UnitHeadJobTitle, 
                        UnitHeadRankID = @UnitHeadRankID, 
						UnitHeadRank = @UnitHeadRank,
						UnitHeadFirstMiddleNames = @UnitHeadFirstMiddleNames,
						UnitHeadLastNames = @UnitHeadLastNames,
						UnitHeadIDNumber = @UnitHeadIDNumber,
						UnitHeadGender = @UnitHeadGender,
						UnitHeadDOB = @UnitHeadDOB,
						UnitHeadPoliceMilSecID = @UnitHeadPoliceMilSecID,
						UnitHeadPOBCityID = @UnitHeadPOBCityID, 
						UnitHeadResidenceCityID = @UnitHeadResidenceCityID,
						UnitHeadContactEmail = @UnitHeadContactEmail,
						UnitHeadContactPhone = @UnitHeadContactPhone,
						UnitHeadHighestEducationID = @UnitHeadHighestEducationID,
						UnitHeadEnglishLanguageProficiencyID = @UnitHeadEnglishLanguageProficiencyID,
                        HQLocationID = @HQLocationID, 
                        POCName = @POCName, 
                        POCEmailAddress = @POCEmailAddress, 
                        POCTelephone = @POCTelephone,
                        VettingPrefix = @VettingPrefix, 
                        HasDutyToInform = @HasDutyToInform, 
                        IsLocked = @IsLocked,
                        IsActive = @IsActive,
                        ModifiedByAppUserID = @ModifiedByAppUserID,
                        ModifiedDate = GETUTCDATE()
                WHERE UnitID = @UnitID;

                SET @Identity = @UnitID

                -- IF UnitName OR UnitNameEnglish HAS CHANGED UPDATE 
                -- PARENT AND CHILD UNITS' UnitBreakdown AND CHildUnits VALUES
                IF (@NameDif = 1)
                BEGIN
                    EXEC unitlibrary.UpdateParentBreakdownAndChildUnits @Identity;
                    EXEC unitlibrary.UpdateChildBreakdownAndChildUnits @Identity;
                END
            END

        -- SAVE Unit Aliases
        IF (@UnitAliases IS NOT NULL)
            EXEC unitlibrary.SaveUnitAliases @Identity, @ModifiedByAppUserID, @UnitAliases

        -- NO ERRORS,  COMMIT
        COMMIT;

        -- RETURN IDENITY
        SELECT @Identity;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;