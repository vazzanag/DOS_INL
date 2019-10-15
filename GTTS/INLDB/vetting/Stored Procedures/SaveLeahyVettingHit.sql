CREATE PROCEDURE [vetting].[SaveLeahyVettingHit]
	@LeahyVettingHitID BIGINT,
    @PersonsVettingID BIGINT,
    @CaseID NVARCHAR(25),     
    @LeahyHitResultID TINYINT,   
    @LeahyHitAppliesToID TINYINT, 
    @ViolationTypeID TINYINT,    
    @CertDate DATETIME,
    @ExpiresDate DATETIME,    
    @Summary NVARCHAR(MAX),
	@ModifiedByAppUserID BIGINT
AS
BEGIN
	DECLARE @Identity BIGINT, @VettingPersonStatusID INT, @LeahyResultCode NVARCHAR(25)
	IF (ISNULL(@LeahyVettingHitID,0) = 0)
	BEGIN
		INSERT INTO vetting.LeahyVettingHits(
			PersonsVettingID, CaseID, LeahyHitResultID, LeahyHitAppliesToID, ViolationTypeID, CertDate, ExpiresDate, Summary, ModifiedByAppUserID
			)
		VALUES
			(@PersonsVettingID, @CaseID, @LeahyHitResultID, @LeahyHitAppliesToID, @ViolationTypeID, @CertDate, @ExpiresDate, @Summary, @ModifiedByAppUserID);

		SET @Identity = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		UPDATE vetting.LeahyVettingHits
		SET
			PersonsVettingID = @PersonsVettingID,
			CaseID = @CaseID,
			LeahyHitResultID = @LeahyHitResultID,
			LeahyHitAppliesToID = @LeahyHitAppliesToID,
			ViolationTypeID = @ViolationTypeID,
			CertDate = @CertDate,
			ExpiresDate = @ExpiresDate,
			Summary = @Summary,
			ModifiedByAppUserID = @ModifiedByAppUserID,
			ModifiedDate = GETUTCDATE()
		WHERE LeahyVettingHitID = @LeahyVettingHitID;

			
		SET @Identity = @LeahyVettingHitID
	END
	SELECT @Identity;
END
