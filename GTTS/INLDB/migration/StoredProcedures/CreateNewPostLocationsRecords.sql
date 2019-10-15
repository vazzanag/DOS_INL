/*
    NAME:   CreateNewPostLocationsRecords
    
    DESCR:  This Stored Procedure receives 1 parameter and then inserts the 
            data from the [ImportLocations] table into a new record in the 
            [NewPostLocations] table.
*/
CREATE PROCEDURE [migration].[CreateNewPostLocationsRecords]
    @NewPostImportID BIGINT = NULL	-- ID value that points to the [NewPostImportLog] 
									-- record that this Run Control Log message refers to.
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

            -- INSERT NEW RECORD
            INSERT INTO [migration].[NewPostLocations]
            (   [NewPostImportID],
                [EventCity],
                [EventState],
                [EventCountry],
                [EventStartDate],
                [EventEndDate],
                [TravelStartDate],
                [TravelEndDate],
                [ImportStatus],
                [ModifiedByAppUserID]
            )
            SELECT 
				imp.ImportID,			-- @NewPostImportID,
                imp.[EventCity],
                imp.[EventState],
                imp.[EventCountry],
                imp.[EventStartDate],
                imp.[EventEndDate],
                imp.[TravelStartDate],
                imp.[TravelEndDate],
                'Uploaded',
                2
            FROM [migration].[ImportLocations] imp;

        -- NO ERRORS, COMMIT
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
 END;