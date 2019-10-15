CREATE PROCEDURE [vetting].[GetInvestBatchDetailByBatchID]
	@VettingBatchID BIGINT
AS
BEGIN
	SELECT VettingBatchID
			,PersonsVettingID
			,PersonID
			,FirstMiddleNames
			,LastNames
			,DOB
			,Gender
			,NationalID
			,POBCityName
			,POBStateName
			,POBCountryName
			,UnitName
			,UnitType
			,JobTitle
	  FROM [vetting].[InvestBatchDetailView] p
	 WHERE VettingBatchID = @VettingBatchID
END
