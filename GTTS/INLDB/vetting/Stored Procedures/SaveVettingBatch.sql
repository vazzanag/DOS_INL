CREATE PROCEDURE [vetting].[SaveVettingBatch]
			@VettingBatchName NVARCHAR(150), 
			@TrainingEventID BIGINT, 
            @CountryID INT,
			@VettingBatchTypeID TINYINT,
			@AssignedToAppUserID INT,
			@VettingBatchStatusID SMALLINT, 
			@BatchRejectionReason NVARCHAR(250),
			@IsCorrectionRequired BIT,
			@CourtesyVettingOverrideFlag BIT,
			@CourtesyVettingOverrideReason NVARCHAR(300),
			@GTTSTrackingNumber NVARCHAR(100), 
			@LeahyTrackingNumber NVARCHAR(100), 
			@INKTrackingNumber NVARCHAR(50),
			@DateVettingResultsNeededBy DATETIME,
			@DateSubmitted DATETIME,
			@DateAccepted DATETIME,
			@DateSentToCourtesy DATETIME,
			@DateCourtesyCompleted DATETIME,
			@DateSentToLeahy DATETIME,
			@DateLeahyResultsReceived DATETIME,
			@DateVettingResultsNotified DATETIME,
			@VettingFundingSourceID SMALLINT,    
			@AuthorizingLawID SMALLINT,    
			@VettingBatchNotes NVARCHAR(500),
			@ModifiedByAppUserID INT,
			@ModifiedDate DATETIME,
			@PersonVettings NVARCHAR(max) 
AS
BEGIN

		DECLARE @Identity BIGINT, @Year INT, @BatchNumber INT, @GenTrackingNumber NVARCHAR(100), @BatchOrdinal SMALLINT

        SET @Year = YEAR(GETDATE());
        SET @BatchNumber = vetting.GetNextBatchNumber(@CountryID, @Year);
		IF @TrainingEventID IS NOT NULL
			SELECT @BatchOrdinal = ISNULL(MAX(VettingBatchOrdinal),0)+1 FROM  [vetting].[VettingBatches] WHERE TrainingEventID = @TrainingEventID
		ELSE
			SELECT @BatchOrdinal = ISNULL(MAX(VettingBatchOrdinal),0)+1 FROM  [vetting].[VettingBatches] WHERE TrainingEventID IS NULL

        IF (@GTTSTrackingNumber IS NULL OR @GTTSTrackingNumber = '')
            SET @GTTSTrackingNumber = vetting.GenerateGTTSTrackingNumber(@TrainingEventID, @BatchNumber, @CountryID, @Year)

		BEGIN TRY
			BEGIN TRANSACTION

				INSERT INTO [vetting].[VettingBatches]
				(
					VettingBatchName,
					VettingBatchNumber,
					VettingBatchOrdinal,
					TrainingEventID,
					CountryID,
					VettingBatchTypeID,
					AssignedToAppUserID,
					VettingBatchStatusID,
					BatchRejectionReason,
					IsCorrectionRequired,
					CourtesyVettingOverrideFlag,
					CourtesyVettingOverrideReason,
					GTTSTrackingNumber,
					LeahyTrackingNumber,
					INKTrackingNumber,
					DateVettingResultsNeededBy,
					DateSubmitted,
					DateAccepted,
					DateSentToCourtesy,
					DateCourtesyCompleted,
					DateSentToLeahy,
					DateLeahyResultsReceived,
					DateVettingResultsNotified,
					VettingFundingSourceID,
					AuthorizingLawID,
					VettingBatchNotes,
					AppUserIDSubmitted,
					ModifiedByAppUserID,
					ModifiedDate
				)
				VALUES
				(
					@VettingBatchName,
					@BatchNumber,
					@BatchOrdinal,
					@TrainingEventID, 
					@CountryID,
					@VettingBatchTypeID,
					@AssignedToAppUserID,
					@VettingBatchStatusID, 
					@BatchRejectionReason,
					ISNULL(@IsCorrectionRequired,0),
					@CourtesyVettingOverrideFlag,
					@CourtesyVettingOverrideReason,
					@GTTSTrackingNumber, 
					@LeahyTrackingNumber, 
					@INKTrackingNumber,
					@DateVettingResultsNeededBy,
					@DateSubmitted,
					@DateAccepted,
					@DateSentToCourtesy,
					@DateCourtesyCompleted,
					@DateSentToLeahy,
					@DateLeahyResultsReceived,
					@DateVettingResultsNotified,
					@VettingFundingSourceID,    
					@AuthorizingLawID,    
					@VettingBatchNotes,
					@ModifiedByAppUserID,
					@ModifiedByAppUserID,
					GETDATE()
				)	  

			SET @Identity = SCOPE_IDENTITY()

			INSERT INTO [vetting].[PersonsVetting]
					(
						PersonsUnitLibraryInfoID, 
						VettingBatchID, 
						VettingPersonStatusID, 
						Name1,
						Name2,
						Name3,
						Name4,
						Name5,
						VettingStatusDate, 
						VettingNotes,
						IsReVetting,
						ModifiedByAppUserID
					)
			SELECT json.PersonsUnitLibraryInfoID, 
					@Identity, 
					json.VettingPersonStatusID, 
					CONVERT(varchar, json.Name1) COLLATE SQL_Latin1_General_Cp1251_CS_AS,
					CONVERT(varchar, json.Name2) COLLATE SQL_Latin1_General_Cp1251_CS_AS,
					CONVERT(varchar, json.Name3) COLLATE SQL_Latin1_General_Cp1251_CS_AS,
					CONVERT(varchar, json.Name4) COLLATE SQL_Latin1_General_Cp1251_CS_AS,
					CONVERT(varchar, json.Name5) COLLATE SQL_Latin1_General_Cp1251_CS_AS,
					json.VettingStatusDate, 
					json.VettingNotes, 
					json.IsReVetting,
					json.ModifiedByAppUserID
			FROM OPENJSON(@PersonVettings)
			WITH (			
					[PersonsUnitLibraryInfoID] BIGINT, 
					[VettingPersonStatusID] SMALLINT, 
					[Name1] NVARCHAR(50),
					[Name2] NVARCHAR(50),
					[Name3] NVARCHAR(50),
					[Name4] NVARCHAR(50),
					[Name5] NVARCHAR(50),
					[VettingStatusDate] DATETIME, 
					[VettingNotes] NVARCHAR(750),
					[IsReVetting] BIT,
					[ModifiedByAppUserID] INT
					) AS json

			COMMIT;	

			-- RETURN the Identity
			SELECT @Identity;

		END TRY
		BEGIN CATCH
			ROLLBACK;
			THROW;
		END CATCH
END

