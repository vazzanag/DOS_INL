CREATE PROCEDURE [persons].[SavePersonsUnitLibraryInfo]
    @PersonsUnitLibraryInfoID BIGINT = null,
    @PersonID BIGINT,
    @UnitID BIGINT,
    @JobTitle NVARCHAR(100) = NULL,
    @YearsInPosition INT = NULL,
    @WorkEmailAddress NVARCHAR(256) = NULL,
    @RankID INT = NULL,
    @IsUnitCommander BIT = 0,
	@PoliceMilSecID NVARCHAR(100) = NULL,
    @HostNationPOCName NVARCHAR(256) = NULL,
    @HostNationPOCEmail NVARCHAR(256) = NULL,
    @IsVettingReq BIT = 0,
    @IsLeahyVettingReq BIT = 0,
    @IsArmedForces BIT = 0,
    @IsLawEnforcement BIT = 0,
    @IsSecurityIntelligence BIT = 0,
    @IsValidated BIT = 0,
    @ModifiedByAppUserID INT
AS
BEGIN
    DECLARE @Identity BIGINT
	BEGIN TRY
		BEGIN TRANSACTION
			IF NOT EXISTS(SELECT 1 FROM persons.PersonsUnitLibraryInfo WHERE PersonID = @PersonID AND UnitID = @UnitID)
			BEGIN

				-- INSERT NEW RECORD
				INSERT INTO persons.PersonsUnitLibraryInfo(
				PersonID, UnitID, JobTitle, YearsInPosition, WorkEmailAddress, RankID, IsUnitCommander, PoliceMilSecID, 
				IsVettingReq, IsLeahyVettingReq, IsArmedForces, IsLawEnforcement, IsSecurityIntelligence, HostNationPOCName, 
                HostNationPOCEmail, IsValidated, IsActive, ModifiedByAppUserID
				)
				VALUES
				(
					@PersonID, @UnitID, @JobTitle, @YearsInPosition, @WorkEmailAddress, @RankID, @IsUnitCommander, @PoliceMilSecID, 
					@IsVettingReq, @IsLeahyVettingReq, @IsArmedForces, @IsLawEnforcement, @IsSecurityIntelligence, @HostNationPOCName,
                    @HostNationPOCEmail, @IsValidated, 1, @ModifiedByAppUserID
				)
				SET @Identity = SCOPE_IDENTITY();
			END
			ELSE
			BEGIN

				-- UPDATE EXISTING RECORD
				UPDATE persons.PersonsUnitLibraryInfo SET
				  JobTitle = @JobTitle,
				  YearsInPosition = @YearsInPosition,
				  WorkEmailAddress = @WorkEmailAddress,
				  RankID = @RankID,
				  IsUnitCommander = @IsUnitCommander,
				  PoliceMilSecID = @PoliceMilSecID,
                  HostNationPOCName = @HostNationPOCName,
                  HostNationPOCEmail = @HostNationPOCEmail,
				  IsVettingReq = ISNULL(@IsVettingReq, IsVettingReq),
				  IsLeahyVettingReq = ISNULL(@IsLeahyVettingReq, IsLeahyVettingReq),
				  IsArmedForces = ISNULL(@IsArmedForces, IsArmedForces),
				  IsLawEnforcement = ISNULL(@IsLawEnforcement, IsLawEnforcement),
				  IsSecurityIntelligence = ISNULL(@IsSecurityIntelligence, IsSecurityIntelligence),
				  IsValidated = ISNULL(@IsValidated, IsValidated),
				  IsActive = 1,
				  ModifiedByAppUserID = @ModifiedByAppUserID,
				  ModifiedDate = GETUTCDATE()
				WHERE PersonID = @PersonID AND UnitID = @UnitID

				-- GET IDENTITY FOR RETURN
				SELECT @Identity = PersonsUnitLibraryInfoID 
				  FROM persons.PersonsUnitLibraryInfo
				WHERE PersonID = @PersonID AND UnitID = @UnitID  
		END

		-- UPDATE OLD RECORDS FOR THE PERSON INACTIVE
		UPDATE persons.PersonsUnitLibraryInfo SET IsActive = 0 WHERE PersonID = @PersonID AND PersonsUnitLibraryInfoID <> @Identity

		-- NO ERRORS,  COMMIT
        COMMIT;

        -- RETURN the Identity
        SELECT @Identity;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END