CREATE PROCEDURE [training].[GetTrainingEventLocations]
    @TrainingEventID BIGINT
AS
BEGIN
    SELECT TrainingEventLocationID, TrainingEventID, LocationID, EventStartDate, EventEndDate, TravelStartDate, TravelEndDate,  
	       ModifiedByAppUserID, ModifiedDate 
           LocationJSON,  ModifiedByUserJSON,
		   LocationName, AddressLine1, AddressLine2, AddressLine3, 
		   CityID, CityName, 
		   StateID, StateName, StateCodeA2, StateAbbreviation, StateINKCode, 
		   CountryID, CountryName, GENCCodeA2, CountryAbbreviation, CountryINKCode           
	  FROM training.TrainingEventLocationsView
	 WHERE TrainingEventID = @TrainingEventID;
END;