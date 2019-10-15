CREATE PROCEDURE [unitlibrary].[UpdateUnitActiveFlag]
    @UnitID BIGINT,
    @IsActive BIT
AS
BEGIN

    UPDATE unitlibrary.Units SET
           IsActive = @IsActive
     WHERE UnitID = @UnitID;

     SELECT @UnitID;

END
