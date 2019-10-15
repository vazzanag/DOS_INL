/*
    NAME:   CreateNewPostParticipantsRecords
    
    DESCR:  This Stored Procedure receives 1 parameter and then inserts the 
            data from the [ImportParticipants] table into a new record in the 
            [NewPostParticipants] table.
*/
CREATE PROCEDURE [migration].[CreateNewPostParticipantsRecords]
    @NewPostImportID BIGINT = NULL	-- ID value that points to the [NewPostImportLog] 
									-- record that this Run Control Log message refers to.
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

            -- INSERT NEW RECORD
            INSERT INTO [migration].[NewPostParticipants]
            (   [NewPostImportID],
                [ParticipantStatus],
                [FirstMiddleName],
                [LastName],
                [NationalID],
                [Gender],
                [IsUSCitizen],
                [DOB],
                [POBCity],
                [POBState],
                [POBCountry],
                [ResidenceCity],
                [ResidenceState],
                [ResidenceCountry],
                [ContactEmail],
                [ContactPhone],
                [HighestEducation],
                [EnglishLanguageProficiency],
                [UnitGenID],
                [UnitBreakdown],
                [UnitAlias],
                [JobTitle],
                [Rank],
                [UnitCommander],
                [YearsInPosition],
                [PoliceMilSecID],
                [POCName],
                [POCEmailAddress],
                [VettingType],
                [HasLocalGovTrust],
                [LocalGovTrustCertDate],
                [PassedExternalVetting],
                [ExternalVettingDescription],
                [ExternalVettingDate],
                [DepartureCity],
                [PassportNumber],
                [PassportExpirationDate],
                [Comments],
                [ImportStatus],
                [ModifiedByAppUserID]
            )
            SELECT 
                imp.ImportID,					-- @NewPostImportID,
                imp.[ParticipantStatus],
                imp.[FirstMiddleName],
                imp.[LastName],
                imp.[NationalID],
                imp.[Gender],
                imp.[IsUSCitizen],
                imp.[DOB],
                imp.[POBCity],
                imp.[POBState],
                imp.[POBCountry],
                imp.[ResidenceCity],
                imp.[ResidenceState],
                imp.[ResidenceCountry],
                imp.[ContactEmail],
                imp.[ContactPhone],
                imp.[HighestEducation],
                imp.[EnglishLanguageProficiency],
                imp.[UnitGenID],
                imp.[UnitBreakdown],
                imp.[UnitAlias],
                imp.[JobTitle],
                imp.[Rank],
                imp.[UnitCommander],
                imp.[YearsInPosition],
                imp.[PoliceMilSecID],
                imp.[POCName],
                imp.[POCEmailAddress],
                imp.[VettingType],
                imp.[HasLocalGovTrust],
                imp.[LocalGovTrustCertDate],
                imp.[PassedExternalVetting],
                imp.[ExternalVettingDescription],
                imp.[ExternalVettingDate],
                imp.[DepartureCity],
                imp.[PassportNumber],
                imp.[PassportExpirationDate],
                imp.[Comments],
                'Uploaded',
                2
            FROM [migration].[ImportParticipants] imp;

        -- NO ERRORS, COMMIT
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
 END;