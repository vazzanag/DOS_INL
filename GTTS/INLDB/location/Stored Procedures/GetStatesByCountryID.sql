CREATE PROCEDURE [location].[GetStatesByCountryID]
    @CountryID int
AS
BEGIN   
    SELECT * FROM location.States WHERE CountryID = @CountryID
END
