CREATE FUNCTION [users].[FullName]
(
	@First NVARCHAR(100) = '',
	@Middle NVARCHAR(100) = '',
	@Last NVARCHAR(100) = ''
)
RETURNS NVARCHAR (300)
AS 
BEGIN
	SET @First = TRIM(@First);
	SET @Middle = TRIM(@Middle);
	SET @Last = TRIM(@Last);

	DECLARE @FullName NVARCHAR(300) = '';

	IF (LEN(@First) > 0) SET @FullName += @First + ' ';
	IF (LEN(@Middle) > 0) SET @FullName += @Middle + ' ';
	IF (LEN(@Last) > 0) SET @FullName += @Last;

	RETURN TRIM(@FullName);

END;

