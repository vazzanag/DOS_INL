/*
    NAME:   ImportInstructors
    
    DESCR:  This is the import migration table that holds the direct import results of the Training 
            Event Instructors (AKA "Instructors") worksheet from the Training Event template xlsx
            files received from Posts that are on-boarding their historical data into GTTS.

            The data is initially imported from the xlsx file into the [ImportInstructors] 
            table (this table script) and then processed into the [NewPostInstructors]
            table.  The data is then validated and either imported into the GTTS data tables or 
            marked as an exception and not imported.
*/
CREATE TABLE [migration].[ImportInstructors]
(
	[ImportID] BIGINT NULL,									-- Import ID Number (if known).

   	[FirstMiddleName] NVARCHAR(MAX) NULL,					-- The Instructor's Given & Middle Name(s).  

	[LastName] NVARCHAR(MAX) NULL,				 			-- The Instructor's Family Name.  

	[NationalID] NVARCHAR(MAX) NULL,                        -- The Instructor's National ID (if applicable in their country).  

	[Gender] NVARCHAR(MAX) NULL,                            -- The Instructor's gender or sex.  

	[IsUSCitizen] NVARCHAR(MAX) NULL,				 		-- Indicates if the Instructor is a US Citizen.  

	[DOB] NVARCHAR(MAX) NULL,                               -- Instructor's Date of Birth in MM/DD/YYYY format.  

	[POBCity] NVARCHAR(MAX) NULL,                           -- Name of the City that the Instructor was born in.

    [POBState] NVARCHAR(MAX) NULL,                          -- Name of the State that the Instructor was born in.

	[POBCountry] NVARCHAR(MAX) NULL,                        -- Name of the Country that the Instructor was born in.

	[ResidenceCity] NVARCHAR(MAX) NULL,                     -- Name of the City that the Instructor resides in.

    [ResidenceState] NVARCHAR(MAX) NULL,                    -- Name of the State that the Instructor resides in.

	[ResidenceCountry] NVARCHAR(MAX) NULL,                  -- Name of the Country that the Instructor resides in.

	[ContactEmail] NVARCHAR(MAX) NULL,                      -- Instructor's Email Address.  

	[ContactPhone] NVARCHAR(MAX) NULL,                      -- The Instructor's Telephone Number & Extension (if applicable).  

	[HighestEducation] NVARCHAR(MAX) NULL,                  -- The highest level of education the Instructor has completed. 

	[EnglishLanguageProficiency] NVARCHAR(MAX) NULL,        -- The level of proficiency the Instructor has in the English Language. 

    [UnitGenID]	NVARCHAR(MAX) NULL,                         -- The UnitGenID value that identifies the Instructor's assigned Unit.  

	[UnitBreakdown] NVARCHAR(MAX) NULL,                     -- Identifies the Instructor's assigned Unit.

    [UnitAlias] NVARCHAR(MAX) NULL,                         -- Alternate name for the Unit.

	[JobTitle] NVARCHAR(MAX) NULL,		 	   				-- The Instructor's Job or Position Title.

    [Rank] NVARCHAR(MAX) NULL,                              -- The name of the Instructor's Rank (if applicable).

	[UnitCommander] NVARCHAR(MAX) NULL,						-- Indicates if the Instructor is a Unit Commander.   

	[YearsInPosition] NVARCHAR(MAX) NULL,                   -- The number of years that the Instructor has held the position indicated by [JobTitle].

	[PoliceMilSecID] NVARCHAR(MAX) NULL,                    -- The Instructor's Military, Police, or Security Services Badge or ID Number.

	[POCName] NVARCHAR(MAX) NULL,                           -- The name of the Instructor's Unit Point of Contact.

	[POCEmailAddress] NVARCHAR(MAX) NULL,                   -- The Email Address for the Instructor's Unit Point of Contact.

	[VettingType] NVARCHAR(MAX) NULL,                       -- Indicates the type of vetting that the Instructor should be undergoing.

	[HasLocalGovTrust] NVARCHAR(MAX) NULL,                  -- Indicates if the Instructor was vetted by the Host Nation's Security Agency.  

	[LocalGovTrustCertDate] NVARCHAR(MAX) NULL,			    -- The date that the Instructor was vetted by the Host Nation's Security Agency.

	[PassedExternalVetting] NVARCHAR(MAX) NULL,             -- Indicates if the Instructor has been vetted by an external procees not covered by 
                                                            -- the [HasLocalGovTrust] flag above.                        
                                                          
	[ExternalVettingDescription] NVARCHAR(MAX) NULL,        -- The description of the external vetting process that was used. 

	[ExternalVettingDate] NVARCHAR(MAX) NULL,               -- The date that the external vetting process that was completed.  

	[DepartureCity]	NVARCHAR(MAX) NULL,                     -- Name of the City that the Instructor is departing from.

	[PassportNumber] NVARCHAR(MAX) NULL,                    -- The Instructor's current passport identification number.  

	[PassportExpirationDate] NVARCHAR(MAX) NULL,            -- The date that the Instructor's current passport expires in MM/DD/YYYY format.

	[Comments] NVARCHAR(MAX) NULL,                          -- Comments or notes regarding the Instructor.  
)
ON [PRIMARY]
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @value = N'Import migration table that holds the direct import results of the Instructors worksheet from the Training Event template xlsx file.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'ImportID',
	@value = N'Import ID Number (if known).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'FirstMiddleName',
	@value = N'The Instructor''s Given & Middle Name(s).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'LastName',
	@value = N'The Instructor''s Family Name.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'NationalID',
	@value = N'The Instructor''s National ID (if applicable in their country).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'Gender',
	@value = N'The Instructor''s gender or sex.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'IsUSCitizen',
	@value = N'Indicates if the Instructor is a US Citizen.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'DOB',
	@value = N'Instructor''s Date of Birth in MM/DD/YYYY format.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'POBCity',
	@value = N'The City that the Instructor was born in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'POBState',
	@value = N'The State that the Instructor was born in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'POBCountry',
	@value = N'The Country that the Instructor was born in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'ResidenceCity',
	@value = N'The City that the Instructor resides in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'ResidenceState',
	@value = N'The State that the Instructor resides in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'ResidenceCountry',
	@value = N'The Country that the Instructor resides in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'ContactEmail',
	@value = N'The Instructor''s Email Address.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'ContactPhone',
	@value = N'The Instructor''s Telephone Number & Extension (if applicable).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'HighestEducation',
	@value = N'The highest level of education that the Instructor has completed.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'EnglishLanguageProficiency',
	@value = N'The level of proficiency that the Instructor has in the English Language.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'UnitGenID',
	@value = N'If the Unit Library for the Host Nation is in the [Units] table and the [UnitGenID] value for the Unit is known, then it will be in this column.  This value will be used to validate the Instructor''s Unit information against the UnitLibrary for the Host Nation.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'UnitBreakdown',
	@value = N'If the Unit Library for the Host Nation is NOT in the [Units] table or the [UnitGenID] value for the Unit is not known, then this column will contain a Unit Breakdown of the Instructor''s Unit.  The Unit Breakdown is comprised of the Name of the Instructor''s Unit and the next 4 parent units of the Instructor''s Unit.  Format should be: Great-Great-Grandparent Unit / Great-Grandparent Unit / Grandparent Unit / Parent Unit / Unit.  This value will be used to validate the Instructor''s Unit information against the UnitLibrary for the Host Nation.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'UnitAlias',
	@value = N'If the Unit Library for the Host Nation is NOT in the [Units] table or the [UnitGenID] for the Unit is not known, then this column will contain any aliases or alternative names for the Instructor''s Unit.  This value will be used to validate the Instructor''s Unit information against the UnitLibrary for the Host Nation.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'JobTitle',
	@value = N'The Instructor''s Job or Position Title.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'Rank',
	@value = N'The name of the Instructor''s Rank (if applicable).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'UnitCommander',
	@value = N'Indicates if the Instructor is a Unit Commander.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'YearsInPosition',
	@value = N'The number of years that the Instructor has held the position indicated by [JobTitle].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'PoliceMilSecID',
	@value = N'The Instructor''s Military, Police, or Security Services Badge or ID Number.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'POCName',
	@value = N'The name of the Point of Contact for the Particpant''s Unit.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'POCEmailAddress',
	@value = N'The Email Address for the Point of Contact for the Particpant''s Unit.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'VettingType',
	@value = N'Indicates the type of vetting that the Instructor should be undergoing.'  
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'HasLocalGovTrust',
	@value = N'Indicates if the Instructor has been vetted by the Host Nation''s Security Agency.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'LocalGovTrustCertDate',
	@value = N'The date that the Instructor was vetted by the Host Nation''s Security Agency.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'PassedExternalVetting',
	@value = N'Indicates if the Instructor has been vetted by an external procees not covered by the [HasLocalGovTrust] flag above.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'ExternalVettingDescription',
	@value = N'The description of the external vetting process that was used.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'ExternalVettingDate',
	@value = N'The date that the external vetting process that was completed.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'DepartureCity',
	@value = N'The name of the City that the Instructor will be travelling from if they will need to travel to attend the Training Event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'PassportNumber',
	@value = N'The Instructor''s current passport identification number.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'PassportExpirationDate',
	@value = N'The date that the Instructor''s current passport expires in MM/DD/YYYY format.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportInstructors',
    @level2type = N'COLUMN', @level2name = N'Comments',
	@value = N'Comments or notes regarding the Instructor.'