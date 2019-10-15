/*
    NAME:   ImportTrainingEventVertical
    
    DESCR:  This is the import migration table that holds the direct import results of the 
            Training Event worksheet from the Training Event template xlsx files received 
            from Posts that are on-boarding their historical data into GTTS.

            The data is initially imported from the xlsx file into the [ImportTrainingEventVertical] 
            table (this table script) and then transposed (PIVOTed) into the [NewPostTrainingEvents]
            table.  The data is then validated and either imported into the GTTS data tables or 
            marked as an exception and not imported.
*/
CREATE TABLE [migration].[ImportTrainingEventVertical]
(
	[FieldName] NVARCHAR(255) NULL,
	[FieldData] NVARCHAR(MAX) NULL
)
ON [PRIMARY]
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'ImportTrainingEventVertical',
	@value = N'Import migration table that holds the direct import results of the Training Event worksheet from the Training Event template xlsx file.';
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventVertical',
    @level2type = N'COLUMN', @level2name = N'FieldName',
	@value = N'Name of the data element from the Training Event worksheet.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventVertical',
    @level2type = N'COLUMN', @level2name = N'FieldData',
	@value = N'Value entered by the Post for the specified [FieldName].'
GO