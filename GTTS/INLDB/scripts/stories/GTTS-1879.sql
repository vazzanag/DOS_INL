
BEGIN TRY

    DECLARE @SId INT;
    SET @SId = 0;
    IF (SELECT COUNT(*) FROM location.CitiesView WHERE CountryName = 'Unknown') = 0
	    BEGIN
            BEGIN TRANSACTION;
		    IF (SELECT COUNT(*) FROM location.States WHERE StateName = 'Unknown' AND CountryID = 99999) > 0
			    BEGIN
				    SET @SId = (SELECT TOP 1 StateID FROM location.States WHERE StateName = 'Unknown' AND CountryID = 99999);
				    IF (SELECT COUNT(*) FROM location.Cities WHERE StateID = @SId) = 0
					    BEGIN
						    INSERT INTO location.Cities (CityName, StateID, IsActive, ModifiedByAppUserID, ModifiedDate) 
											     VALUES ('Unknown', @SId, 1, 1, GETDATE());
					    END;
			    END;
		    ELSE
			    BEGIN
				    INSERT INTO location.States (StateName, StateCodeA2, Abbreviation, INKCode, CountryID, IsActive, ModifiedByAppUserID, ModifiedDate)
									     VALUES ('Unknown', 'UK', 'UNK', 'UNK-99999', 99999, 1, 1, GETDATE());
				    IF(@@ROWCOUNT) > 0
					    BEGIN
						    SET @SId = (SELECT TOP 1 StateID FROM location.States WHERE StateName = 'Unknown' AND CountryID = 99999);
						    INSERT INTO location.Cities (CityName, StateID, IsActive, ModifiedByAppUserID, ModifiedDate)
											     VALUES ('Unknown', @SId, 1, 1, GETDATE());
					    END;
			    END;

		    COMMIT
	    END;
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE()
	ROLLBACK
END CATCH