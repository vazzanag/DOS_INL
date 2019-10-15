CREATE PROCEDURE [vetting].[SaveVettingHit]
	@VettingHitID int = 0,
	@PersonsVettingID int,
	@VettingTypeID int,
	@FirstMiddleNames NVARCHAR(150),
	@LastNames NVARCHAR(150),
	@DOBMonth TINYINT,
	@DOBDay TINYINT,
	@DOBYear SMALLINT,
	@PlaceOfBirth NVARCHAR(300),
	@ReferenceSiteID INT,
	@HitMonth TINYINT,
	@HitDay TINYINT,
	@HitYear SMALLINT,
	@TrackingID NVARCHAR(100) NULL,
	@HitUnit VARCHAR(200) NULL,
	@HitLocation NVARCHAR(300) NULL,
	@ViolationTypeID TINYINT NULL,
	@CredibilityLevelID TINYINT NULL,
	@HitDetails NVARCHAR(max) NULL,
	@Notes NVARCHAR(max) NULL,
	@IsRemoved BIT NULL,
	@HitResultID TINYINT,
	@HitResultDetails NVARCHAR(MAX),
	@ModifiedByAppUserID INT
AS
BEGIN
    BEGIN TRANSACTION

	BEGIN TRY
		IF (ISNULL(@VettingHitID, 0) = 0)
		BEGIN

			--insert if hitresultid <> 1 OR other values are not null
			IF(ISNULL(@HitResultID,0) <> 1 OR (ISNULL(@FirstMiddleNames,'') <> '' OR ISNULL(@LastNames,'') <> '' OR @DOBMonth IS NOT NULL OR @DOBDay IS NOT NULL OR @DOBYear IS NOT NULL
												OR ISNULL(@PlaceOfBirth,'') <> '' OR @ReferenceSiteID IS NOT NULL OR @HitMonth IS NOT NULL OR @HitDay IS NOT NULL OR @HitYear IS NOT NULL 
												OR ISNULL(@TrackingID,'') <> '' OR ISNULL(@HitUnit,'') <> ''  OR ISNULL(@HitLocation,'') <> ''  OR  @ViolationTypeID IS NOT NULL
												OR @CredibilityLevelID IS NOT NULL OR  ISNULL(@HitDetails,'') <> ''  OR  ISNULL(@Notes,'') <> '' ))
			BEGIN
				INSERT INTO vetting.VettingHits
				(
					PersonsVettingID, VettingTypeID, FirstMiddleNames, LastNames, DOBMonth, DOBDay, DOBYear, PlaceOfBirth, ReferenceSiteID, HitMonth, 
					HitDay, HitYear, TrackingID, HitUnit, HitLocation, ViolationTypeID, CredibilityLevelID, HitDetails, Notes, VettingHitDate, VettingHitAppUserID, 
					ModifiedByAppUserID
				)
				VALUES
				(
					@PersonsVettingID, @VettingTypeID, @FirstMiddleNames, @LastNames, @DOBMonth, @DOBDay, @DOBYear, @PlaceOfBirth, @ReferenceSiteID, @HitMonth, @HitDay, @HitYear, @TrackingID, @HitUnit,
					@HitLocation, @ViolationTypeID, @CredibilityLevelID, @HitDetails, @Notes, GETDATE(), @ModifiedByAppUserID, @ModifiedByAppUserID
				);

				SET @VettingHitID = SCOPE_IDENTITY();
			END
			ELSE 
			BEGIN
				SET @VettingHitID = 0;
			END
		END
		ELSE
		BEGIN
			IF (ISNULL(@IsRemoved, 0) > 0)
			BEGIN
				UPDATE vetting.VettingHits 
				SET    IsRemoved = @IsRemoved,
					   ModifiedByAppUserID = @ModifiedByAppUserID
				WHERE  VettingHitID = @VettingHitID;
			END
			ELSE
			BEGIN
				UPDATE vetting.VettingHits
				SET FirstMiddleNames = @FirstMiddleNames,
					LastNames = @LastNames,
					DOBYear = @DOBYear,
					DOBMonth =  @DOBMonth,
					DOBDay = @DOBDay,
					PlaceOfBirth = @PlaceOfBirth,
					ReferenceSiteID = @ReferenceSiteID,
					HitMonth = @HitMonth,
					HitDay = @HitDay,
					HitYear = @HitYear,
					TrackingID = @TrackingID,
					HitUnit = @HitUnit,
					HitLocation = @HitLocation,
					ViolationTypeID = @ViolationTypeID,
					CredibilityLevelID = @CredibilityLevelID,
					HitDetails = @HitDetails,
					Notes = @Notes,
					ModifiedByAppUserID = @ModifiedByAppUserID
				WHERE VettingHitID = @VettingHitID;
			END
		END

		IF (NOT EXISTS(SELECT * FROM vetting.PersonsVettingVettingTypes WHERE PersonsVettingID = @PersonsVettingID AND VettingTypeID = @VettingTypeID))
		BEGIN
			INSERT INTO [vetting].[PersonsVettingVettingTypes]
				(PersonsVettingID, VettingTypeID, ModifiedByAppUserID)
			VALUES
				(@PersonsVettingID, @VettingTypeID, @ModifiedByAppUserID);
		END

		IF (ISNULL(@HitResultID, 0) > 0 OR @HitResultDetails <> '')
		BEGIN
			UPDATE	vetting.PersonsVettingVettingTypes 
			SET		HitResultID = @HitResultID, 
					HitResultDetails = @HitResultDetails 
			WHERE	PersonsVettingID = @PersonsVettingID 
			AND		VettingTypeID = @VettingTypeID
		END

		COMMIT;

		SELECT @VettingHitID AS VettingHitID;
	END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
