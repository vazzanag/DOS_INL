CREATE PROCEDURE [vetting].[UpdatePersonVetting]
	@PersonVettingID BIGINT,
	@PersonUnitLibraryInofID BIGINT,
	@ModifiedAppUserID INT
AS
BEGIN
	IF EXISTS( SELECT * FROM vetting.PersonsVetting WHERE PersonsVettingID = @PersonVettingID)
	BEGIN
		UPDATE vetting.PersonsVetting SET PersonsUnitLibraryInfoID = @PersonUnitLibraryInofID, ModifiedByAppUserID = @ModifiedAppUserID WHERE PersonsVettingID = @PersonVettingID
	END
	ELSE
	BEGIN
		RAISERROR(N'Person Vetting Not Found', 0, 0 ) 
	END
	SELECT @PersonVettingID
END