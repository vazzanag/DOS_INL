CREATE PROCEDURE [persons].[SavePersonLanguages]
    @PersonID BIGINT,
    @ModifiedByAppUserID INT,
    @Languages NVARCHAR(MAX)
AS
BEGIN

	SET NOCOUNT ON;

    DELETE FROM persons.PersonLanguages
     WHERE PersonID = @PersonID
       AND LanguageID NOT IN (SELECT json.LanguageID FROM OPENJSON(@Languages) WITH (LanguageID INT) json);

    INSERT INTO persons.PersonLanguages
    (PersonID, LanguageID, ModifiedByAppUserID)
    SELECT @PersonID, json.LanguageID, @ModifiedByAppUserID
      FROM OPENJSON(@Languages) 
           WITH (LanguageID INT) JSON
     WHERE NOT EXISTS(SELECT LanguageID FROM persons.PersonLanguages  WHERE PersonID = @PersonID and LanguageID = json.LanguageID);
	 
END