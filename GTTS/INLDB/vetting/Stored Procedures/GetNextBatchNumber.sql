CREATE FUNCTION [vetting].[GetNextBatchNumber]
(
    @CountryID INT,
    @Year INT
)
RETURNS INT
AS
BEGIN
    DECLARE @BatchNumber INT

    SELECT @BatchNumber = ISNULL(MAX(v.VettingBatchNumber), 0) + 1
      FROM vetting.VettingBatches   v
	 WHERE v.CountryID = @CountryID
       AND YEAR(v.DateSubmitted) = @Year

    RETURN @BatchNumber
END
