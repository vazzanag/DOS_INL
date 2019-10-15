CREATE PROCEDURE [unitlibrary].[UpdateUnitParent]
	@UnitID BIGINT,
	@UnitParentID BIGINT 
AS
BEGIN
    DECLARE @Identity BIGINT;

    BEGIN TRANSACTION
	BEGIN TRY
        
		UPDATE unitlibrary.Units SET
				UnitParentID = @UnitParentID
		 WHERE UnitID = @UnitID;

         SET @Identity = @UnitID

		 -- NO ERRORS,  COMMIT
        COMMIT;

        -- RETURN IDENITY
        SELECT @Identity;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END