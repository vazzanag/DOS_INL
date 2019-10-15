CREATE PROCEDURE [vetting].[SavePersonsVettingStatus]
	@PersonsVettingID BIGINT,
	@VettingStatus NVARCHAR(25),
	@IsClear BIT,
	@IsDeny BIT,
	@ModifiedAppUserID INT
AS
BEGIN
	DECLARE @VettingStatusID INT
	IF EXISTS(SELECT * FROM vetting.PersonsVetting WHERE PersonsVettingID = @PersonsVettingID)
	BEGIN
		IF(@IsClear = 1 )
		BEGIN
			SELECT @VettingStatusID = VettingPersonStatusID FROM vetting.VettingPersonStatuses WHERE Code = 'APPROVED'
			UPDATE vetting.PersonsVetting SET AppUserIDCleared = @ModifiedAppUserID, ClearedDate = GETDATE(), DeniedDate = NULL, AppUserIDDenied = NULL, ModifiedByAppUserID = @ModifiedAppUserID
				WHERE PersonsVettingID = @PersonsVettingID
		END
		ELSE IF(@IsDeny = 1)
		BEGIN
			SELECT @VettingStatusID = VettingPersonStatusID FROM vetting.VettingPersonStatuses WHERE Code = 'REJECTED'
			UPDATE vetting.PersonsVetting SET AppUserIDDenied = @ModifiedAppUserID, DeniedDate = GETDATE(), ClearedDate = NULL, AppUserIDCleared = NULL,   ModifiedByAppUserID = @ModifiedAppUserID
				WHERE PersonsVettingID = @PersonsVettingID
		END
		ELSE
		BEGIN
			SELECT @VettingStatusID = VettingPersonStatusID FROM vetting.VettingPersonStatuses WHERE Code = @VettingStatus
		END
		UPDATE vetting.PersonsVetting SET VettingPersonStatusID = @VettingStatusID, VettingStatusDate = GETDATE(), ModifiedByAppUserID = @ModifiedAppUserID
			WHERE PersonsVettingID = @PersonsVettingID
	END
	ELSE
		RAISERROR(N'Person Vetting Not Found', 0, 0 )
	SELECT @PersonsVettingID
END		
