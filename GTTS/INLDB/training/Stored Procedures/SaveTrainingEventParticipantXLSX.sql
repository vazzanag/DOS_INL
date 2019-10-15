CREATE PROCEDURE [training].[SaveTrainingEventParticipantXLSX]
	@ParticipantXLSXID BIGINT,
	@ParticipantStatus  NVARCHAR(50),
	@FirstMiddleName NVARCHAR(200),
    @LastName NVARCHAR(50) ,
	@NationalID NVARCHAR(100) ,
	@Gender CHAR(1),
	@IsUSCitizen NVARCHAR(3) ,
	@DOB DATETIME ,
	@POBCity NVARCHAR(100) ,
	@POBState NVARCHAR(75),
	@POBCountry NVARCHAR(75),
	@ResidenceCity NVARCHAR(100) ,
	@ResidenceState NVARCHAR(75),
	@ResidenceCountry NVARCHAR(75),
	@ContactEmail NVARCHAR(256),
	@ContactPhone NVARCHAR(50),
	@UnitGenID NVARCHAR(50),
	@VettingType NVARCHAR(75),
	@JobTitle NVARCHAR(1024),
	@YearsInPosition INT,
	@IsUnitCommander NVARCHAR(3),
	@PoliceMilSecID NVARCHAR(100),
	@POCName NVARCHAR(200),
	@POCEmail NVARCHAR(256),
	@DepartureCity NVARCHAR(127),
	@DepartureCityID INT,
	@DepartureStateID INT,
	@DepartureCountryID INT,
	@PassportNumber NVARCHAR(100),
	@PassportExpirationDate DATETIME,
	@Comments nvarchar(4000),
	@HasLocalGovTrust NVARCHAR(24)=null,
	@LocalGovTrustCertDate DATETIME = null,
	@PassedExternalVetting NVARCHAR(24)=null,
	@ExternalVettingDescription NVARCHAR(150) = null,
	@ExternalVettingDate DATETIME = null,
	@EnglishLanguageProficiency NVARCHAR(50) = null,
	@HighestEducation NVARCHAR(25)=null,
	@Rank NVARCHAR(100)=null,
	@PersonID BIGINT = NULL,
	@ModifiedByAppUserID INT
AS
BEGIN
	
	BEGIN TRY
        BEGIN TRANSACTION
	
		IF NOT EXISTS(SELECT * FROM training.ParticipantsXLSX WHERE ParticipantXLSXID = @ParticipantXLSXID)
					THROW 50000,  'The requested participant does not exist.',  1

				 -- UPDATE RECORD
				 UPDATE training.ParticipantsXLSX SET
						PersonID =						 @PersonID,
						ParticipantStatus =              @ParticipantStatus,
						FirstMiddleName =				 @FirstMiddleName,
						LastName =						 @LastName,
						NationalID =					 @NationalID,
						Gender =						 @Gender,
						IsUSCitizen =					 @IsUSCitizen,
						DOB =							 @DOB,
						POBCity =						 @POBCity,
						POBState =						 @POBState,
						POBCountry =					 @POBCountry,
						ResidenceCity =					 @ResidenceCity,
						ResidenceState =				 @ResidenceState,
						ResidenceCountry =				 @ResidenceCountry,
						ContactEmail =					 @ContactEmail,
						ContactPhone =					 @ContactPhone,
						UnitGenID =						 @UnitGenID,
						VettingType =				     @VettingType,
						JobTitle =						 @JobTitle,
						YearsInPosition =				 @YearsInPosition,
						IsUnitCommander =				 @IsUnitCommander,
						PoliceMilSecID =				 @PoliceMilSecID,
						POCName =						 @POCName,
						POCEmailAddress =				 @POCEmail,
						DepartureCity =					 @DepartureCity,
						PassportNumber =				 @PassportNumber,
						PassportExpirationDate =		 @PassportExpirationDate,
						Comments =						 @Comments,
						HasLocalGovTrust =               @HasLocalGovTrust,
					    LocalGovTrustCertDate =			 @LocalGovTrustCertDate, 
					    PassedExternalVetting =			 @PassedExternalVetting,
						ExternalVettingDate =			 @ExternalVettingDate, 
						ExternalVettingDescription =	 @ExternalVettingDescription,
						EnglishLanguageProficiency =	 @EnglishLanguageProficiency,
						HighestEducation =				 @HighestEducation,
						[Rank] =						 @Rank,
						DepartureCityID =				 @DepartureCityID,
						DepartureCountryID =			 @DepartureCountryID,
						DepartureStateID =				 @DepartureStateID,
						ModifiedByAppUserID = 	         @ModifiedByAppUserID
				  WHERE ParticipantXLSXID = @ParticipantXLSXID

				  COMMIT;

				 SELECT ParticipantXLSXID, TrainingEventID, PersonID, ParticipantStatus,FirstMiddleName, LastName, NationalID, Gender, IsUSCitizen, DOB,
						POBCity, POBState, POBCountry, ResidenceCity, ResidenceState, ResidenceCountry, ContactEmail, ContactPhone, HighestEducation,
						EnglishLanguageProficiency, PassportNumber, PassportExpirationDate, UnitGenID, VettingType, JobTitle, IsUnitCommander, YearsInPosition,
						POCName, POCEmailAddress, [Rank], PoliceMilSecID, VettingType, HasLocalGovTrust, LocalGovTrustCertDate, PassedExternalVetting, ExternalVettingDescription, ExternalVettingDate,
						DepartureCity, UnitGenID, UnitBreakdown, UnitAlias, Comments, MarkForAction, LoadStatus, Validations, ImportVersion, ModifiedByAppUserID
				   FROM training.ParticipantsXLSX
				  WHERE ParticipantXLSXID = @ParticipantXLSXID
		

	    END TRY
		BEGIN CATCH
			ROLLBACK;
			THROW;
		END CATCH
END