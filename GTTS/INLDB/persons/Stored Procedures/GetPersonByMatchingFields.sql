CREATE PROCEDURE [persons].[GetPersonByMatchingFields]
	@FirstMiddleNames NVARCHAR(50),
	@LastNames NVARCHAR(50),
	@DOB DATETIME,
	@POBState NVARCHAR(50), 
	@Gender CHAR(1)
AS
BEGIN
	SELECT PersonID,  
		FirstMiddleNames,
		LastNames,
		DOB,
		POBCityID,
		s.StateName AS POBStateName,
		c.CountryName AS POBCountryName,
		Gender,
		NationalID
		FROM [persons].PersonsView p
		LEFT JOIN [location].States s ON p.POBStateID = s.StateID
		LEFT JOIN [location].Countries c ON s.CountryID = s.CountryID
		WHERE UPPER(FirstMiddleNames) = UPPER(@FirstMiddleNames) AND 
		UPPER(LastNames) = UPPER(@LastNames) AND 
		CAST(DOB AS DATE) = CAST(@DOB AS DATE) AND 
		UPPER(ISNULL(p.POBStateName, '')) = UPPER(ISNULL(@POBState, '')) AND
		Gender = @Gender 
END
