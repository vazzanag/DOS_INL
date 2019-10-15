CREATE PROCEDURE [vetting].[SavePersonVettingVettingType]
	@PersonVettingID bigint,
	@VettingTypeID smallint,
	@CourtesySkippedFlag bit,
	@CourtesySkippedComments nVARCHAR(MAX),
	@ModifiedAppUserID INT
AS
BEGIN
	IF EXISTS(SELECT * FROM [vetting].[PersonsVettingVettingTypes] WHERE PersonsVettingID = @PersonVettingID and VettingTypeID = @VettingTypeID)
	BEGIN
		UPDATE [vetting].[PersonsVettingVettingTypes]
			SET CourtesyVettingSkipped = @CourtesySkippedFlag,
				CourtesyVettingSkippedComments = @CourtesySkippedComments,
				ModifiedByAppUserID = @ModifiedAppUserID
			WHERE PersonsVettingID = @PersonVettingID and VettingTypeID = @VettingTypeID
	END
	ELSE
	BEGIN
		INSERT INTO [vetting].[PersonsVettingVettingTypes](
			PersonsVettingID, VettingTypeID, CourtesyVettingSkipped, CourtesyVettingSkippedComments, ModifiedByAppUserID)
			VALUES(@PersonVettingID, @VettingTypeID, @CourtesySkippedFlag, @CourtesySkippedComments, @ModifiedAppUserID)
	END
END
