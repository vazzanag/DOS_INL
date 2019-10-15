/*
Merge information from students and instructor into participants table
*/

-- Delete view unuseful.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = N'InstructorsView')
BEGIN
	DROP VIEW [search].[InstructorsView]
END

-- Delete view unuseful.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = N'PersonsNonParticipants')
BEGIN
	DROP VIEW [search].[PersonsNonParticipants]
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'TrainingEventStudents')
BEGIN
	PRINT 'EXISTS TrainingEventStudents'
		  
	-- From students to participants
	INSERT INTO [training].[TrainingEventParticipants](
		[TrainingEventParticipantTypeID],
		[PersonID],
		[TrainingEventID],
		[PersonsVettingID],
		[IsVIP],
		[IsParticipant],
		[IsTraveling],	
		[DepartureCityID],
		[DepartureDate],
		[ReturnDate],
		[HasLocalGovTrust],
		[PassedLocalGovTrust],
		[LocalGovTrustCertDate],
		[OtherVetting],
		[PassedOtherVetting],
		[OtherVettingDescription],
		[OtherVettingDate],
		[VisaStatusID],
		[PaperworkStatusID],
		[TravelDocumentStatusID],
		[OnboardingComplete],
		[RemovedFromEvent],
		[RemovedFromVetting],
		[RemovalReasonID],
		[RemovalCauseID],
		[DateCanceled],
		[Comments],
		[CreatedDate],
		[ModifiedByAppUserID])
	SELECT 
	CASE WHEN RemovedFromEvent = 1 THEN 4
	WHEN IsParticipant = 1 THEN 1 ELSE 3
	END AS 'ParticipantTypeID',
		[PersonID],
		[TrainingEventID],
		[PersonsVettingID],
		[IsVIP],
		[IsParticipant],
		[IsTraveling],	
		[DepartureCityID],
		[DepartureDate],
		[ReturnDate],
		[HasLocalGovTrust],
		[PassedLocalGovTrust],
		[LocalGovTrustCertDate],
		[OtherVetting],
		[PassedOtherVetting],
		[OtherVettingDescription],
		[OtherVettingDate],
		[VisaStatusID],
		[PaperworkStatusID],
		[TravelDocumentStatusID],
		[OnboardingComplete],
		[RemovedFromEvent],
		[RemovedFromVetting],
		[RemovalReasonID],
		[RemovalCauseID],
		[DateCanceled],
		[Comments],
		[CreatedDate],
		[ModifiedByAppUserID]
	FROM [training].[TrainingEventStudents] AS tbl_B
	WHERE NOT EXISTS (SELECT PersonID FROM [training].[TrainingEventParticipants] A2 WHERE A2.PersonID = tbl_B.[PersonID]);  

	-- Delete tables unuseful.
	ALTER TABLE [training].[TrainingEventStudents] SET (SYSTEM_VERSIONING = OFF)
	DROP TABLE [training].[TrainingEventStudents]
	DROP TABLE [training].[TrainingEventStudents_History]

END


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'TrainingEventInstructors')
BEGIN
	PRINT 'EXISTS TrainingEventInstructors'

	-- From instructor to participants
	INSERT INTO [training].[TrainingEventParticipants](
	[TrainingEventParticipantTypeID],
	[PersonID],
	[TrainingEventID],
	[PersonsVettingID],
	[IsVIP],
	[IsParticipant],
	[IsTraveling],	
	[DepartureCityID],
	[DepartureDate],
	[ReturnDate],
    [HasLocalGovTrust],
	[PassedLocalGovTrust],
	[LocalGovTrustCertDate],
    [OtherVetting],
	[PassedOtherVetting],
	[OtherVettingDescription],
	[OtherVettingDate],
	[VisaStatusID],
	[PaperworkStatusID],
	[TravelDocumentStatusID],
    [OnboardingComplete],
	[RemovedFromEvent],
	[RemovedFromVetting],
	[RemovalReasonID],
	[RemovalCauseID],
	[DateCanceled],
	[Comments],
	[CreatedDate],
	[ModifiedByAppUserID])
SELECT 
	2 AS 'ParticipantTypeID',
	[PersonID],
	[TrainingEventID],
	[PersonsVettingID],
	0,
	0,
	[IsTraveling],	
	[DepartureCityID],
	[DepartureDate],
	[ReturnDate],
    [HasLocalGovTrust],
	[PassedLocalGovTrust],
	[LocalGovTrustCertDate],
    [OtherVetting],
	[PassedOtherVetting],
	[OtherVettingDescription],
	[OtherVettingDate],
	[VisaStatusID],
	[PaperworkStatusID],
	[TravelDocumentStatusID],
    [OnboardingComplete],
	[RemovedFromEvent],
	[RemovedFromVetting],
	[RemovalReasonID],
	[RemovalCauseID],
	[DateCanceled],
	[Comments],
	[CreatedDate],
	[ModifiedByAppUserID]
FROM [training].[TrainingEventInstructors] AS tbl_B
WHERE NOT EXISTS (SELECT PersonID FROM [training].[TrainingEventParticipants] A2 WHERE A2.PersonID = tbl_B.[PersonID]); 

	-- Delete tables unuseful.
	ALTER TABLE [training].[TrainingEventInstructors] SET (SYSTEM_VERSIONING = OFF)
	DROP TABLE [training].[TrainingEventInstructors]
	DROP TABLE [training].[TrainingEventInstructors_History]

END






