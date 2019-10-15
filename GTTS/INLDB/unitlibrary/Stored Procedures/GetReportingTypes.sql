CREATE PROCEDURE [unitlibrary].[GetReportingTypes]
AS
BEGIN
	SELECT
		[ReportingTypeID],
		[Name], 
		[Description], 
		[IsActive],
		[ModifiedByAppUserID],
		[ModifiedDate]
	FROM 
		unitlibrary.ReportingTypesView
END
