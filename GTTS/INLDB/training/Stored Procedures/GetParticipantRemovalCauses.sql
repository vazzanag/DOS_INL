CREATE PROCEDURE [training].[GetParticipantRemovalCauses]
AS
BEGIN

	SET NOCOUNT ON;

	SELECT RemovalCauseID,
		   RemovalReasonID, 
		   Description, 
		   IsActive
	FROM training.RemovalCauses

END