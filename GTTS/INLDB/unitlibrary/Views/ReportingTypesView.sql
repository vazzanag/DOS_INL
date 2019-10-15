CREATE VIEW [unitlibrary].[ReportingTypesView]
AS
	SELECT
		[ReportingTypeID],
		rt.[Name], 
		[Description], 
		rt.[IsActive],
		rt.[ModifiedByAppUserID],
		rt.[ModifiedDate]
	FROM
		unitlibrary.ReportingTypes rt
