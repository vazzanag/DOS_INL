CREATE VIEW [vetting].[InvestBatchDetailView]
	AS 
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
	  FROM [vetting].PersonsVettingView
