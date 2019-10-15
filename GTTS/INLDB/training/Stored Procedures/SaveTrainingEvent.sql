CREATE PROCEDURE training.SaveTrainingEvent
    @TrainingEventID BIGINT = NULL, 
    @Name NVARCHAR(255), 
    @NameInLocalLang NVARCHAR(255), 
    @TrainingEventTypeID INT, 
    @Justification NTEXT, 
    @Objectives	NTEXT, 
    @ParticipantProfile	NTEXT, 
    @SpecialRequirements NTEXT, 
    @ProgramID INT, 
    @TrainingUnitID	BIGINT, 
    @CountryID INT, 
    @PostID	INT, 
    @ConsularDistrictID	INT, 
    @OrganizerAppUserID	INT, 
    @PlannedParticipantCnt	INT, 
    @PlannedMissionDirectHireCnt INT, 
    @PlannedNonMissionDirectHireCnt INT,
    @PlannedMissionOutsourceCnt	INT, 
    @PlannedOtherCnt INT, 
    @EstimatedBudget DECIMAL(18,2), 
    @ActualBudget DECIMAL(18,2) = NULL,
    @EstimatedStudents INT, 
    @FundingSourceID INT, 
    @AuthorizingLawID INT, 
    @Comments NVARCHAR(4000) = NULL,
    @ModifiedByAppUserID INT, 
    @Locations NVARCHAR(MAX) = NULL, 
    @USPartnerAgencies NVARCHAR(MAX) = NULL, 
    @ProjectCodes NVARCHAR(MAX) = NULL, 
    @Stakeholders NVARCHAR(MAX) = NULL,
    @IAAs NVARCHAR(MAX) = NULL,
	@KeyActivities NVARCHAR(MAX) = NULL
AS
BEGIN

	SET NOCOUNT ON;

    DECLARE @Identity BIGINT, 
            @LocationReturn NVARCHAR(MAX)
    BEGIN TRY
        BEGIN TRANSACTION

        -- DETERMINE IF INSERT OR UPDATE BASED ON PASSED @TrainingEventID VALUE
        IF (@TrainingEventID IS NULL OR @TrainingEventID = -1) 
            BEGIN
                PRINT 'INSERTING NEW RECORD'

                -- INSERT NEW RECORD
                INSERT INTO training.TrainingEvents
                (
					[Name], NameInLocalLang, TrainingEventTypeID, Justification, 
					Objectives, ParticipantProfile, SpecialRequirements, ProgramID, TrainingUnitID, CountryID, PostID, ConsularDistrictID, 
                    OrganizerAppUserID, PlannedParticipantCnt, PlannedMissionDirectHireCnt, PlannedNonMissionDirectHireCnt, PlannedMissionOutsourceCnt, 
                    PlannedOtherCnt, EstimatedBudget, ActualBudget, EstimatedStudents, FundingSourceID, AuthorizingLawID, Comments, CreatedDate, ModifiedByAppUserID
				)
                VALUES 
                (
					@Name, @NameInLocalLang, @TrainingEventTypeID, @Justification, 
					@Objectives, @ParticipantProfile, @SpecialRequirements, @ProgramID, @TrainingUnitID, @CountryID, @PostID, @ConsularDistrictID, 
                    @OrganizerAppUserID, @PlannedParticipantCnt, @PlannedMissionDirectHireCnt, @PlannedNonMissionDirectHireCnt, @PlannedMissionOutsourceCnt, 
                    @PlannedOtherCnt, @EstimatedBudget, @ActualBudget, @EstimatedStudents, @FundingSourceID, @AuthorizingLawID, @Comments, GETUTCDATE(), @ModifiedByAppUserID
				)

                SET @Identity = SCOPE_IDENTITY();

				-- RETURN the Identity
				SELECT @Identity;

                -- INSERT STATUS RECORD (Created)
                EXEC training.InsertTrainingEventStatusLog @Identity, 'Created', null, @ModifiedByAppUserID

            END
        ELSE
            BEGIN
                PRINT 'UPDATING EXISTING RECORD'

                IF NOT EXISTS(SELECT * FROM training.TrainingEvents WHERE TrainingEventID = @TrainingEventID)
                    THROW 50000,  'The requested training event to be updated does not exist.',  1

                -- UPDATE RECORD
                UPDATE training.TrainingEvents SET
                        [Name] =                         @Name, 
                        NameInLocalLang =                @NameInLocalLang, 
                        TrainingEventTypeID =            @TrainingEventTypeID, 
                        Justification =                  @Justification, 
                        Objectives =                     @Objectives, 
                        ParticipantProfile =             @ParticipantProfile, 
                        SpecialRequirements =            @SpecialRequirements, 
                        ProgramID =                      @ProgramID, 
                        TrainingUnitID = 	             @TrainingUnitID, 
                        CountryID = 	                 @CountryID, 
                        PostID = 	                     @PostID, 
                        ConsularDistrictID = 	         @ConsularDistrictID, 
                        OrganizerAppUserID = 	         @OrganizerAppUserID, 
                        PlannedParticipantCnt = 	     @PlannedParticipantCnt, 
                        PlannedMissionDirectHireCnt = 	 @PlannedMissionDirectHireCnt, 
                        PlannedNonMissionDirectHireCnt = @PlannedNonMissionDirectHireCnt,
                        PlannedMissionOutsourceCnt = 	 @PlannedMissionOutsourceCnt, 
                        PlannedOtherCnt = 	             @PlannedOtherCnt, 
                        EstimatedBudget = 	             @EstimatedBudget, 
                        ActualBudget =                   @ActualBudget,
                        EstimatedStudents = 	         @EstimatedStudents, 
                        FundingSourceID = 	             @FundingSourceID, 
                        AuthorizingLawID = 	             @AuthorizingLawID, 
                        Comments =                       @Comments,
                        ModifiedByAppUserID = 	         @ModifiedByAppUserID
                WHERE TrainingEventID = @TrainingEventID

                SET @Identity = @TrainingEventID

				-- RETURN the Identity
				SELECT @Identity;
            END
            
        -- SAVE Locations
        IF (@Locations IS NOT NULL)
            EXEC training.SaveTrainingEventLocations @Identity,  @ModifiedByAppUserID,  @Locations

		-- SAVE Key Activities
        IF (@KeyActivities IS NOT NULL)
            EXEC training.SaveTrainingEventKeyActivities @Identity,  @ModifiedByAppUserID,  @KeyActivities

        -- SAVE US Partner Agencies
        IF (@USPartnerAgencies IS NOT NULL)
            EXEC training.SaveTrainingEventUSPartnerAgencies @Identity,  @ModifiedByAppUserID,  @USPartnerAgencies

        -- SAVE Project Codes
        EXEC training.SaveTrainingEventProjectCodes @Identity,  @ModifiedByAppUserID,  @ProjectCodes

        -- SAVE IAAs
        IF (@IAAs IS NOT NULL)
            EXEC training.SaveTrainingEventAuthorizingDocuments @Identity,  @ModifiedByAppUserID,  @IAAs

        -- SAVE Stakeholders 
        IF (@Stakeholders IS NOT NULL)
            EXEC training.SaveTrainingEventStakeholders @Identity,  @ModifiedByAppUserID,  @Stakeholders

        -- NO ERRORS,  COMMIT
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END