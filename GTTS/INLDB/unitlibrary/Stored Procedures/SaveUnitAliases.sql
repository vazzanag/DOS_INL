CREATE PROCEDURE [unitlibrary].[SaveUnitAliases]
    @UnitID BIGINT,
    @ModifiedByAppUserID INT,
    @Aliases NVARCHAR(MAX)
AS
BEGIN

	SET NOCOUNT ON;

    DELETE FROM unitlibrary.UnitAliases
     WHERE UnitID = @UnitID
       AND UnitAliasID NOT IN (SELECT json.UnitAliasID FROM OPENJSON(@Aliases) WITH (UnitAliasID INT) json);

    INSERT INTO unitlibrary.UnitAliases
    (UnitID, UnitAlias, LanguageID, IsActive, IsDefault, ModifiedByAppUserID)
    SELECT @UnitID, json.UnitAlias, json.LanguageID, json.IsActive, json.IsDefault, @ModifiedByAppUserID
      FROM OPENJSON(@Aliases) WITH (UnitAliasID INT, UnitAlias NVARCHAR(256), LanguageID SMALLINT, IsActive BIT, IsDefault BIT) JSON
     WHERE NOT EXISTS(SELECT UnitAliasID FROM unitlibrary.UnitAliases WHERE UnitID = @UnitID and UnitAliasID = json.UnitAliasID);
	 
END
