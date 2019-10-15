CREATE PROCEDURE [vetting].[GetCourtesyBatchPersons]
	@CourtesyBatchID BIGINT
AS
BEGIN

	SELECT
		PersonsVettingID,
		VettingBatchID,
		CourtesyBatchID,
		VettingTypeID,
		VettingType,
		CourtesyVettingSkipped,
		CourtesyVettingSkippedComments,
		VettingPersonStatusID,
		VettingPersonStatus,
		VettingStatusDate, 
		VettingNotes,
		ClearedDate,
		ClearedByAppUserID,
		ClearedByAppUserName,
		DeniedDate,
		DeniedByAppUserID,
		DeniedByAppUserName,
		FirstMiddleNames,
		LastNames,
		Gender,
		IsUSCitizen,
		NationalID,
		DOB,
		POBCityID,
		POBCity,
		POBStateID,
		POBState,
		POBCountryID,
		POBCountry,
		PersonsUnitLibraryInfoID,
		JobTitle,
		RankID,
		RankName,
		UnitID, 
		UnitName, 
		UnitNameEnglish,
		UnitGenID,
		UnitMainAgencyID,
		UnitMainAgency,
		UnitBreakdown,
		UnitBreakdownLocalLang
	FROM vetting.CourtesyBatchPersonsView
	WHERE CourtesyBatchID = @CourtesyBatchID

END