/*
    NAME:   WriteToImportPackageRunControlLog
    
    DESCR:  This Stored Procedure receives 2 parameters and then inserts a new
			record into the [ImportPackageRunControlLog] table.
*/
CREATE PROCEDURE [migration].[WriteToImportPackageRunControlLog]
    @NewPostImportID BIGINT = NULL,	-- ID value that points to the [NewPostImportLog] 
									-- record that this Run Control Log message refers to.
	@Message VARCHAR(500) = NULL	-- Message text being written to the new 
									-- [ImportPackageRunControlLog] log record.
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

            -- INSERT NEW RECORD
            INSERT INTO [migration].[ImportPackageRunControlLog]
            (
                [NewPostImportID], [Message], [ModifiedByAppUserID]
           )
            VALUES
           (
               @NewPostImportID, @Message, 2
           );

        -- NO ERRORS, COMMIT
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
 END;