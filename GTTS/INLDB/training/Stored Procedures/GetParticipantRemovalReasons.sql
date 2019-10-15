CREATE PROCEDURE [training].[GetParticipantRemovalReasons]
AS
BEGIN

	SET NOCOUNT ON;

	SELECT RemovalReasonID, 
		   Description, 
		   IsActive, 
		   SortControl
	FROM training.RemovalReasons

END