/*
    In order to maintain backwards compatibility with migrated data from TTS,
    we need to set the IDENTITY_INSERT property of the table ON before running
	the INSERT statement.  Afterwards, we set the IDENTITY_INSERT property to OFF,
	and set the seed value to the highest IDENTITY value.
*/

/*  Turn IDENTITY_INSERT ON    */
PRINT 'BEGIN training.TrainingEventParticipantTypes_Load'

IF (NOT EXISTS(SELECT * FROM [training].[TrainingEventParticipantTypes]))
    BEGIN 
        /*  INSERT VALUES into the table    */
        INSERT INTO [training].[TrainingEventParticipantTypes] ([TrainingEventParticipantTypeID], [Name] )
		VALUES 
		(1, 'Student'),
		(2, 'Instructor'),
		(3, 'Alternate'),
		(4, 'Removed');
    END
GO

