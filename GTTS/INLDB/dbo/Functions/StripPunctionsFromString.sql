CREATE FUNCTION [dbo].[StripPunctionsFromString]( @String nvarchar(500) ) 
RETURNS varchar(300) 
AS

BEGIN
   DECLARE @i int

   /*get index of first occurance of symbol (characters don't match a-z and 0-9)*/
   SET @i = (SELECT PATINDEX('%[^a-z^0-9 ]%', @String))

   /*loop through string till it find the last punctuation */
	WHILE (@i > 0)
	BEGIN
		  
		  /* replace punctuation with single space */
		  SET @String = (SELECT REPLACE(@String, SUBSTRING(@String, @i, 1), ' '))
		  SET @i = (SELECT PATINDEX('%[^a-z^0-9 ]%', @String))

	END

	/*loop through string and change multi space to single space */
    WHILE CHARINDEX('  ',@String  ) > 0
	BEGIN
		SET @String = REPLACE(@String, '  ', ' ')
	END
   RETURN @String
END