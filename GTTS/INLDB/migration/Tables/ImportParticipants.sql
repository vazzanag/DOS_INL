/*
    NAME:   ImportParticipants
    
    DESCR:  This is the import migration table that holds the direct import results of the Training 
            Event Participants (AKA "Participants") worksheet from the Training Event template xlsx
            files received from Posts that are on-boarding their historical data into GTTS.

            The data is initially imported from the xlsx file into the [ImportParticipants] 
            table (this table script) and then processed into the [NewPostParticipants]
            table.  The data is then validated and either imported into the GTTS data tables or 
            marked as an exception and not imported.   
*/
CREATE TABLE [migration].[ImportParticipants]
(
	[ImportID] BIGINT NULL,									-- Import ID Number (if known).

    [ParticipantStatus] NVARCHAR(MAX) NULL,					-- Indicates if the Participant is an Event Participant or an Event Alternate.  

	[FirstMiddleName] NVARCHAR(MAX) NULL,					-- The Participant's Given & Middle Name(s).  

	[LastName] NVARCHAR(MAX) NULL,				 			-- The Participant's Family Name.  

	[NationalID] NVARCHAR(MAX) NULL,                        -- The Participant's National ID (if applicable in their country).  

	[Gender] NVARCHAR(MAX) NULL,                            -- The Participant's gender or sex.  

	[IsUSCitizen] NVARCHAR(MAX) NULL,				 		-- Indicates if the Participant is a US Citizen.  

	[DOB] NVARCHAR(MAX) NULL,								-- Participant's Date of Birth in MM/DD/YYYY format.  

	[POBCity] NVARCHAR(MAX) NULL,                           -- Name of the City that the Participant was born in.

    [POBState] NVARCHAR(MAX) NULL,                          -- Name of the State that the Participant was born in.

	[POBCountry] NVARCHAR(MAX) NULL,                        -- Name of the Country that the Participant was born in.

	[ResidenceCity] NVARCHAR(MAX) NULL,                     -- Name of the City that the Participant resides in.

    [ResidenceState] NVARCHAR(MAX) NULL,                    -- Name of the State that the Participant resides in.

	[ResidenceCountry] NVARCHAR(MAX) NULL,                  -- Name of the Country that the Participant resides in.

	[ContactEmail] NVARCHAR(MAX) NULL,                      -- Participant's Email Address.  

	[ContactPhone] NVARCHAR(MAX) NULL,                      -- The Participant's Telephone Number & Extension (if applicable).  

	[HighestEducation] NVARCHAR(MAX) NULL,                  -- The highest level of education the Participant has completed. 

	[EnglishLanguageProficiency] NVARCHAR(MAX) NULL,        -- The level of proficiency the Participant has in the English Language. 

    [UnitGenID]	NVARCHAR(MAX) NULL,                         -- The UnitGenID value that identifies the Participant's assigned Unit.  

	[UnitBreakdown] NVARCHAR(MAX) NULL,                     -- Identifies the Participant's assigned Unit.

    [UnitAlias] NVARCHAR(MAX) NULL,                         -- Alternate name for the Unit.

	[JobTitle] NVARCHAR(MAX) NULL,		 	   				-- The Participant's Job or Position Title.

    [Rank] NVARCHAR(MAX) NULL,                              -- The name of the Participant's Rank (if applicable).

	[UnitCommander] NVARCHAR(MAX) NULL,						-- Indicates if the Participant is a Unit Commander.   

	[YearsInPosition] NVARCHAR(MAX) NULL,                   -- The number of years that the Participant has held the position indicated by [JobTitle].

	[PoliceMilSecID] NVARCHAR(MAX) NULL,                    -- The Participant's Military, Police, or Security Services Badge or ID Number.

	[POCName] NVARCHAR(MAX) NULL,                           -- The name of the Participant's Unit Point of Contact.

	[POCEmailAddress] NVARCHAR(MAX) NULL,                   -- The Email Address for the Participant's Unit Point of Contact.

	[VettingType] NVARCHAR(MAX) NULL,                       -- Indicates the type of vetting that the Participant should be undergoing.

	[HasLocalGovTrust] NVARCHAR(MAX) NULL,                  -- Indicates if the Participant was vetted by the Host Nation's Security Agency.  

	[LocalGovTrustCertDate] NVARCHAR(MAX) NULL,				-- The date that the Participant was vetted by the Host Nation's Security Agency.

	[PassedExternalVetting] NVARCHAR(MAX) NULL,             -- Indicates if the Participant has been vetted by an external procees not covered by 
                                                            -- the [HasLocalGovTrust] flag above.                        
                                                          
	[ExternalVettingDescription] NVARCHAR(MAX) NULL,        -- The description of the external vetting process that was used. 

	[ExternalVettingDate] NVARCHAR(MAX) NULL,               -- The date that the external vetting process that was completed.  

	[DepartureCity]	NVARCHAR(MAX) NULL,                     -- Name of the City that the Participant is departing from.

	[PassportNumber] NVARCHAR(MAX) NULL,                    -- The Participant's current passport identification number.  

	[PassportExpirationDate] NVARCHAR(MAX) NULL,            -- The date that the Participant's current passport expires in MM/DD/YYYY format.

	[Comments] NVARCHAR(MAX) NULL,                          -- Comments or notes regarding the Participant.  
)
ON [PRIMARY]
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @value = N'Import migration table that holds the direct import results of the Participants worksheet from the Training Event template xlsx file.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'ImportID',
	@value = N'Import ID Number (if known).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'ParticipantStatus',
	@value = N'Indicates if the Participant is an Event Participant or Event Alternate.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'FirstMiddleName',
	@value = N'The Participant''s Given & Middle Name(s).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'LastName',
	@value = N'The Participant''s Family Name.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'NationalID',
	@value = N'The Participant''s National ID (if applicable in their country).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'Gender',
	@value = N'The Participant''s gender or sex.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'IsUSCitizen',
	@value = N'Indicates if the Participant is a US Citizen.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'DOB',
	@value = N'Participant''s Date of Birth in MM/DD/YYYY format.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'POBCity',
	@value = N'The City that the Participant was born in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'POBState',
	@value = N'The State that the Participant was born in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'POBCountry',
	@value = N'The Country that the Participant was born in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'ResidenceCity',
	@value = N'The City that the Participant resides in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'ResidenceState',
	@value = N'The State that the Participant resides in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'ResidenceCountry',
	@value = N'The Country that the Participant resides in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'ContactEmail',
	@value = N'The Participant''s Email Address.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'ContactPhone',
	@value = N'The Participant''s Telephone Number & Extension (if applicable).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'HighestEducation',
	@value = N'The highest level of education that the Participant has completed.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'EnglishLanguageProficiency',
	@value = N'The level of proficiency that the Participant has in the English Language.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'UnitGenID',
	@value = N'If the Unit Library for the Host Nation is in the [Units] table and the [UnitGenID] value for the Unit is known, then it will be in this column.  This value will be used to validate the Participant''s Unit information against the UnitLibrary for the Host Nation.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'UnitBreakdown',
	@value = N'If the Unit Library for the Host Nation is NOT in the [Units] table or the [UnitGenID] value for the Unit is not known, then this column will contain a Unit Breakdown of the Participant''s Unit.  The Unit Breakdown is comprised of the Name of the Participant''s Unit and the next 4 parent units of the Participant''s Unit.  Format should be: Great-Great-Grandparent Unit / Great-Grandparent Unit / Grandparent Unit / Parent Unit / Unit.  This value will be used to validate the Participant''s Unit information against the UnitLibrary for the Host Nation.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'UnitAlias',
	@value = N'If the Unit Library for the Host Nation is NOT in the [Units] table or the [UnitGenID] for the Unit is not known, then this column will contain any aliases or alternative names for the Participant''s Unit.  This value will be used to validate the Participant''s Unit information against the UnitLibrary for the Host Nation.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'JobTitle',
	@value = N'The Participant''s Job or Position Title.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'Rank',
	@value = N'The name of the Participant''s Rank (if applicable).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'UnitCommander',
	@value = N'Indicates if the Participant is a Unit Commander.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'YearsInPosition',
	@value = N'The number of years that the Participant has held the position indicated by [JobTitle].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'PoliceMilSecID',
	@value = N'The Participant''s Military, Police, or Security Services Badge or ID Number.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'POCName',
	@value = N'The name of the Point of Contact for the Particpant''s Unit.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'POCEmailAddress',
	@value = N'The Email Address for the Point of Contact for the Particpant''s Unit.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'VettingType',
	@value = N'Indicates the type of vetting that the Participant should be undergoing.'  
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'HasLocalGovTrust',
	@value = N'Indicates if the Participant has been vetted by the Host Nation''s Security Agency.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'LocalGovTrustCertDate',
	@value = N'The date that the Participant was vetted by the Host Nation''s Security Agency.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'PassedExternalVetting',
	@value = N'Indicates if the Participant has been vetted by an external procees not covered by the [HasLocalGovTrust] flag above.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'ExternalVettingDescription',
	@value = N'The description of the external vetting process that was used.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'ExternalVettingDate',
	@value = N'The date that the external vetting process that was completed.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'DepartureCity',
	@value = N'The name of the City that the Participant will be travelling from if they will need to travel to attend the Training Event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'PassportNumber',
	@value = N'The Participant''s current passport identification number.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'PassportExpirationDate',
	@value = N'The date that the Participant''s current passport expires in MM/DD/YYYY format.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportParticipants',
    @level2type = N'COLUMN', @level2name = N'Comments',
	@value = N'Comments or notes regarding the Participant.'