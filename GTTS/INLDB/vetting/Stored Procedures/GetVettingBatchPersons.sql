CREATE PROCEDURE [vetting].[GetVettingBatchPersons]
	@VettingBatchID BIGINT
AS
BEGIN

	SELECT
		PersonsVettingID,
		VettingBatchID,
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
	FROM vetting.VettingBatchPersonsView
	WHERE VettingBatchID = @VettingBatchID

END