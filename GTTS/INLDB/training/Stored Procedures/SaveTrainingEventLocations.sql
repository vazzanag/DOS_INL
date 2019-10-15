CREATE PROCEDURE [training].[SaveTrainingEventLocations]
    @TrainingEventID BIGINT,
    @ModifiedByAppUserID INT,
    @Locations NVARCHAR(MAX)
AS
BEGIN

	SET NOCOUNT ON;

    DELETE FROM training.TrainingEventLocations
     WHERE TrainingEventID = @TrainingEventID
       AND LocationID NOT IN (SELECT json.LocationID FROM OPENJSON(@Locations) WITH (LocationID INT) json);

    UPDATE training.TrainingEventLocations SET
           EventStartDate = json.EventStartDate,
           EventEndDate = json.EventEndDate,
		   TravelStartDate = json.TravelStartDate, 
		   TravelEndDate = json.TravelEndDate, 
           ModifiedByAppUserID = @ModifiedByAppUserID
      FROM OPENJSON(@Locations) 
           WITH (LocationID INT, EventStartDate DATE, EventEndDate DATE, TravelStartDate DATE, TravelEndDate DATE) AS json
     WHERE training.TrainingEventLocations.LocationID = json.LocationID 
       AND training.TrainingEventLocations.TrainingEventID = @TrainingEventID

    INSERT INTO training.TrainingEventLocations
    (TrainingEventID, LocationID, EventStartDate, EventEndDate, TravelStartDate, TravelEndDate, ModifiedByAppUserID)
    SELECT @TrainingEventID, json.LocationID, json.EventStartDate, json.EventEndDate, json.TravelStartDate, json.TravelEndDate, @ModifiedByAppUserID
      FROM OPENJSON(@Locations) 
           WITH (LocationID INT, EventStartDate DATE, EventEndDate DATE, TravelStartDate DATE, TravelEndDate DATE) JSON
     WHERE NOT EXISTS(SELECT LocationID FROM training.TrainingEventLocations WHERE TrainingEventID = @TrainingEventID and LocationID = json.LocationID);

END
