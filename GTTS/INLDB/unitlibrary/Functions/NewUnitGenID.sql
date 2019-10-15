CREATE FUNCTION [unitlibrary].[NewUnitGenID]
(
	@IsMainAgency BIT,
	@UnitMainAgencyID BIGINT,
	@UnitAcronym NVARCHAR(50)
)
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE @UnitGenID NVARCHAR(50) = NULL;
	
	IF (@IsMainAgency = 0 AND @UnitMainAgencyID IS NULL) 
		RETURN 'ERROR01';
		
	IF (@IsMainAgency = 1 AND (@UnitAcronym IS NULL OR @UnitAcronym = '')) 
		RETURN 'ERROR02';

	IF (@IsMainAgency = 1)
		SET @UnitGenID = @UnitAcronym + '00001';
	ELSE
	BEGIN
		SELECT @UnitAcronym = UnitAcronym
		FROM unitlibrary.Units
		WHERE UnitID = @UnitMainAgencyID;
		
		DECLARE @UnitGenIDNumeric INT = NULL;
		SELECT @UnitGenIDNumeric = COUNT(UnitID)
		FROM unitlibrary.Units
		WHERE UnitID = @UnitMainAgencyID;
		
		IF (@UnitGenIDNumeric IS NULL)
			SET @UnitGenIDNumeric = 0;

		WHILE (@UnitGenID IS NULL OR EXISTS (SELECT UnitGenID FROM unitlibrary.Units WHERE UnitGenID = @UnitGenID))
		BEGIN
			SET @UnitGenIDNumeric = @UnitGenIDNumeric + 1;
			SET @UnitGenID = @UnitAcronym + RIGHT('00000' + CAST(@UnitGenIDNumeric AS VARCHAR(10)), 5);
		END

	END;

	RETURN @UnitGenID;

END
