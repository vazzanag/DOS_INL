CREATE PROCEDURE [users].[SaveAppUserBusinessUnits]
	@AppUserID INT,
	@DefaultBusinessUnitID INT,
	@ModifiedByAppUserID INT,
	@BusinessUnits NVARCHAR(MAX)
AS
BEGIN

	SET NOCOUNT ON;

    DELETE FROM users.AppUserBusinessUnits
     WHERE AppUserID = @AppUserID
       AND BusinessUnitID NOT IN (SELECT json.BusinessUnitID FROM OPENJSON(@BusinessUnits) WITH (BusinessUnitID INT) json);
	   
	   
    UPDATE users.AppUserBusinessUnits
	SET    BusinessUnitID = json.BusinessUnitID,
           ModifiedByAppUserID = @ModifiedByAppUserID
      FROM OPENJSON(@BusinessUnits) 
           WITH (BusinessUnitID INT) json
     WHERE users.AppUserBusinessUnits.BusinessUnitID = json.BusinessUnitID 
       AND users.AppUserBusinessUnits.AppUserID = AppUserID


    INSERT INTO users.AppUserBusinessUnits
		(AppUserID, BusinessUnitID, DefaultBusinessUnit, ModifiedByAppUserID)
    SELECT @AppUserID, json.BusinessUnitID, json.DefaultBusinessUnit, @ModifiedByAppUserID
      FROM OPENJSON(@BusinessUnits) 
           WITH (BusinessUnitID INT, DefaultBusinessUnit BIT) json
     WHERE NOT EXISTS(SELECT AppUserID FROM users.AppUserBusinessUnits WHERE AppUserID = @AppUserID and BusinessUnitID = json.BusinessUnitID);


	UPDATE users.AppUserBusinessUnits
	SET DefaultBusinessUnit = 1
	WHERE AppUserID = @AppUserID
	AND BusinessUnitID = @DefaultBusinessUnitID;
	
	UPDATE users.AppUserBusinessUnits
	SET DefaultBusinessUnit = 0
	WHERE AppUserID = @AppUserID
	AND BusinessUnitID != @DefaultBusinessUnitID;


END

