/*
    In order to maintain backwards compatibility with migrated data from TTS,
    we need to set the IDENTITY_INSERT property of the table ON before running
	the INSERT statement.  Afterwards, we set the IDENTITY_INSERT property to OFF,
	and set the seed value to the highest IDENTITY value which is currently 29.
*/

IF (NOT EXISTS(SELECT * FROM vetting.PostVettingConfiguration))
BEGIN
    /*  INSERT VALUES into the table    */
    INSERT INTO vetting.PostVettingConfiguration
        (PostID, MaxBatchSize, LeahyBatchLeadTime, CourtesyBatchLeadTime)
    VALUES
        (1083, 50, 35, 5)
END
GO
