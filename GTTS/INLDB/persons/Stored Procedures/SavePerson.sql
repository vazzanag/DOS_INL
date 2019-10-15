CREATE PROCEDURE [persons].[SavePerson]
	@PersonID BIGINT = null,
	@FirstMiddleNames NVARCHAR(50),
	@LastNames NVARCHAR(50) = null,
	@Gender CHAR(1),
	@IsUSCitizen BIT,
	@NationalID NVARCHAR(100) = null,
	@ResidenceLocationID BIGINT = null,
	@ContactEmail NVARCHAR(256) = null,
	@ContactPhone NVARCHAR(50) = null,
	@DOB DATETIME = null,
	@POBCityID INT = null,
	@FatherName NVARCHAR(200),
	@MotherName NVARCHAR(200),
	@HighestEducationID INT = null,
	@FamilyIncome DECIMAL = null,
	@EnglishLanguageProficiencyID INT = null,
	@PassportNumber NVARCHAR(100) = null,
	@PassportExpirationDate DATETIME = null,
    @PassportIssuingCountryID INT = null,
	@MedicalClearanceStatus BIT = null,
	@MedicalClearanceDate DATETIME = null,
	@DentalClearanceStatus  BIT = null,
	@DentalClearanceDate DATETIME = null,
	@PsychologicalClearanceStatus  BIT = null,
	@PsychologicalClearanceDate DATETIME = null,
	@ModifiedByAppUserID INT,
    @LanguagesJSON NVARCHAR(MAX) = NULL
AS
BEGIN

	DECLARE @Identity BIGINT

	BEGIN TRY
		BEGIN TRANSACTION

		IF (@PersonID IS NULL OR @PersonID = -1)
			BEGIN

				--INSERT NEW RECORD
				INSERT INTO persons.Persons
				(
					FirstMiddleNames, LastNames, Gender, IsUSCitizen, NationalID, ResidenceLocationID, 
					ContactEmail, ContactPhone, DOB, POBCityID, FatherName, MotherName, HighestEducationID, FamilyIncome, EnglishLanguageProficiencyID, 
					PassportNumber, PassportExpirationDate, PassportIssuingCountryID, MedicalClearanceStatus, 
					MedicalClearanceDate, PsychologicalClearanceStatus, PsychologicalClearanceDate, ModifiedByAppUserID
				)
				VALUES
				(
					@FirstMiddleNames, @LastNames, @Gender, @IsUSCitizen, @NationalID, @ResidenceLocationID, 
					@ContactEmail, @ContactPhone, @DOB, @POBCityID, @FatherName, @MotherName, @HighestEducationID, @FamilyIncome, @EnglishLanguageProficiencyID, 
					@PassportNumber, @PassportExpirationDate, @PassportIssuingCountryID, @MedicalClearanceStatus, 
					@MedicalClearanceDate, @PsychologicalClearanceStatus, @PsychologicalClearanceDate, @ModifiedByAppUserID
				)

				SET @Identity = SCOPE_IDENTITY();

		END

		ELSE
			BEGIN
				--UPDATE EXISTING RECORD
				UPDATE persons.Persons SET
						FirstMiddleNames =					@FirstMiddleNames,
						LastNames =							@LastNames,
						Gender =							@Gender,
						IsUSCitizen =						@IsUSCitizen,
						NationalID =						@NationalID,
						ResidenceLocationID =				@ResidenceLocationID, 
						ContactEmail =						@ContactEmail, 
						ContactPhone =						@ContactPhone, 
						DOB =								@DOB, 
						POBCityID =						    @POBCityID, 
						FatherName =						@FatherName,
						MotherName =						@MotherName, 
						HighestEducationID =				@HighestEducationID, 
						FamilyIncome =						@FamilyIncome,
						EnglishLanguageProficiencyID =		@EnglishLanguageProficiencyID,
						PassportNumber =					@PassportNumber,
						PassportExpirationDate =			@PassportExpirationDate,
                        PassportIssuingCountryID =          @PassportIssuingCountryID,
						MedicalClearanceStatus =			@MedicalClearanceStatus,
						MedicalClearanceDate =				@MedicalClearanceDate,
						PsychologicalClearanceStatus =		@PsychologicalClearanceStatus,
						PsychologicalClearanceDate =		@PsychologicalClearanceDate,
						ModifiedByAppUserID =				@ModifiedByAppUserID
				WHERE	PersonID = @PersonID

				SET @Identity = @PersonID;
			END

        -- SAVE Languages
        IF (@LanguagesJSON IS NOT NULL)
            EXEC persons.SavePersonLanguages @Identity,  @ModifiedByAppUserID,  @LanguagesJSON

        -- NO ERRORS,  COMMIT
		COMMIT;

		-- RETURN the Identity
        SELECT @Identity;
		
		END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END