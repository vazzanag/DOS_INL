CREATE FUNCTION [vetting].[GenerateGTTSTrackingNumber]
(
    @TrainingEventID BIGINT,        
    @BatchNumber INT,
    @CountryID INT,
    @Year INT
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @TrackingNumber NVARCHAR(50), @CountryCode NVARCHAR(2);

    -- This is necessary in the case where the batch is being processed 
    -- in country different from training event
    SELECT @CountryCode = GENCCodeA2 FROM [location].Countries WHERE CountryID = @CountryID

    -- Tracking number: 2 digit country code | 4 digit year | batch number | trainer unit
    -- EX: MX2018-100 INL
    SELECT @TrackingNumber = @CountryCode + CAST(@Year AS NVARCHAR(10)) + '-' + CAST(@BatchNumber AS NVARCHAR(10)) + ' ' + b.Acronym
      FROM training.TrainingEvents  t 
INNER JOIN users.BusinessUnits      b ON t.TrainingUnitID = b.BusinessUnitID
     WHERE t.TrainingEventID = @TrainingEventID
  GROUP BY b.Acronym;

    RETURN @TrackingNumber
END
