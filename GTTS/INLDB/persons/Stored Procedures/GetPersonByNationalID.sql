CREATE PROCEDURE [persons].[GetPersonByNationalID]
	@NationalID NVARCHAR(100)
AS
BEGIN
	SELECT Top(1) s.FirstMiddleNames AS FirstMiddleNames, 
				  s.LastNames AS LastNames, 
				  s.Gender AS Gender, 
				  s.DOB AS DOB, 
				  st.StateName AS POBStateName, 
				  c.CountryName AS POBCountryName, 
				  s.PersonID AS PersonID, 
				  LastVettingTypeCode, 
				  LastVettingStatusDate, 
				  LastVettingStatusCode, 
				  v.JobTitle AS JobTitle, 
				  [Rank]
		   FROM [training].[ParticipantsXLSX] p INNER JOIN [persons].[PersonsView] s ON p.NationalID = s.NationalID
												 LEFT JOIN [vetting].[PersonsVettingView] v on p.PersonID = v.PersonID
												 LEFT JOIN [location].States ST ON s.POBStateID = st.StateID AND p.POBState = st.StateName
												 LEFT JOIN [location].Countries c ON st.CountryID = c.CountryID
		  WHERE p.NationalID = @NationalID
END