CREATE PROCEDURE [unitlibrary].[CheckForDuplicateUnit]
	@UnitNameLocalLanguage  NVARCHAR(300),
	@UnitNameEnglish NVARCHAR(300),
	@ParentID BIGINT = NULL,
	@CountryID INT = NULL,
	@UnitGenID NVARCHAR(50)
AS
BEGIN
	SELECT *			
	FROM unitlibrary.UnitsView 
	WHERE
		(
			(
				dbo.StripPunctionsFromString(UnitName) = dbo.StripPunctionsFromString(@UnitNameLocalLanguage) 
				AND UnitParentID = @ParentID
			)
			OR 
			(
				dbo.StripPunctionsFromString(UnitNameEnglish) = dbo.StripPunctionsFromString(@UnitNameEnglish) 
				AND UnitParentID = @ParentID
			)
		)
		OR 
		(
			CountryID = @CountryID 
			AND UnitGenID = @UnitGenID
		)
END