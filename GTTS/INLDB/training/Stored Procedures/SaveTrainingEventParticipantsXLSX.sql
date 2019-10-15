CREATE PROCEDURE [training].[SaveTrainingEventParticipantsXLSX]
	@TrainingEventID BIGINT,
    @ModifiedByAppUserID INT,
	@Participants NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;

    DECLARE @Identity BIGINT
    BEGIN TRY
        BEGIN TRANSACTION

	DELETE FROM training.ParticipantsXLSX WHERE TrainingEventID = @TrainingEventID

	INSERT INTO training.ParticipantsXLSX
		  (TrainingEventID, PersonID, ParticipantStatus,FirstMiddleName, LastName, NationalID, Gender, IsUSCitizen, DOB,
		   POBCity, POBState, POBCountry, ResidenceCity, ResidenceState, ResidenceCountry, ContactEmail, ContactPhone, HighestEducation,
		   EnglishLanguageProficiency, PassportNumber, PassportExpirationDate, JobTitle, IsUnitCommander, YearsInPosition,
		   POCName, POCEmailAddress, [Rank], PoliceMilSecID, VettingType, HasLocalGovTrust, LocalGovTrustCertDate, PassedExternalVetting, ExternalVettingDescription, ExternalVettingDate,
	       DepartureCity, UnitGenID, UnitBreakdown, UnitAlias, Comments, MarkForAction, LoadStatus, Validations, ImportVersion, ModifiedByAppUserID)

	SELECT @TrainingEventID, json.PersonID, json.ParticipantStatus,json.FirstMiddleName, json.LastName, json.NationalID, json.Gender, json.IsUSCitizen, json.DOB,
		   json.POBCity, json.POBState, json.POBCountry, json.ResidenceCity, json.ResidenceState, json.ResidenceCountry, json.ContactEmail, json.ContactPhone, json.HighestEducation,
		   json.EnglishLanguageProficiency, json.PassportNumber, json.PassportExpirationDate, json.JobTitle, json.IsUnitCommander, json.YearsInPosition,
		   json.POCName, json.POCEmailAddress, json.[Rank], json.PoliceMilSecID, json.VettingType, json.HasLocalGovTrust, json.LocalGovTrustCertDate, json.PassedExternalVetting, json.ExternalVettingDescription, json.ExternalVettingDate,
	       json.DepartureCity, json.UnitGenID, json.UnitBreakdown, json.UnitAlias, json.Comments, json.MarkForAction, 'Uploaded', json.Validations, json.ImportVersion, @ModifiedByAppUserID
	  FROM OPENJSON(@Participants)
	  WITH (			
			[PersonID] BIGINT ,					
			[ParticipantStatus] NVARCHAR(15),
			[FirstMiddleName] NVARCHAR(200),
			[LastName] NVARCHAR(50) ,
			[NationalID] NVARCHAR(100) ,
			[Gender] CHAR(1) ,
			[IsUSCitizen] NVARCHAR(3) ,
			[DOB] DATETIME ,
			[POBCity] NVARCHAR(100) ,
			[POBState] NVARCHAR(75),
			[POBCountry] NVARCHAR(75),
			[ResidenceCity] NVARCHAR(100) ,
			[ResidenceState] NVARCHAR(75) ,
			[ResidenceCountry] NVARCHAR(75) ,
			[ContactEmail] NVARCHAR(256) ,
			[ContactPhone] NVARCHAR(50) ,
			[HighestEducation] NVARCHAR(25) ,
			[EnglishLanguageProficiency] NVARCHAR(50) ,
			[PassportNumber] NVARCHAR(100) ,
			[PassportExpirationDate] DATETIME ,
			[JobTitle] NVARCHAR(1024)  ,
			[IsUnitCommander] NVARCHAR(3) ,
			[YearsInPosition] INT ,
			[POCName] NVARCHAR(200) ,
			[POCEmailAddress] NVARCHAR(256) ,
			[Rank] NVARCHAR(100) ,
			[PoliceMilSecID] NVARCHAR(100) ,
			[VettingType] NVARCHAR(75) ,
			[HasLocalGovTrust] NVARCHAR(24) ,
			[LocalGovTrustCertDate] DATETIME ,
			[PassedExternalVetting] NVARCHAR(24) ,
			[ExternalVettingDescription]  NVARCHAR(50) ,
			[ExternalVettingDate] DATETIME ,
			[DepartureCity]	NVARCHAR(127) ,
			[UnitGenID]	NVARCHAR(50) ,
			[UnitBreakdown] NVARCHAR(2048) ,
			[UnitAlias] NVARCHAR(2048),
			[Comments] NVARCHAR(4000),
			[MarkForAction] NVARCHAR(15) ,
			[LoadStatus] NVARCHAR(15) ,
			[Validations] NVARCHAR(4000),
			[ImportVersion] INT,
			[ModifiedByAppUserID] INT) AS json


			SET @Identity = @TrainingEventID;

			COMMIT;

        -- RETURN the Identity
        SELECT @Identity;
	END TRY
	BEGIN CATCH
		ROLLBACK;
	    THROW;
	END CATCH
END
